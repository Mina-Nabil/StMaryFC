class User {
  User(this.id, this.userName, this.groupName, this.imageLink);
  int id;
  String userName;
  String groupName;
  String imageLink;

  User.fromJson(user) {
    this.id = user["id"];
    this.userName = user["USER_NAME"];
    this.groupName = user["GRUP_NAME"];
    this.imageLink = user["USIM_URL"] ?? '';
  }
}
