class WalletTransaction {
  late String id;
  late String walletId;
  late double amount;
  late String walletTransactionTypeId; // ref TransactionType
  late String categoryId; // ref Category

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
    map["amount"] = amount;
    map["transactionTypeId"] = walletTransactionTypeId;
    map["categoryId"] = categoryId;
    map["description"] = description;
    map["imgUrl"] = imgUrl;
    map["dateTime"] = dateTime;
    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  WalletTransaction.fromObject(dynamic o) {
    id = o["id"];
    walletId = o["walletId"];
    amount = o["amount"];
    walletTransactionTypeId = o["transactionTypeId"];
    categoryId = o["categoryId"];
    description = o["description"];
    dateTime = DateTime.parse(o["dateTime"]);
    imgUrl = o["imgUrl"];
  }
}
