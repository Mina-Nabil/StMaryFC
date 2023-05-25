import 'dart:io';
import 'package:StMaryFA/providers/Auth.dart';
import 'package:StMaryFA/screens/DashBoard.dart';
import 'package:StMaryFA/screens/HomeScreen.dart';
import 'package:StMaryFA/screens/ProfileScreen.dart';
import 'package:StMaryFA/screens/SettingsScreen.dart';
import 'package:StMaryFA/screens/SplashScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../global.dart';

class SideMenu extends StatefulWidget {
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  final double drawerMargin = 15;
  final double tileTextFontSize = 17;
  final double tilesRightMarginRation = 0.1;

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
                  title: Text(Utils.capitalize(Provider.of<Auth>(context).userName), style: TextStyle(fontSize: 24)),
                  subtitle: Text("View your profile",style: TextStyle(fontSize: 16)),
                  onTap: () {
                    //better to use popUtil
                    Navigator.pop(context); //pop side menu first
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                ),

                ListTile(
                  contentPadding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * tilesRightMarginRation,
                  ),
                  leading: Container(child: Icon(CupertinoIcons.home, color: Theme.of(context).primaryColor)),
                  title: Text("Check-in", overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: tileTextFontSize),),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * tilesRightMarginRation,
                  ),
                  leading: Container(child: Icon(CupertinoIcons.settings, color: Theme.of(context).primaryColor)),
                  title: Text("Settings", overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: tileTextFontSize),),
                   onTap: () {
                     Navigator.pop(context); //pop side menu first
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                  },
                ),

                ListTile(
                  contentPadding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * tilesRightMarginRation,
                  ),
                  leading: Container(child: Icon(CupertinoIcons.info, color: Theme.of(context).primaryColor)),
                  title: Text("Dashboard", overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: tileTextFontSize),),
                  onTap: () {
                    _openDashBoard();
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

    void _openDashBoard() {
      if (Platform.isAndroid) {
        launch(
          Server.address + 'home',
          enableJavaScript: true,
        );
      } else {
        Navigator.pop(context); //pop side menu first
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashBoard()),
        );
      }
    }

    void _logout() {
    Provider.of<Auth>(context, listen: false).logout();
    Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SplashScreen()),
    );
  }
}
