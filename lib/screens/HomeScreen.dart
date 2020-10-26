import 'dart:io';
import 'package:StMaryFA/providers/Auth.dart';
import 'package:StMaryFA/screens/DashBoard.dart';
import 'package:StMaryFA/screens/SplashScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //Screen dimentions
  final double drawerWidthRatio = 0.7;
  final double drawerHorizontalMargin = 15;
  final double tileTextFontSize = 17;
  final double tilesPadding = 25;
  final double tilesRightMarginRation = 0.1;
  File image;

@override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) async {
      Provider.of<Auth>(context, listen: false).getCurrentUserName();
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
                ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: FittedBox(child: Text(Provider.of<Auth>(context).userName)),
                  subtitle: FittedBox(child: Text("View your profile ")),
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              // Later will view the sugesstions returned from faceX
              if (image != null)
                Image.file(
                  image,
                  height: 500,
                ),

              FlatButton.icon(
                icon: Icon(
                  Icons.camera_alt,
                  size: 50,
                  color: Theme.of(context).primaryColor,
                ),
                label: Text(
                  "Check-in",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: _openCamera,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _openCamera() async {
    var imageCaptured = await ImagePicker().getImage(source: ImageSource.camera);

    //should send request to faceX to search by image

    setState(() {
      image = File(imageCaptured.path);
    });
  }

  void _logout() {
    Provider.of<Auth>(context, listen: false).logout();
    Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SplashScreen()),
        );
  }
}
