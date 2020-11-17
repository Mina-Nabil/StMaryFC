import 'dart:async';
import 'package:StMaryFA/providers/UsersProvider.dart';
import 'package:StMaryFA/widgets/SideMenu.dart';
import 'package:StMaryFA/widgets/UserCard.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
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
  //Screen dimentions
  final double drawerWidthRatio = 0.8;
  Timer searchTimer;

  Set<int> selectedIds = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text("Check-in",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),

      ),
      floatingActionButton: FabCircularMenu(
          fabColor: Colors.orangeAccent,
          ringColor: Colors.orangeAccent.withOpacity(0.6),
          fabOpenIcon: Icon(Icons.add, color: Colors.white),
          fabCloseIcon: Icon(Icons.close, color: Colors.white),
          children: <Widget>[
            IconButton(
                tooltip: "Home",
                icon: Icon(Icons.person_add, color: Colors.white),
                onPressed: () {
                  print('Home');
                }),
            IconButton(
                icon: Icon(Icons.group_add, color: Colors.white),
                onPressed: () {
                  print('Favorite');
                })
          ]),
      drawer: Container(
        width: MediaQuery.of(context).size.width * drawerWidthRatio,
        child: Drawer(child: SafeArea(child: SideMenu())),
      ),
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
                    const duration = Duration(milliseconds: 1000);
                    if (searchTimer != null) {
                      setState(() => searchTimer.cancel()); // clear timer
                    }
                    setState(() {
                      searchTimer = new Timer(duration, () {
                        _search(searchString);
                      });
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 0.2, color: Color.fromRGBO(79,50,0,1), style: BorderStyle.solid), ),
                    filled: true,
                    fillColor: Color.fromRGBO(254,250,241,1),
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
                    //Add New
                    // FittedBox(
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       CircleAvatar(
                    //         radius: MediaQuery.of(context).size.width / 8,
                    //         backgroundColor: Colors.orange,
                    //         child: Icon(
                    //           Icons.person_add,
                    //           size: MediaQuery.of(context).size.width / 10,
                    //           color: Colors.black,
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.all(1.0),
                    //         child: Text(
                    //           "Add New",
                    //         ),
                    //       ),
                    //       //just to algined with other cards
                    //       Padding(
                    //         padding: const EdgeInsets.all(1.0),
                    //         child: Text(" "),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    ...Provider.of<UsersProvider>(context, listen: true).users.map((user) {
                      return GestureDetector(
                        child: UserCard(
                          user: user,
                          selected: selectedIds.contains(user.id),
                        ),
                        onTap: () {
                          if(!user.isAttended)
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
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      Row(
                        children: [
                          FlatButton(
                              padding: EdgeInsets.all(5),
                              onPressed: null,
                              child: Text(
                                "Review",
                                style: TextStyle(color: Colors.black, fontSize: 20),
                              )),
                          FlatButton(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "Confirm",
                                style: TextStyle(color: Colors.black, fontSize: 20),
                              ),
                              onPressed: () {
                                String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
                                Provider.of<UsersProvider>(context, listen: false).takeAttendance(selectedIds, date);
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
