import 'dart:convert';

import 'package:StMaryFA/models/Category.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

import '../global.dart';

class CategoriesProvider with ChangeNotifier {
  //API URLS
  final String _getCategoriesURL = Server.address + "api/categories";

  //Provider vars
  List<Category> _categories = [];

  List<Category> get categories {
    return _categories;
  }

  Future<void> loadCategories() async {
    _categories.clear();
    final request = await http.get(_getCategoriesURL, headers:  {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"});

    if (request.statusCode == 200) {
      try {
        final body = jsonDecode(request.body);
        final status = body["status"];
        if (status) {
          body["message"].forEach((item) {
            _categories.add(new Category.fromJson(item));
          });
          notifyListeners();
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
