import 'dart:convert';

import 'package:StMaryFA/models/User.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../global.dart';

class UsersProvider with ChangeNotifier {
  UsersProvider() {
    Future.delayed(Duration.zero).then((value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _token = prefs.getString("token");
    });
  }

  String _token;
  String _searchApiUrl = Server.address + "api/search/name";
  String _attendanceApiUrl = Server.address + "api/take/bulk/attendance";

  // search results
  List<User> _users = [];

  Future<void> search(String searchString) async {

    _users.clear();

    if (searchString.isNotEmpty) {
      final response = await http.post(
        _searchApiUrl,
        headers: {'Authorization': "Bearer $_token", "Accept": "application/json"},
        body: {
          'name': searchString,
        },
      );

      dynamic body = jsonDecode(response.body);

      if (body["message"] != null && body["message"] is Iterable) {
        for (var user in body["message"]) {
          _users.add(User.fromJson(user));
        }
      } else {}
    }

    //print(_users);
    notifyListeners();
  }

  Future<bool> takeAttendance(Set<int> ids, String date) async {
    final response = await http.post(
      _attendanceApiUrl,
      headers: {'Authorization': "Bearer $_token", "Accept": "application/json"},
      body: {
        'userIDs': ids.toList().toString(),
        'date': date,
      },
    );

    dynamic body = jsonDecode(response.body);

    if (body["status"] != null && body["status"] == true) {
      print("Attendance taken correct!");
      return true;
    } else
      return false;
  }

  List<User> get users {
    return _users;
  }
}
