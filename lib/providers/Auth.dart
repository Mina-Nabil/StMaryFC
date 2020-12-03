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
    const String url = "https://stmaryfa.msquare.app/api/login";
    String errorMsg = "";

    var bodyEncoded = {
      "email": email,
      "password": password,
      "deviceName": deviceName,
    };
    print(bodyEncoded);

    try {
      final response = await http.post(
        url,
        body: bodyEncoded,
        headers: {"Accept": "application/json"},
      );

      dynamic body = jsonDecode(response.body);

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

  Future<void> getCurrentUser() async {
    assert(await isLoggedIn());
    final response = await http.get(
      "https://stmaryfa.msquare.app/api/current/user",
      headers: {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"},
    );

    dynamic body = jsonDecode(response.body);

    if (body["status"] == null || body["status"] == false) {
      print("getCurrentUserName Failed.");
    }

    currentUser = User.fromJson(body["message"]);

    notifyListeners();
  }

  String get userName {
    return currentUser.userName;
  }

  String get userImageUrl {
    return currentUser.imageLink;
  }

}
