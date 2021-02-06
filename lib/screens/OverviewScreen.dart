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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration:
          BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15)), border: Border.all(color: Color.fromRGBO(79, 50, 0, 1))),
      child: ListView(
          children: []
            ..addAll([
              GroupLabel("History"),
              ...Provider.of<UsersProvider>(context, listen: true).getPlayerHistory(user).map((e) => Container(
                    child: Card(
                      child: (e.count > 0)
                          ? ListTile(
                              tileColor: Color.fromRGBO(254, 250, 241, 1),
                              trailing: Text("Players: ${e.count}"),
                              leading: ButtonTheme(
                                minWidth: 0,
                                height: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                padding: EdgeInsets.all(0),
                                child: RaisedButton(
                                    color: Color.fromRGBO(254, 250, 241, 1),
                                    onPressed: () => toggle(e.id),
                                    child: FittedBox(child: Icon(FontAwesomeIcons.solidFutbol, color: (e.isActive) ? Colors.green : Colors.red))),
                              ),
                              title: Text(e.name, style: TextStyle(fontSize: 18)))
                          : ListTile(
                                  tileColor: Color.fromRGBO(254, 250, 241, 1),
                                  trailing: Text("Players: ${e.count}"),
                                  title: Text(e.name, style: TextStyle(fontSize: 18))),
                    ),
                  ))
            ])),
    );
  }
}
