import 'dart:async';
import 'package:StMaryFA/providers/Auth.dart';
import 'package:StMaryFA/providers/UsersProvider.dart';
import 'package:StMaryFA/screens/DashBoard.dart';
import 'package:StMaryFA/screens/SplashScreen.dart';
import 'package:StMaryFA/widgets/UserCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //Screen dimentions
  final double drawerWidthRatio = 0.8;
  final double drawerHorizontalMargin = 15;
  final double tileTextFontSize = 17;
  final double tilesPadding = 25;
  final double tilesRightMarginRation = 0.1;
  Timer searchTimer;

  Set<int> selectedIds = {};

@override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) async {
      Provider.of<Auth>(context, listen: false).getCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Check-in"),
      ),
      drawer: Container(
        width: MediaQuery.of(context).size.width * drawerWidthRatio,
        child: Drawer(
          
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: drawerHorizontalMargin),
            child: ListView(
              
              padding: EdgeInsets.symmetric(vertical: tilesPadding),
              children: [
                Container(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: CircleAvatar(
                      radius:  MediaQuery.of(context).size.width/12,
                      backgroundImage: Image.network(Provider.of<Auth>(context).userImageUrl).image,
                    ),
                    title: Text(Provider.of<Auth>(context).userName, style: TextStyle(fontSize: 24)),
                    subtitle: Text("View your profile",style: TextStyle(fontSize: 16)),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * tilesRightMarginRation,
                  ),
                  leading: Container(child: Icon(CupertinoIcons.settings, color: Theme.of(context).primaryColor)),
                  title: Text("Settings", overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: tileTextFontSize),),
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * tilesRightMarginRation,
                  ),
                  leading: Container(child: Icon(CupertinoIcons.info, color: Theme.of(context).primaryColor)),
                  title: Text("Dashboard", overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: tileTextFontSize),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DashBoard()),
                    );
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * tilesRightMarginRation,
                  ),
                  leading: Container(child: Icon(CupertinoIcons.arrowshape_turn_up_left, color: Theme.of(context).primaryColor)),
                  title: Text("Logout", overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: tileTextFontSize),),
                  onTap: _logout,
                )
              ],
            ),
          ),
        ),
      ),

      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height/15,
                    child: TextField(
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black, fontSize: 24),

                      onChanged: (searchString) {
                        const duration = Duration(milliseconds: 1000);
                        if (searchTimer != null) {
                          setState(() => searchTimer.cancel()); // clear timer
                        }
                        setState(() {
                          searchTimer = new Timer(duration, (){
                            _search(searchString);
                          });
                        });
                      },
                      decoration:  InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.grey[350],
                        hintText: "Search",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                     ),
                  ),


              SizedBox(height: 20,),
              
              Expanded(
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(0),
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  crossAxisCount: 3,
                  children: [
                    ...Provider.of<UsersProvider>(context, listen: true).users.map((user) {
                        return GestureDetector(
                          child: UserCard(user: user ,selected: selectedIds.contains(user.id),),
                          onTap: (){
                            setState(() {
                              if(selectedIds.contains(user.id))
                                selectedIds.remove(user.id);
                              else
                                selectedIds.add(user.id);
                            });
                            },
                        );
                      }
                    ).toList()
                  ],
                ),
              ),

              if(selectedIds.isNotEmpty)
                Container(
                  height: MediaQuery.of(context).size.height/15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        FlatButton(
                          padding: EdgeInsets.all(5),
                          onPressed: null, 
                          child:  Text("${selectedIds.length} Selected",style: TextStyle(color: Colors.black, fontSize: 20),),
                        ),
                      
                      Row(
                        children: [
                        FlatButton(
                        padding: EdgeInsets.all(5),
                        onPressed: null, 
                        child:  Text("Review",style: TextStyle(color: Colors.black, fontSize: 20),)
                      ),
                        FlatButton(
                        padding: EdgeInsets.all(5),
                        onPressed: null, 
                        child:  Text("Confirm",style: TextStyle(color: Colors.black, fontSize: 20),)
                      ),
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


  void _logout() {
    Provider.of<Auth>(context, listen: false).logout();
    Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SplashScreen()),
    );
  }
}
