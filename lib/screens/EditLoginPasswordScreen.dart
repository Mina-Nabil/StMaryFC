import 'package:StMaryFA/providers/Auth.dart';
import 'package:StMaryFA/screens/SplashScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'FAScreen.dart';

class EditLoginPasswordScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final _passowrdController = TextEditingController();

  String _oldPassword = "";
  String _newPassword = "";

  @override
  Widget build(BuildContext context) {
    return FAScreen(
      appBar: AppBar(title: Text("Change Password")),
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
                      //Name Text Field
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(hintText: "Current password"),
                          style: Theme.of(context).textTheme.bodyMedium,
                          onChanged: null,
                          validator: (value) {
                            return value.isEmpty ? "*Required" : null;
                          },
                          onSaved: (value) {_oldPassword = value;},
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(hintText: "New password"),
                          style: Theme.of(context).textTheme.bodyMedium,
                          onChanged: null,
                          controller: _passowrdController,
                          validator: (value) {
                            return value.isEmpty ? "*Required" : null;
                          },
                          onSaved: (value) {_newPassword = value;},
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(hintText: "Re-type new password"),
                          style: Theme.of(context).textTheme.bodyMedium,
                          onChanged: null,
                          validator: (value) {
                            if(value.isEmpty)
                              return "*Required";
                            if(value != _passowrdController.value.text)
                              return "*You mush enter same password";
                            return null;
                          },
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        width: double.infinity,
                        decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(10)),
                        child: TextButton(
                          onPressed: () => _updatePassword(context), 
                          child: Text(
                            "Update Password",
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

    Future<void> _updatePassword(BuildContext context) async {
    FormState form = _formKey.currentState;

    if (!form.validate())
      return;

    form.save();

    String errorMsg = await Provider.of<Auth>(context, listen: false).changePassword(_oldPassword, _newPassword);

    if (errorMsg.isEmpty) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => new CupertinoAlertDialog(
            title: Text("Password is updated successfully"),
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
                title: Text("Update Password Failed"),
                content: Text("$errorMsg"),
              ));
    }

  }
}
