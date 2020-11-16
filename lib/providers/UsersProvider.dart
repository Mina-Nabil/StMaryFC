import 'dart:convert';

import 'package:StMaryFA/models/User.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

import '../global.dart';

class UsersProvider with ChangeNotifier {

  UsersProvider(this._token);
  
  String _token;
  String _searchApiUrl = Server.address + "api/search/name";
  String _attendanceApiUrl = Server.address + "api/take/bulk/attendance";

  // search results
  List<User> _users= [];

  Future<void> search (String searchString) async {

    _users.clear();

    if(searchString.isNotEmpty) {

      final response = await http.post(
        _searchApiUrl,
        headers: {
          'Authorization': "Bearer $_token",
          "Accept": "application/json"
        },
        body: {
          'name': searchString,
        },

      );

      dynamic body = jsonDecode(response.body);
      
      
      if(body["message"] != null)
      {
        for (var user in body["message"]) {
          int id           = user["id"];
          String name      = user["USER_NAME"];
          String groupName = user["GRUP_NAME"];
          String imageLink = "";
          if(user["USIM_URL"] != null)
            imageLink = user["USIM_URL"];
          _users.add(User(id, name, groupName, imageLink));
        }
      } else {

      }
    }
    
    //print(_users);
    notifyListeners();
  }

  Future<bool> takeAttendance (Set<int> ids, String date) async {

    final response = await http.post(
      _attendanceApiUrl,
      headers: {
        'Authorization': "Bearer $_token",
        "Accept": "application/json"
      },
      body: {
        'userIDs': ids.toString(),
        'date': date,
      },
    );
    dynamic body = jsonDecode(response.body);

    if(body["status"] != null && body["status"] == true){
      print("Attendance taken correct!");
      return true;
    }
    else
      return false;
  }
  

  List<User> get users {return _users;}
}
