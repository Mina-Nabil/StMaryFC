class Group {
  String name;
  int id;
  int count;
  bool isActive=true;
  Group(this.id, this.name, {this.isActive= true, this.count=0});

  Group.fromJson(group){
    this.id = group["id"];
    this.name = group["GRUP_NAME"];
    // this.isActive = group["GRUP_ACTV"];
    // this.count = group["usersCount"];
  }
}