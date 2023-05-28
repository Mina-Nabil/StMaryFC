import 'dart:convert';
import 'dart:io';

import 'package:StMaryFA/models/HistoryRow.dart';
import 'package:StMaryFA/models/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "package:http/http.dart" as http;

import '../global.dart';

class UsersProvider with ChangeNotifier {
  String _searchApiUrl = Server.address + "api/search/name";
  String _getAllApiUrl = Server.address + "api/get/users";
  String _getUserByIdApiUrl = Server.address + "api/user/by/id";
  String _attendanceApiUrl = Server.address + "api/take/bulk/attendance";
  String _overviewApiUrl = Server.address + "api/get/overview";
  String _addUserUrl = Server.address + "api/add/user";
  String _editUserUrl = Server.address + "api/edit/user";
  String _getNewIDUrl = Server.address + "api/get/next/code";
  String _getAttendanceDetailsUrl = Server.address + "api/attendance/details/";

  //Requests Vars
  FlutterSecureStorage storage = new FlutterSecureStorage();

  // search results
  List<AttendanceUser> _users = [];
  double _historyTotal;
  List<String> _attendanceDetails = [];

  Future<void> search(String searchString) async {
    _users.clear();
    print(await Server.token);

    var response;
    if (searchString.isNotEmpty) {
      response = await http.post(
        _searchApiUrl,
        headers: {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"},
        body: {
          'name': searchString,
        },
      );
    } else {
      response =
          await http.get(_getAllApiUrl, headers: {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"});
    }

    dynamic body = jsonDecode(response.body);
    print(body);
    if (body["message"] != null && body["message"] is Iterable) {
      for (var user in body["message"]) {
        _users.add(AttendanceUser.fromJson(user));
      }
    } else {}

    notifyListeners();
  }

  Future<User> getUserById(int id) async {
    var response = await http.get(_getUserByIdApiUrl + "/$id",
        headers: {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"});
    dynamic body = jsonDecode(response.body);
    User user = User.fromJson(body["message"]);
    return user;
  }

  Future<String> addUser(File image, User user) async {
    var request = http.MultipartRequest("POST", Uri.parse(_addUserUrl));
    request.fields['name'] = user.userName;
    request.fields['type'] = "2";
    request.fields['group'] = user.groupId.toString();
    request.fields['birthDate'] = user.birthDate;
    request.fields['mobn'] = user.mobileNum;
    request.fields['code'] = user.code;
    request.fields['note'] = user.notes;

    if (image != null) {
      var pic = await http.MultipartFile.fromPath(
        'photo',
        image.path,
      );
      request.files.add(pic);
    }

    request.headers.addAll({'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"});

    var response = await request.send();

    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    dynamic body = jsonDecode(responseString);

    print(body);

    // Now name error message in only supported.
    if (body['status'] != null && body['status'] == true)
      return "";
    else
      return "The name has already been taken.";
  }

  Future<String> editUser(File image, User user) async {
    var request = http.MultipartRequest("POST", Uri.parse(_editUserUrl));
    request.fields['id'] = user.id.toString();
    request.fields['name'] = user.userName;
    request.fields['group'] = user.groupId.toString();
    request.fields['player_category'] = user.categoryId.toString();
    request.fields['birthDate'] = user.birthDate;
    request.fields['mobn'] = user.mobileNum;
    request.fields['code'] = user.code;
    request.fields['note'] = user.notes;

    if (image != null) {
      var pic = await http.MultipartFile.fromPath(
        'photo',
        image.path,
      );
      request.files.add(pic);
    }

    request.headers.addAll({'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"});

    var response = await request.send();

    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    dynamic body = jsonDecode(responseString);

    print(body);

    String errorMsg = "";

    if (body['status'] != null && body['status'] == true) {
      return errorMsg;
    } else if (body['status'] != null && body['status'] == false) {
      if (body['message'] != null && body['message']['errors'] != null) {
        for (var error in body['message']['errors'].values) {
          errorMsg += error.toString();
        }
      }
    } else {
      errorMsg += "Please try again";
    }
    return errorMsg;
  }

  Future<bool> takeAttendance(List<int> ids, String date) async {
    final response = await http.post(
      _attendanceApiUrl,
      headers: {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"},
      body: {
        'userIDs': ids.toList().toString(),
        'date': date,
      },
    );

    dynamic body = jsonDecode(response.body);

    if (body["status"] != null && body["status"] == true) {
      _users.where((element) => ids.contains(element.id)).forEach((element) {
        element.isAttended = true;
      });
      notifyListeners();
      return true;
    } else
      return false;
  }

  Future<List<HistoryRow>> getPlayerHistory(int id) async {
    _historyTotal = 0;
    final response = await http.post(
      _overviewApiUrl,
      headers: {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"},
      body: {'userID': id.toString(), 'months': "24"},
    );
    dynamic body = jsonDecode(response.body);

    List<HistoryRow> ret = [];

    if (body["status"] != null && body["status"] == true && body["message"] is Map<dynamic, dynamic>) {
      body["message"].forEach((key, row) {
        HistoryRow tmpHistory = HistoryRow.fromJson(row);
        ret.add(tmpHistory);
        _historyTotal +=
            tmpHistory.due == 'N/A' ? 0 : (double.tryParse(tmpHistory.due) ?? 0 - double.parse(tmpHistory.paid ?? 0));
      });
      return ret;
    } else
      return [];
  }

  Future<int> getNewCode() async {
    var response =
        await http.get(_getNewIDUrl, headers: {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"});
    dynamic body = jsonDecode(response.body);
    int maxCode = body["message"];
    if (maxCode != null)
      return maxCode;
    else
      return 0;
  }

  Future loadAttendanceDetails(String id, year, month) async {
    _attendanceDetails = [];
    var response = await http.get(_getAttendanceDetailsUrl + id + '/' + year + '/' + month,
        headers: {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"});
    dynamic body = jsonDecode(response.body);
    print("Attendance details response:");
    print(body);
    body["message"].forEach((e) => _attendanceDetails.add(e["ATND_DATE"]));
    notifyListeners();
  }

  List<AttendanceUser> get users {
    return _users;
  }

  double get historyTotal {
    return _historyTotal;
  }

  List<String> get attendanceDetails {
    return _attendanceDetails;
  }
}
