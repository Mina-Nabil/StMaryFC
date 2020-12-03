import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:StMaryFA/providers/Auth.dart';
import 'package:StMaryFA/screens/HomeScreen.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _signInEmail = "";
  String _signInPassword = "";
  bool _isTryingToLogIn = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //Email Field
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  decoration: InputDecoration(hintText: "Email"),
                  style: Theme.of(context).textTheme.bodyText1,
                  onChanged: (email) {
                    _signInEmail = email;
                  },
                  validator: (email) {
                    return email.isEmpty ? "Please fill your Email" : null;
                  },
                ),
              ),
              //Password Field
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  obscureText: true, //password type
                  decoration: InputDecoration(hintText: "Password"),
                  style: Theme.of(context).textTheme.bodyText1,
                  onChanged: (password) {
                    _signInPassword = password;
                  },
                  validator: (email) {
                    return email.isEmpty ? "Please fill your Password" : null;
                  },
                ),
              ),
              //Login Button
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                width: double.infinity,
                decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(10)),
                child: FlatButton(
                  onPressed: () => _logIn(context), 
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 24,),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      if (_isTryingToLogIn) Center(child: CircularProgressIndicator()),
    ]);
  }

  void _logIn(BuildContext context) async {
    if (!_formKey.currentState.validate()) return;

    setState(() {
      _isTryingToLogIn = true;
    });

    String errorMsg = await Provider.of<Auth>(context, listen: false).logIn(_signInEmail, _signInPassword, "iphone11");

    setState(() {
      _isTryingToLogIn = false;
    });

    if (errorMsg.isEmpty) {
      //go to user's Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } else {
      showCupertinoDialog(
          barrierDismissible: true,
          context: context,
          builder: (BuildContext context) => new CupertinoAlertDialog(
                title: Text("Login Failed"),
                content: Text("$errorMsg"),
              ));
      print(errorMsg);
    }
  }
}
