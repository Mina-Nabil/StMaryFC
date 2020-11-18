import 'dart:convert';

import 'package:StMaryFA/models/Group.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../global.dart';

class GroupsProvider with ChangeNotifier {
  //API URLS
  final String _getGroupsURL = Server.address + "api/groups";
  final String _addGroupURL = Server.address + "api/add/group";
  final String _toggleActivationURL = Server.address + "api/toggle/group";

  GroupsProvider() {
    Future.delayed(Duration.zero).then((value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _token = prefs.getString("token");
      _headers = {'Authorization': "Bearer $_token", "Accept": "application/json"};
    });
  }

  //Provider vars
  String _token;
  List<Group> _groups = [];
  Map<String, String> _headers;

  List<Group> get groups {
    return _groups;
  }

  Future<void> loadGroups() async {
    _groups.clear();
    final request = await http.get(_getGroupsURL, headers: _headers);

    if (request.statusCode == 200) {
      try {
        final body = jsonDecode(request.body);
        final status = body["status"];
        if (status) {
          body["message"].forEach((item) {
            _groups.add(new Group.fromJson(item));
          });
          notifyListeners();
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<bool> addGroup(String grpName) async {
    final request = await http.post(_addGroupURL, headers: _headers, body: {"name": grpName});
    if (request.statusCode == 200) {
      try {
        final body = jsonDecode(request.body);
        final status = body["status"];
        print(status);
        if (status){
          _groups.add(new Group(body["message"]["id"], grpName));
          notifyListeners();
          return true;
        }
        else
          return false;
      } catch (e) {
        print(e);
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> delGroup(int grpID) async {
    final request = await http.post(_addGroupURL, headers: _headers, body: {"id": grpID});
    if (request.statusCode == 200) {
      try {
        final body = jsonDecode(request.body);
        final status = body["status"];
        print(status);
        if (status){
          _groups.removeWhere((element) => element.id==grpID);
          notifyListeners();
          return true;
        }
        else
          return false;
      } catch (e) {
        print(e);
        return false;
      }
    } else {
      return false;
    }
  }
}
