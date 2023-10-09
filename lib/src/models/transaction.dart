import 'dart:typed_data';

class WalletTransaction {
  late String id;
  late String walletId;
  late double amount;
  late String walletTransactionTypeId;
  late String categoryId;

  // optional
  String? base64Image;
  String? description = '';
  String? dateTime = DateTime.now().toString();
  // List<String>? imgUrl = [];

  WalletTransaction({
    required this.id,
    required this.walletId,
    required this.amount,
    required this.walletTransactionTypeId,
    required this.categoryId,
    this.description = '',
    // this.imgUrl = const [],
    this.dateTime,
    this.base64Image,
  }) {}

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["walletId"] = walletId;
    map["amount"] = amount ?? 0;
    map["walletTransactionTypeId"] = walletTransactionTypeId;
    map["categoryId"] = categoryId;
    map["description"] = description;
    // map["imgUrl"] = imgUrl;
    map["dateTime"] = dateTime.toString();
    map["base64Image"] = base64Image;
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
    dateTime = o["dateTime"];
    base64Image = o['base64Image'];
    // imgUrl = List.generate(o["imgUrl"].length, (i) {
    //   print(o["imgUrl"][i]);
    //   return o["imgUrl"][i];
    // });
  }
}
