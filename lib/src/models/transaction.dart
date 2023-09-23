class WalletTransaction {
  late String id;
  late String walletId;
  late double amount;
  late String walletTransactionTypeId;
  late String categoryId;

  // optional
  String? description = '';
  DateTime? dateTime = DateTime.now();
  List<String>? imgUrl = [];

  WalletTransaction({
    required this.id,
    required this.walletId,
    required this.amount,
    required this.walletTransactionTypeId,
    required this.categoryId,
    this.description = '',
    this.imgUrl = const [],
    this.dateTime,
  }) {}

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["walletId"] = walletId;
    map["amount"] = amount ?? 0;
    map["walletTransactionTypeId"] = walletTransactionTypeId;
    map["categoryId"] = categoryId;
    map["description"] = description;
    map["imgUrl"] = imgUrl;
    map["dateTime"] = dateTime.toString();
    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  WalletTransaction.fromObject(dynamic o) {
    id = o["id"];
    walletId = o["walletId"];
    amount = o["amount"];
    walletTransactionTypeId = o["walletTransactionTypeId"];
    categoryId = o["categoryId"];
    description = o["description"].toString();
    dateTime = DateTime.parse(o["dateTime"]);
    imgUrl = List.generate(o["imgUrl"].length, (i) {
      print(o["imgUrl"][i]);
      return o["imgUrl"][i];
    });
  }
}
