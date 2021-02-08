import 'package:StMaryFA/models/HistoryRow.dart';
import 'package:StMaryFA/models/User.dart';
import 'package:StMaryFA/providers/UsersProvider.dart';
import 'package:StMaryFA/screens/GroupsScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverviewScreen extends StatefulWidget {
  final User user;

  OverviewScreen(this.user);

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  bool loaded = false;
  List<HistoryRow> history;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) async {
      history = await Provider.of<UsersProvider>(context, listen: false).getPlayerHistory(widget.user.id);

      setState(() {
        loaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration:
          BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15)), border: Border.all(color: Color.fromRGBO(79, 50, 0, 1))),
      child: ListView(
          children: []..addAll([
              GroupLabel("History"),
              if(loaded)
              ...history.map((e) => Container(
                    child: Card(
                        child: ListTile(
                            tileColor: Color.fromRGBO(254, 250, 241, 1),
                            trailing: Text("${e.month} - ${e.year}"),
                            title: Text("A " + e.attended.toString() + " - Paid " + e.paid.toString(), style: TextStyle(fontSize: 18)))),
                  ))
            ])),
    );
  }
}
