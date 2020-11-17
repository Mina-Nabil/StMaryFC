import 'package:StMaryFA/models/User.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserCard extends StatelessWidget {
  UserCard({
    @required this.user,
    @required this.selected
  });

  final User user;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: selected ? Color.fromRGBO(236,151,0,1) : Color.fromRGBO(79,50,0,0.2),),
        color: user.isAttended ? Color.fromRGBO(253,241,217,1) : Colors.white,
        
      ),
      child: FittedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              foregroundDecoration: BoxDecoration(color: selected ? Colors.grey.withOpacity(0.3) : null, shape: BoxShape.circle),
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width / 8,
                backgroundImage: user.imageLink.isNotEmpty ? Image.network(user.imageLink).image : null,
                child: user.imageLink.isEmpty
                    ? FittedBox(
                        child: Text(
                        _getInitials(),
                        style: TextStyle(fontSize: 36, fontFamily: "Anton", color: Colors.white)
                      ))
                    : null,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                user.userName,
                style: TextStyle(color: selected ? Theme.of(context).primaryColor : Colors.black, fontSize: 18),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(1.0),
                  child: Text("${user.groupName}", style: TextStyle(color: selected ? Theme.of(context).primaryColor : Colors.black, fontSize: 14, fontWeight: FontWeight.w300)),
                ),
                Container(
                  margin: EdgeInsets.only(right: 1),
                  child: FaIcon(FontAwesomeIcons.dollarSign, size: 12, color: user.isDue ? Colors.red : Colors.transparent,)
                ),
                Container(
                  margin: EdgeInsets.only(right: 1),
                  child: FaIcon(FontAwesomeIcons.checkCircle, size: 12, color: user.isAttended ? Colors.green : Colors.transparent,)
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials() {
    var buffer = StringBuffer();
    var split = user.userName.split(' ');
    //limit to 2 char only
    for (var i = 0; i < (2 ?? split.length); i++) {
      buffer.write(split[i][0]);
    }
    return buffer.toString().toUpperCase();
  }
}
