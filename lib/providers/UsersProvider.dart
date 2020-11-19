import 'dart:convert';

import 'package:StMaryFA/models/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "package:http/http.dart" as http;

import '../global.dart';

class UsersProvider with ChangeNotifier {


  String _searchApiUrl = Server.address + "api/search/name";
  String _getAllApiUrl = Server.address + "api/get/users";
  String _attendanceApiUrl = Server.address + "api/take/bulk/attendance";

  //Requests Vars
  FlutterSecureStorage storage = new FlutterSecureStorage();
  

  // search results
  List<User> _users = [];

  Future<void> search(String searchString) async {
    _users.clear();
    var response;
    if (searchString.isNotEmpty) {
      response = await http.post(
        _searchApiUrl,
        headers:  {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"},
        body: {
          'name': searchString,
        },
      );
    } else {
      print("GEET HNA");
      response = await http.get(_getAllApiUrl, headers:  {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"});
    }

    dynamic body = jsonDecode(response.body);

    if (body["message"] != null && body["message"] is Iterable) {
      for (var user in body["message"]) {
        _users.add(User.fromJson(user));
      }
    } else {}

    //print(_users);
    notifyListeners();
  }

  Future<bool> takeAttendance(List<int> ids, String date) async {
    final response = await http.post(
      _attendanceApiUrl,
      headers:  {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"},
      body: {
        'userIDs': ids.toList().toString(),
        'date': date,
      },
    );

    dynamic body = jsonDecode(response.body);

    if (body["status"] != null && body["status"] == true) {
      print("Attendance taken correct!");
      _users.where((element) => ids.contains(element.id)).forEach((element) { 
        element.isAttended = true;
      });
      notifyListeners();
      return true;
    } else
      return false;
  }

  List<User> get users {
    return _users;
  }
}
