import 'dart:convert';

import 'package:StMaryFA/models/Group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "package:http/http.dart" as http;

import '../global.dart';

class GroupsProvider with ChangeNotifier {
  //API URLS
  final String _getGroupsURL = Server.address + "api/groups";
  final String _addGroupURL = Server.address + "api/add/group";
  final String _toggleActivationURL = Server.address + "api/toggle/group";
  final String _delGroupURL = Server.address + "api/del/group";
  final FlutterSecureStorage storage = new FlutterSecureStorage();

  //Provider vars
  List<Group> _groups = [];

  List<Group> get groups {
    return _groups;
  }

  Future<void> loadGroups() async {
    _groups.clear();
    final request = await http.get(_getGroupsURL, headers:  {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"});

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
    final request = await http.post(_addGroupURL, headers:  {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"}, body: {"name": grpName});
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
    final request = await http.post(_delGroupURL, headers:  {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"}, body: {"id": grpID.toString()});
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

  Future<bool> toggleGroup(int grpID) async {
    final request = await http.post(_toggleActivationURL, headers:  {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"}, body: {"id": grpID.toString()});
    if (request.statusCode == 200) {
      try {
        final body = jsonDecode(request.body);
        final status = body["status"];
        print(status);
        if (status){
          Group group = _groups.singleWhere((element) => element.id==grpID);
          group.isActive = (group.isActive) ? false : true;
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
