
import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class Auth with ChangeNotifier {
  String _token = "";
  String _userName = "";
  String _imageUrl = "";

  bool isLoggedIn() {
    return _token.isNotEmpty;
  }

  Future<String> logIn (String email, String password, String deviceName) async {

    const String url = "https://stmaryfa.msquare.app/api/login";
    String errorMsg = "";

    var bodyEncoded = {
                        "email": email,
                        "password":password,
                        "deviceName": deviceName,
                      };
print(bodyEncoded);

try {
    final response = await http.post(url,
      body: bodyEncoded,
      headers: {"Accept": "application/json"},
    );

    dynamic body = jsonDecode(response.body);

    if(body["status"] != null && body["status"] == true) {
      _token  = body["message"]["token"];
      print("Sign in Done");
    } else {
      if(body["message"]["errors"] != null)
      {
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

  void logout () {
    _token = "";
    _userName = "";
  }

  Future<void> getCurrentUser () async {

    final response = await http.get(
      "https://stmaryfa.msquare.app/api/current/user",
      headers: {
        'Authorization': "Bearer $_token",
        "Accept": "application/json"},
    );

    dynamic body = jsonDecode(response.body);

    if(body["status"] == null || body["status"] == false)
    {print("getCurrentUserName Failed.");}

    String userName = body["message"]["USER_NAME"];
    // Make first char cap
    _userName = '${userName[0].toUpperCase()}${userName.substring(1)}';
    _imageUrl = body["message"]["full_image_url"];
    notifyListeners();
  }

  String get userName { return _userName;}
  String get userImageUrl {return _imageUrl;}
  String get token {return _token;}
}
