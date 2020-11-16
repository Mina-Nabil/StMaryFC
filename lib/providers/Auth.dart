import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token = "";
  String _userName = "";
  String _imageUrl = "";

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    _token=token;
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
        _token = body["message"]["token"];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", _token);
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _token = "";
    _userName = "";
  }

<<<<<<< HEAD
  Future<void> getCurrentUser() async {
    assert(await isLoggedIn());
=======
  Future<void> getCurrentUser () async {
>>>>>>> d6ab0e37bf3fd618bf0ea12dd152c9144a134c38

    final response = await http.get(
      "https://stmaryfa.msquare.app/api/current/user",
      headers: {'Authorization': "Bearer $_token", "Accept": "application/json"},
    );

    dynamic body = jsonDecode(response.body);

    if (body["status"] == null || body["status"] == false) {
      print("getCurrentUserName Failed.");
    }

    String userName = body["message"]["USER_NAME"];
    // Make first char cap
    _userName = '${userName[0].toUpperCase()}${userName.substring(1)}';
    _imageUrl = body["message"]["full_image_url"];
    notifyListeners();
  }

  String get userName {
    return _userName;
  }

  String get userImageUrl {
    return _imageUrl;
  }

  Future<String> get token async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }
}
