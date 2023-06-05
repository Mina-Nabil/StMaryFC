import 'dart:convert';

import 'package:StMaryFA/global.dart';
import 'package:StMaryFA/models/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "package:http/http.dart" as http;

class Auth with ChangeNotifier {
  User currentUser = User.empty();
  FlutterSecureStorage storage;

  Future<bool> isLoggedIn() async {
    storage = FlutterSecureStorage();
    String token = await Server.token;
    return token != null;
  }

  Future<String> logIn(String email, String password, String deviceName) async {
    const String url = Server.address + "api/login";
    String errorMsg = "";

    var bodyEncoded = {
      "email": email,
      "password": password,
      "deviceName": deviceName,
    };
    print(bodyEncoded);
    print(url);

    try {
      final response = await http.post(
        url,
        body: bodyEncoded,
        headers: {"Accept": "application/json"},
      );

      dynamic body = jsonDecode(response.body);
      print(body);
      if (body["status"] != null && body["status"] == true) {
        await Server.setToken(body["message"]["token"]);

        print("Sign in Done");
      } else {
        if (body["message"]["errors"] != null) {
          errorMsg = "Invalid Email/Password";
        }
        print("Sign in Failed");
      }
    } catch (error) {
      errorMsg = "Check internet connection";
      print("HTTP request failed $error");
    }

    return errorMsg;
  }

  void logout() async {
    Server.logOut();
    currentUser.clear();
  }

  Future<String> changeEmail(String newEmail, String password) async {
    String errorMsg = "";

    try {
      final response = await http.post(
        Server.address + "api/edit/user/email",
        headers: {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"},
        body: {"id": currentUser.id.toString(), "email": newEmail, "password": password},
      );

      dynamic responseDecoded = jsonDecode(response.body);

      if (responseDecoded["status"] == null || responseDecoded["status"] == false) {
        if (responseDecoded["message"]["error"] != null) {
          errorMsg = responseDecoded["message"]["error"];
        }
      }
    } catch (error) {
      errorMsg = "Check internet connection";
      print("HTTP request failed $error");
    }

    return errorMsg;
  }

  Future<String> changePassword(String oldPassword, String newPassword) async {
    String errorMsg = "";

    try {
      final response = await http.post(
        Server.address + "api/edit/user/password",
        headers: {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"},
        body: {"id": currentUser.id.toString(), "oldPassword": oldPassword, "newPassword": newPassword},
      );

      dynamic responseDecoded = jsonDecode(response.body);

      if (responseDecoded["status"] == null || responseDecoded["status"] == false) {
        if (responseDecoded["message"]["error"] != null) {
          errorMsg = responseDecoded["message"]["error"];
        }
      }
    } catch (error) {
      errorMsg = "Check internet connection";
      print("HTTP request failed $error");
    }

    return errorMsg;
  }

  Future<void> getCurrentUser() async {
    assert(await isLoggedIn());
    try {
      final response = await http.get(
        Server.address + "api/current/user",
        headers: {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"},
      );

      dynamic body = jsonDecode(response.body);

      if (body["status"] == null || body["status"] == false) {
        print("getCurrentUserName Failed.");
      }

      currentUser = User.fromJson(body["message"]);
      print("TYPE IS " + currentUser.toString());
      Server.setUsertype(currentUser.type);

      notifyListeners();
    } catch (e) {
      print("GETTING USER FAILED");
      print(e);
      this.logout();
    }
  }

  String get userName {
    return currentUser.userName;
  }

  int get userType {
    return currentUser.type;
  }

  String get userImageUrl {
    return currentUser.imageLink;
  }
}
