import 'package:flutter/material.dart';
import 'package:StMaryFA/widgets/AcademyHeader.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:Theme.of(context).accentColor,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AcademyHeader(),
              FlatButton.icon(
                icon: Icon(
                  Icons.camera_alt,
                  size: 50,
                  color: Theme.of(context).primaryColor,
                ),
                label: Text("Check-in", 
                style: TextStyle(color: Theme.of(context).primaryColor,),), 
                onPressed: null)
            ],
          ),
        ),
      ),
    );
  }
}