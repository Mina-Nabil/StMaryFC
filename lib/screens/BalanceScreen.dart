import 'package:StMaryFA/models/BalanceRow.dart';
import 'package:StMaryFA/models/User.dart';
import 'package:StMaryFA/providers/UsersProvider.dart';
import 'package:StMaryFA/screens/GroupsScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                      child: ListTile(
                          tileColor: Color.fromRGBO(254, 250, 241, 1),
                          trailing:Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                                    children: [ 
                                      Text("by ${b.collectedBy.userName}", style: TextStyle(fontSize: 12)) ,
                                      Text("${b.date.day}/${b.date.month}/${b.date.year}", style: TextStyle(fontSize: 12)) ,
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
                                      Text(
                                       ((b.isSettlment) ? "(S) " : "") + b.title,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(fontSize: 10)
                                      )
                                    ],
                                  )),
                            ],
                          ))),
                )
            ])),
    );
  }
}
