class Category {
  String title;
  int id;
  List<CategoryDetail> details;

  Category(this.id, this.title, {this.details = const []});

  Category.fromJson(catg) {
    this.id = catg["id"];
    this.title = catg["title"];
    this.details = catg["details"];
  }
}

class CategoryDetail {
  int id;
  int categoryId;
  int attendance;
  double payment;

  CategoryDetail(this.id, this.categoryId, this.attendance, this.payment);

  CategoryDetail.fromJson(catgDetail) {
    this.id = catgDetail["id"];
    this.categoryId = catgDetail["category_id"];
    this.attendance = catgDetail["attendance"];
    this.payment = catgDetail["payment"];
  }
}
