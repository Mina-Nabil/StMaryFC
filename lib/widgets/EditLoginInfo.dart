

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
    return Container(padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Color.fromRGBO(254,250,241,1), 
        borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.all(color: Color.fromRGBO(79,50,0,1), width: 0.6, style: BorderStyle.solid)
      ),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque, // To sense tap on space area
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.security, color: Theme.of(context).iconTheme.color,),
                      SizedBox(width: 10,),
                      Text("Email/Password", style: Theme.of(context).textTheme.bodyMedium.copyWith(color: _open ? Colors.black: Colors.black54)),
                    ],
                  ),
                  Icon(_open ? FontAwesomeIcons.chevronDown : Icons.edit,  color: Theme.of(context).iconTheme.color,),
                ],
              ),
            ),
            onTap: () =>
            setState(() {
              _open = !_open;
            }),
          ),
        
        if(_open)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.email, color: Theme.of(context).iconTheme.color,),
                      SizedBox(width: 10,),
                      Text("Email", style: Theme.of(context).textTheme.bodyMedium.copyWith(color: _open ? Colors.black: Colors.black54)),
                    ],
                  ),
                  Icon( FontAwesomeIcons.chevronRight,  color: Theme.of(context).iconTheme.color,),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditLoginEmailScreen()),
              );
            }
          ),

        if(_open)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lock, color: Theme.of(context).iconTheme.color,),
                      SizedBox(width: 10,),
                      Text("Password", style: Theme.of(context).textTheme.bodyMedium.copyWith(color: _open ? Colors.black: Colors.black54)),
                    ],
                  ),
                  Icon( FontAwesomeIcons.chevronRight,  color: Theme.of(context).iconTheme.color,),
                ],
              ),
            ),
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