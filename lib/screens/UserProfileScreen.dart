import 'package:StMaryFA/models/User.dart';
import 'package:StMaryFA/providers/UsersProvider.dart';
import 'package:StMaryFA/screens/AddUsersScreen.dart';
import 'package:StMaryFA/screens/FAScreen.dart';
import 'package:StMaryFA/widgets/DefAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../global.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen(this.id);
  final int id;

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<UsersProvider>(context).getUserById(widget.id),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          if(snapshot.hasError) {
            return FAScreen.error();
          } else {
            User user = snapshot.data as User;
            return FAScreen(
              appBar: DefAppBar.getBar(context, Utils.capitalize(user.userName), isAdd: false),
              body: UserScreen.view(user) ,
            );
          }
        } else {
          return FAScreen.loading();
        }
      }
    );
  }
}