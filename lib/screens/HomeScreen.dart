import 'dart:io';
import 'package:StMaryFA/screens/DashBoard.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  File image;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Check-in"),
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: CircleAvatar(child: Icon(Icons.person),),
              title: Text("Profile", style: TextStyle(fontSize: 22),),
              subtitle: Text("View your profile ", style: TextStyle(fontSize: 20),),
            ),
            ListTile(
              title: Text("Settings", style: TextStyle(fontSize: 24),),
            ),
            ListTile(
              title: Text("DashBoards", style: TextStyle(fontSize: 24),),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashBoard()),
                );
              },
            ),
            ListTile(
              title: Text("Logout", style: TextStyle(fontSize: 24),),
            )
          ],
        ),
      ),

      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[

              // Later will view the sugesstions returned from faceX
              if(image != null)
                  Image.file(image,height: 500,),
              
              FlatButton.icon(
                icon: Icon(
                  Icons.camera_alt,
                  size: 50,
                  color: Theme.of(context).primaryColor,
                ),
                label: Text("Check-in", 
                style: TextStyle(color: Theme.of(context).primaryColor,),), 
                onPressed: _openCamera,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _openCamera () async
  {
    var imageCaptured = await ImagePicker().getImage(source: ImageSource.camera);

    //should send request to faceX to search by image

    setState(() {
      image = File(imageCaptured.path);
    });
  }
}