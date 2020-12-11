import 'package:StMaryFA/widgets/DefAppBar.dart';
import 'package:flutter/material.dart';
import 'FAScreen.dart';

class EditLoginEmailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FAScreen(
      appBar: DefAppBar.getBar(context, "Change Email", isAdd: false),
      body: Container(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15)), border: Border.all(color: Color.fromRGBO(79, 50, 0, 1))),
          child: ListView(
            children: [
              Form(
                  //key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          decoration: InputDecoration(hintText: "New email"),
                          style: Theme.of(context).textTheme.bodyText1,
                          onChanged: null,
                          validator: (nameString) {
                            return nameString.isEmpty ? "*Required" : null;
                          },
                          onSaved: (nameString) {},
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          decoration: InputDecoration(hintText: "Re-type new email"),
                          style: Theme.of(context).textTheme.bodyText1,
                          onChanged: null,
                          validator: (nameString) {
                            return nameString.isEmpty ? "*Required" : null;
                          },
                          onSaved: (nameString) {},
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          decoration: InputDecoration(hintText: "Password"),
                          style: Theme.of(context).textTheme.bodyText1,
                          onChanged: null,
                          validator: (nameString) {
                            return nameString.isEmpty ? "*Required" : null;
                          },
                          onSaved: (nameString) {},
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        width: double.infinity,
                        decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(10)),
                        child: FlatButton(
                          onPressed: () {}, 
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
}