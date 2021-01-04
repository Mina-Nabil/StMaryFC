import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Payment {
  Payment({
    @required this.amount,
    @required this.date,
    this.note,
  });

  Payment.fromJson(jsonPayment) {
    // jsonPayment["id"];
    // jsonPayment["PYMT_USER_ID"];
    this.amount = jsonPayment["PYMT_AMNT"];
    this.date = DateFormat('MMMM yyyy','en_US').format(DateTime.parse(jsonPayment["PYMT_DATE"]));
    this.note = jsonPayment["PYMT_NOTE"]?? "";
  }

  int amount;
  String date;
  String note;
}

class EventPayment extends Payment {

  EventPayment.fromJson(json) {
    // jsonPayment["id"];
    // jsonPayment["PYMT_USER_ID"];
    this.amount = json["PYMT_AMNT"];
    this.date = DateFormat('MMMM yyyy','en_US').format(DateTime.parse(json["PYMT_DATE"]));
    this.note = json["PYMT_NOTE"]?? "";
    this.eventName = json["EVNT_NAME"];
  }
  String eventName;
}
