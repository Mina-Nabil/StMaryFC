import 'package:flutter/material.dart';
import 'package:StMaryFA/screens/HomeScreen.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    InputDecoration textFieldDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      filled: true,
      fillColor: Color.fromRGBO(255, 255, 255, .15),
      hintStyle: TextStyle(color: Colors.white54)
    );
    

    return Form(
                child: Column(
                  children: [
                    //Email Field
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 3),
                      child: TextFormField(
                        decoration: textFieldDecoration.copyWith(hintText: "Email"),
                        style: TextStyle(color: Colors.orange, fontSize: 20),
                      ),
                    ),
                    //Password Field
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 3),
                      child: TextFormField(
                        obscureText: true, //password type
                        decoration: textFieldDecoration.copyWith(hintText: "Password"),
                        style: TextStyle(color: Colors.orange, fontSize: 20),
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
                              color: Theme.of(context).accentColor,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                    )
                  ],
                ),
              );
  }

}