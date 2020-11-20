import 'dart:async';
import 'package:StMaryFA/providers/UsersProvider.dart';
import 'package:StMaryFA/widgets/DefAppBar.dart';
import 'package:StMaryFA/widgets/DefDrawer.dart';
import 'package:StMaryFA/widgets/UserCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((_) => Provider.of<UsersProvider>(context, listen: false).search(""));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: DefAppBar.getBar(context, "Check-in"),
      drawer: DefDrawer(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Search Bar
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 15,
                child: TextField(
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black, fontSize: 24),
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
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
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
                      );
                    }).toList()
                  ],
                ),
              ),

              // Selection info Bar
              if (selectedIds.isNotEmpty)
                Container(
                  height: MediaQuery.of(context).size.height / 15,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlatButton(
                        padding: EdgeInsets.all(5),
                        onPressed: null,
                        child: Text(
                          "${selectedIds.length} Selected",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      Row(
                        children: [
                          FlatButton(
                              padding: EdgeInsets.all(5),
                              onPressed: null,
                              child: Text(
                                "Review",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              )),
                          FlatButton(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "Confirm",
                                style: TextStyle(color: Colors.white, fontSize: 20),
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
            ],
          ),
        ),
      ),
    );
  }

  void _search(String searchString) {
    print(searchString);
    Provider.of<UsersProvider>(context, listen: false).search(searchString);
  }
}
