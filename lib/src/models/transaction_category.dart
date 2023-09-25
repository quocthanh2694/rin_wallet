class TransactionCategory {
  late String id;
  late String name;

  TransactionCategory({
    required String id,
    required String name,
  }) {
    this.id = id;
    this.name = name;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = name;
    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  TransactionCategory.fromObject(dynamic o) {
    id = o["id"];
    name = o["name"].toString();
  }
}
