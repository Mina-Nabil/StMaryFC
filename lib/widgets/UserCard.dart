import 'package:StMaryFA/models/User.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  UserCard({
    @required this.user,
    @required this.selected,
  });

  final User user;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.orangeAccent.withOpacity(0.9),
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
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Text(
                user.userName,
                style: TextStyle(color: selected ? Theme.of(context).primaryColor : Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Text("G: ${user.groupName}", style: TextStyle(color: selected ? Theme.of(context).primaryColor : Colors.black)),
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
