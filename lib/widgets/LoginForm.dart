
import 'package:StMaryFA/providers/UsersProvider.dart';
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
  bool   _isTryingToLogIn = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    
    InputDecoration textFieldDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      filled: true,
      fillColor: Colors.grey[350],
      hintStyle: TextStyle(color: Colors.grey)
    );
    

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //Email Field
                Container(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child: TextFormField(
                    decoration: textFieldDecoration.copyWith(hintText: "Email"),
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    onChanged: (email) {_signInEmail = email;},
                    validator: (email) {return email.isEmpty? "Please fill your Email" : null;},
                  ),
                ),
                //Password Field
                Container(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child: TextFormField(
                    obscureText: true, //password type
                    decoration: textFieldDecoration.copyWith(hintText: "Password"),
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    onChanged: (password) {_signInPassword = password;},
                    validator: (email) {return email.isEmpty? "Please fill your Password" : null;},
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
                    _logIn(context);
                  },
                )
              ],
            ),
          ),
        ),

        if(_isTryingToLogIn)
           Center(child: CircularProgressIndicator()),
      ]
    );
  }

  void _logIn(BuildContext context) async {

    if(!_formKey.currentState.validate())
      return;

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
          builder: (context) => MultiProvider(
               providers: [
                 ChangeNotifierProvider.value(value: UsersProvider(Provider.of<Auth>(context, listen: true).token)),
               ],
               child: HomeScreen(),
             )
        ),
      );
    } else {
      showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: Text("Login Failed"),
          content:Text("$errorMsg"),
        )
      );
      print(errorMsg);
    }
    

  }
}
