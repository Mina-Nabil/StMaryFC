class User {
  User(this.id, this.userName, this.groupName, this.imageLink);
  int id;
  String userName;
  String groupName;
  String imageLink;
  bool isDue=false;
  bool isAttended=false;

  User.fromJson(user) {
    this.id = user["id"];
    this.userName = user["USER_NAME"];
    this.groupName = user["GRUP_NAME"];
    this.imageLink = user["USIM_URL"] ?? '';
    this.isDue = user['paymentsDue'] > 0;
    this.isAttended = user['isAttended'] == 1;
  }
}
