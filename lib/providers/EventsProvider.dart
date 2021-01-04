

import 'dart:convert';

import 'package:StMaryFA/global.dart';
import 'package:StMaryFA/models/Event.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class EventsProvider with ChangeNotifier {
  final String _getEventsApiUrl = Server.address + "api/events";

    List<Event> _events;

  List<Event> get events {
    return _events;
  }

  Future<void> loadEvents() async {
    _events = [];
    try {
      final request = await http.get(_getEventsApiUrl, headers:  {'Authorization': "Bearer ${await Server.token}", "Accept": "application/json"});

      if (request.statusCode == 200) {
          final body = jsonDecode(request.body);
          final status = body["status"];
          if (status) {
            body["message"].forEach((item) {
              _events.add(Event.fromJson(item));
            });
            notifyListeners();
          }
      }
    } catch (e) {
      print(e);
    }
  }
}
