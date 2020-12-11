

import 'package:StMaryFA/screens/EditLoginEmailScreen.dart';
import 'package:StMaryFA/screens/EditLoginPasswordScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditLoginInfo extends StatefulWidget {
  @override
  _EditLoginInfoState createState() => _EditLoginInfoState();
}

class _EditLoginInfoState extends State<EditLoginInfo> {
  
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15)), border: Border.all(color: Color.fromRGBO(79, 50, 0, 1))),
      child: Column(children: [
        ListTile(
          leading: Icon(Icons.security, color: Theme.of(context).iconTheme.color,),
          title: Text("Login", style: Theme.of(context).textTheme.bodyText1),
          trailing: Icon(_open ? FontAwesomeIcons.chevronDown : FontAwesomeIcons.chevronRight,  color: Theme.of(context).iconTheme.color,),
          contentPadding: EdgeInsets.zero,
          onTap: () =>
            setState(() {
              _open = !_open;
            })
          ,
        ),
        
        if(_open)
          ListTile(
            leading: Icon(Icons.email, color: Theme.of(context).iconTheme.color,),
            title: Text("Email", style: TextStyle(color: Colors.black),),
            trailing: Icon( FontAwesomeIcons.chevronRight,  color: Theme.of(context).iconTheme.color,),
            contentPadding: EdgeInsets.zero,
            dense: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditLoginEmailScreen()),
              );
            }
          ),
        if(_open)  
          ListTile(
            leading: Icon(Icons.lock ,color: Theme.of(context).iconTheme.color,),
            title: Text("Password", style: TextStyle(color: Colors.black),),
            trailing: Icon( FontAwesomeIcons.chevronRight,  color: Theme.of(context).iconTheme.color,),
            contentPadding: EdgeInsets.zero,
            dense: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditLoginPasswordScreen()),
              );
            }
          ),
      ],
    ) 

    );
  }
}