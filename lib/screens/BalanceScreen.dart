import 'package:StMaryFA/helpers/PaymentsHelper.dart';
import 'package:StMaryFA/models/BalanceRow.dart';
import 'package:StMaryFA/models/User.dart';
import 'package:StMaryFA/providers/UsersProvider.dart';
import 'package:StMaryFA/screens/GroupsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BalanceScreen extends StatefulWidget {
  final User user;

  BalanceScreen(this.user);

  @override
  _BalanceScreenState createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  bool loaded = false;
  List<BalanceRow> history;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) async {
      history = await Provider.of<UsersProvider>(context, listen: false).getPlayerBalanceHistory(widget.user.id);
      setState(() {
        loaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
      ),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          border: Border.all(color: Color.fromRGBO(79, 50, 0, 1))),
      child: ListView(
          children: []..addAll([
              GroupLabel("Balance"),
              if (loaded)
                ...history.map(
                  (b) => Card(
                      child: GestureDetector(
                        onLongPress: () =>
                          confirmThen("Send Whatsapp", "Are you sure you want to send the update from Whatsapp?", () => sendWhatsappMessage(b.id))
                        ,
                          child: ListTile(
                              tileColor: Color.fromRGBO(254, 250, 241, 1),
                              trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Text("by ${b.collectedBy.userName}", style: TextStyle(fontSize: 12)),
                                Text("${b.date.day}/${b.date.month}/${b.date.year}", style: TextStyle(fontSize: 12)),
                              ]),
                              title: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Text("B",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: b.newBalance >= 0 ? Colors.green : Colors.red,
                                            )),
                                        Text(b.newBalance.toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: b.newBalance >= 0 ? Colors.green : Colors.red,
                                            ))
                                      ],
                                    ),
                                  ),
                                  Container(
                                      width: 40,
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          Text("A",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: b.amount >= 0 ? Colors.green : Colors.red,
                                              )),
                                          Text(b.amount.toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: b.amount >= 0 ? Colors.green : Colors.red,
                                              ))
                                        ],
                                      )),
                                  Container(
                                      alignment: Alignment.center,
                                      width: 105,
                                      padding: EdgeInsets.symmetric(horizontal: 2),
                                      child: Column(
                                        children: [
                                          Text(((b.isSettlment) ? "(S) " : "") + b.title,
                                              overflow: TextOverflow.clip, style: TextStyle(fontSize: 10))
                                        ],
                                      )),
                                ],
                              )))),
                )
            ])),
    );
  }

  void confirmThen(title, message, Function callback) async {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                CupertinoDialogAction(
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    callback();
                  },
                ),
                CupertinoDialogAction(
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ));
  }

  void sendWhatsappMessage(int id) async {
    try {
      Map<String, String> lastUpdateMsg = await PaymentsHelper.getUpdateMessage(id, widget.user.id);
      String number = lastUpdateMsg["number"];
      String msg = lastUpdateMsg["update_message"];
      final url = "whatsapp://send?phone=+2$number&text=$msg";
      final uri = Uri.parse(Uri.encodeFull(url));
      _launchURL(uri);

    } catch (e) {

      debugPrint(e.toString());
    }
  }

 void _launchURL(Uri url) async {
    print(url);
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      throw 'Could not launch $url';
    }
  }
}
