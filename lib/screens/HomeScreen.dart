import 'dart:async';
import 'package:StMaryFA/global.dart';
import 'package:StMaryFA/providers/Auth.dart';
import 'package:StMaryFA/providers/UsersProvider.dart';
import 'package:StMaryFA/screens/FAScreen.dart';
import 'package:StMaryFA/screens/SettingsScreen.dart';
import 'package:StMaryFA/widgets/DefDrawer.dart';
import 'package:StMaryFA/widgets/UserCard.dart';
import 'package:StMaryFA/widgets/UserDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer searchTimer;
  List<int> selectedIds = [];
  final Duration searchDelay = Duration(milliseconds: 500);
  bool enableMenu = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_)async{
      Provider.of<UsersProvider>(context, listen: false).search("");
      enableMenu = (await Server.userType == 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FAScreen(
      appBar: AppBar(title: Text("Check-in"), actions: [
        IconButton(
          icon: FaIcon(FontAwesomeIcons.cog),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsScreen())),
        )
      ]),
      drawer: DefDrawer(),
      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
      body: Container(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Search Bar
              Container(
                width: double.infinity,
                child: TextField(
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  onChanged: (searchString) {
                    if (searchTimer != null) {
                      setState(() => searchTimer.cancel()); // clear timer
                    }
                    setState(() {
                      searchTimer = new Timer(searchDelay, () {
                        _search(searchString);
                      });
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search",
                  ),
                ),
              ),

              SizedBox(
                height: 15,
              ),

              Expanded(
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(0),
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 8,
                  crossAxisCount: 3,
                  children: [
                    ...Provider.of<UsersProvider>(context, listen: true).users.map((user) {
                      return GestureDetector(
                        child: UserCard(
                          user: user,
                          selected: selectedIds.contains(user.id),
                        ),
                        onTap: () {
                          if (!user.isAttended)
                            setState(() {
                              if (selectedIds.contains(user.id))
                                selectedIds.remove(user.id);
                              else
                                selectedIds.add(user.id);
                            });
                        },
                        onLongPress: (enableMenu)
                            ? () {
                                showDialog(barrierDismissible: true, context: context, builder: (BuildContext context) => UserDialog(user));
                              }
                            : null,
                      );
                    }).toList()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: selectedIds.isEmpty
          ? null
          : Container(
              decoration: BoxDecoration(color: Colors.orange[600]),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    padding: EdgeInsets.zero,
                    onPressed: null,
                    child: Text(
                      "${selectedIds.length} Selected",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Row(
                    children: [
                      /*
                          FlatButton(
                              padding: EdgeInsets.zero,
                              onPressed: null,
                              child: Text(
                                "Review",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              )),*/
                      FlatButton(
                          padding: EdgeInsets.zero,
                          child: Text(
                            "Confirm",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          onPressed: () async {
                            String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
                            await Provider.of<UsersProvider>(context, listen: false).takeAttendance(selectedIds, date);
                            setState(() {
                              selectedIds.clear();
                            });
                          }),
                    ],
                  )
                ],
              ),
            ),
    );
  }

  void _search(String searchString) {
    Provider.of<UsersProvider>(context, listen: false).search(searchString);
  }
}
