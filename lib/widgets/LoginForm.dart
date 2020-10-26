
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:StMaryFA/providers/Auth.dart';
import 'package:StMaryFA/screens/HomeScreen.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String signInEmail = "";
  String signInPassword = "";
  bool isTryingToSignIn = false;
  @override
  Widget build(BuildContext context) {
    
    InputDecoration textFieldDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      filled: true,
      fillColor: Colors.grey[350],
      hintStyle: TextStyle(color: Colors.grey)
    );
    

    return Form(
      child: Column(
        children: [
          //Email Field
          Container(
            padding: EdgeInsets.symmetric(vertical: 3),
            child: TextFormField(
              decoration: textFieldDecoration.copyWith(hintText: "Email"),
              style: TextStyle(color: Colors.black, fontSize: 20),
              onChanged: (email) {signInEmail = email;},
            ),
          ),
          //Password Field
          Container(
            padding: EdgeInsets.symmetric(vertical: 3),
            child: TextFormField(
              obscureText: true, //password type
              decoration: textFieldDecoration.copyWith(hintText: "Password"),
              style: TextStyle(color: Colors.black, fontSize: 20),
              onChanged: (password) {signInPassword = password;},
            ),
          ),
          //Login Button
          FlatButton(
            padding: EdgeInsets.zero,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height/15,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text( "Login",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            onPressed: () {
              _signIn();
            },
          )
        ],
      ),
    );
  }

  void _signIn() async {
    
    setState(() {
      isTryingToSignIn = true;
    });

    bool status = await Provider.of<Auth>(context, listen: false).logIn(signInEmail, signInPassword, "iphone11");

    if (status) {
      //go to user's Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
    
    setState(() {
      isTryingToSignIn = false;
    });
  }
}