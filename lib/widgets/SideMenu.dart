import 'package:StMaryFA/providers/Auth.dart';
import 'package:StMaryFA/screens/DashBoard.dart';
import 'package:StMaryFA/screens/SplashScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatefulWidget {
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  final double drawerMargin = 15;
  final double tileTextFontSize = 17;
  final double tilesRightMarginRation = 0.1;

@override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) async {
      Provider.of<Auth>(context, listen: false).getCurrentUser();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
            margin: EdgeInsets.all(drawerMargin),
            child: ListView(

              children: [
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: CircleAvatar(
                    radius:  MediaQuery.of(context).size.width/12,
                    backgroundImage: Provider.of<Auth>(context).userImageUrl.isNotEmpty? Image.network(Provider.of<Auth>(context).userImageUrl).image : null,
                  ),
                  title: Text(Provider.of<Auth>(context).userName, style: TextStyle(fontSize: 24)),
                  subtitle: Text("View your profile",style: TextStyle(fontSize: 16)),
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
          );
  }
    void _logout() {
    Provider.of<Auth>(context, listen: false).logout();
    Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SplashScreen()),
    );
  }
}
