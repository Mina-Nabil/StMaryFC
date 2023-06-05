import 'package:flutter/material.dart';

class User {
  User(
      {this.id,
      this.userName,
      this.type,
      this.groupName,
      this.groupId,
      this.imageLink,
      this.birthDate,
      this.mobileNum,
      this.code,
      this.notes});

  User.empty() {
    clear();
  }

  User.fromJson(user) {
    this.id = user["id"];
    this.userName = user["USER_NAME"];
    this.type = user["type"]["id"];
    this.groupName = user["group"]["GRUP_NAME"];
    this.categoryId = user["players_category_id"];
    this.categoryName = (user["players_category_id"] != null) ? user["player_category"]["title"] : null;
    this.groupId = user["group"]["id"];
    this.birthDate = user["USER_BDAY"];
    this.imageLink = user["full_image_url"];
    this.mobileNum = user["USER_MOBN"];
    this.code = user["USER_CODE"];
    this.notes = user["USER_NOTE"];
  }

  void clear() {
    userName = groupName = imageLink = birthDate = mobileNum = code = notes = "";
    id = groupId = 0;
  }

  int id;
  String userName;
  int type;
  String groupName;
  String categoryName;
  int groupId;
  dynamic categoryId;
  String imageLink;
  String birthDate;
  String mobileNum;
  String code;
  String notes;
}

class AttendanceUser extends User {
  AttendanceUser({
    @required int id,
    @required String name,
    int type,
    String groupName,
    int groupId,
    String imageLink,
    String birthDate,
    String mobileNum,
    String code,
    String notes,
    int monthlyPayments,
    bool isAttended,
  }) : super(
            id: id,
            userName: name,
            type: type,
            groupName: groupName,
            groupId: groupId,
            imageLink: imageLink,
            birthDate: birthDate,
            mobileNum: mobileNum,
            code: code,
            notes: notes);

  AttendanceUser.fromJson(user) {
    this.id = user["id"];
    this.userName = user["USER_NAME"];
    this.groupName = user["GRUP_NAME"];
    this.imageLink = user["USIM_URL"] ?? '';
    this.monthlyPayments = user['monthlyPayments'];
    this.isAttended = user['isAttended'] == 1;
  }

  int monthlyPayments = 0;
  bool isAttended = false;
}
