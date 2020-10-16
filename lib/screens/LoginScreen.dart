import 'package:StMaryFA/widgets/AcademyHeader.dart';
import 'package:StMaryFA/widgets/LoginForm.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:Theme.of(context).accentColor,

      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              AcademyHeader(),
              LoginForm()
            ],
          ),
        ),
      ),
    );
  }
}