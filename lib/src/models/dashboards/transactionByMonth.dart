class TransactionByMonth {
  late String walletTransactionTypeId;
  late String month;
  late double total;

  // Map<String, dynamic> toMap() {
  //   var map = Map<String, dynamic>();
  //   map["walletTransactionTypeId"] = walletTransactionTypeId;
  //   map["month"] = month;
  //   map["total"] = total;
  //   return map;
  // }

  TransactionByMonth.fromObject(dynamic o) {
    walletTransactionTypeId = o["walletTransactionTypeId"];
    month = o["month"]!
        .toString()
        .replaceAll('2022', '22')
        .replaceAll('2023', '23')
        .replaceAll('2024', '24')
        .replaceAll('2025', '25')
        .replaceAll('2026', '26');

    total = o["total"];
  }
}

class TransactionGroupedByMonth {
  // late String walletTransactionTypeId;
  late String month;
  List<TransactionByMonth> transactions = [];

  TransactionGroupedByMonth(
      {required String month,
      required List<TransactionByMonth> transactions}) {}
}
