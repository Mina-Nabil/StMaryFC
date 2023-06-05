import 'package:StMaryFA/models/HistoryRow.dart';
import 'package:StMaryFA/models/User.dart';
import 'package:StMaryFA/providers/UsersProvider.dart';
import 'package:StMaryFA/screens/GroupsScreen.dart';
import 'package:StMaryFA/widgets/AttendanceList.dart';
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
  double totalLeft = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) async {
      history = await Provider.of<UsersProvider>(context, listen: false).getPlayerHistory(widget.user.id);
      totalLeft = Provider.of<UsersProvider>(context, listen: false).historyTotal;
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
              GroupLabel("History / L " + totalLeft?.toStringAsFixed(0)),
              if (loaded)
                ...history.map((e) => GestureDetector(
                      onLongPress: () => showBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25.0),
                        )),
                        builder: (context) => Container(
                          width: double.maxFinite,
                          height: 500,
                          alignment: Alignment.center,
                          child: AttendanceList(widget.user.id, e.year, e.month),
                        ),
                      ),
                      child: Card(
                          child: ListTile(
                              tileColor: Color.fromRGBO(254, 250, 241, 1),
                              trailing: Text("${e.month} - ${e.year}", style: TextStyle(fontSize: 12)),
                              title: Row(
                                children: [
                                  Container(
                                    width: 35,
                                    child: Column(
                                      children: [
                                        Text("A", style: TextStyle(fontSize: 12)),
                                        Text(e.attended.toString(), style: TextStyle(fontSize: 14))
                                      ],
                                    ),
                                  ),
                                  Container(
                                      width: 35,
                                      child: Column(
                                        children: [
                                          Text("P", style: TextStyle(fontSize: 12)),
                                          Text(e.paid.toString(), style: TextStyle(fontSize: 14))
                                        ],
                                      )),
                                  Container(
                                      width: 35,
                                      child: Column(
                                        children: [
                                          Text("D", style: TextStyle(fontSize: 12)),
                                          Text(e.due.toString(), style: TextStyle(fontSize: 14))
                                        ],
                                      )),
                                  Container(
                                      width: 45,
                                      child: Column(
                                        children: [
                                          Text("L", style: TextStyle(fontSize: 12)),
                                          Text(
                                              e.due == "N/A"
                                                  ? e.due
                                                  : ((double.tryParse(e.due) ?? 0) - (double.tryParse(e.paid) ?? 0))
                                                      .toStringAsFixed(0),
                                              style: TextStyle(fontSize: 14))
                                        ],
                                      ))
                                ],
                              ))),
                    ))
            ])),
    );
  }
}
