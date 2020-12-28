import 'package:StMaryFA/providers/Auth.dart';
import 'package:StMaryFA/screens/SplashScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'FAScreen.dart';

class EditLoginEmailScreen extends StatelessWidget {
  
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  String _newEmail = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return FAScreen(
      appBar: AppBar(title: Text("Change Email")),
      body: Container(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15)), border: Border.all(color: Color.fromRGBO(79, 50, 0, 1))),
          child: ListView(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          decoration: InputDecoration(hintText: "New email"),
                          style: Theme.of(context).textTheme.bodyText1,
                          onChanged: null,
                          controller: _emailController,
                          validator: (value) {
                            return value.isEmpty ? "*Required" : null;
                          },
                          onSaved: (value) {_newEmail = value;},
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          decoration: InputDecoration(hintText: "Re-type new email"),
                          style: Theme.of(context).textTheme.bodyText1,
                          onChanged: null,
                          validator: (value) {
                            if(value.isEmpty)
                              return "*Required";
                            if(value != _emailController.value.text)
                              return "*You mush enter same email";
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(hintText: "Password"),
                          style: Theme.of(context).textTheme.bodyText1,
                          onChanged: null,
                          validator: (value) {
                            return value.isEmpty ? "*Required" : null;
                          },
                          onSaved: (value) {_password = value;},
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        width: double.infinity,
                        decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(10)),
                        child: FlatButton(
                          onPressed: () =>_updateEmail(context), 
                          child: Text(
                            "Update Email",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 24,),
                          ),
                        ),
                      ),
                    ]
                  ),
              ),
          ],),
      ),
    );
  }

  Future<void> _updateEmail(BuildContext context) async {
    FormState form = _formKey.currentState;

    if (!form.validate())
      return;

    form.save();

    String errorMsg = await Provider.of<Auth>(context, listen: false).changeEmail(_newEmail, _password);

    if (errorMsg.isEmpty) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => new CupertinoAlertDialog(
            title: Text("Email is updated successfully"),
            content: Text("Your new email is $_newEmail"),
            actions: [
              CupertinoDialogAction(child: Text("OK"), onPressed: () {
                Provider.of<Auth>(context, listen: false).logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SplashScreen()),
                    );
              },),
            ],
          ),
      );
    } else {
      showCupertinoDialog(
          barrierDismissible: true,
          context: context,
          builder: (BuildContext context) => new CupertinoAlertDialog(
                title: Text("Update Email Failed"),
                content: Text("$errorMsg"),
              ));
    }

  }
}