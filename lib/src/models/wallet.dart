class Wallet {
  // required
  late String id;
  late String name;
  late String walletTypeId;
  late DateTime dateTime;

  // optional
  dynamic? currencyUnit;
  String? description;
  double? initialAmount;

  // others
  double? totalDeposit;
  double? totalWithdraw;
  double? balance;

  Wallet({
    required this.id,
    required this.name,
    required this.walletTypeId,
    required this.dateTime,
    this.currencyUnit = 'vnd',
    this.description = '',
    this.initialAmount,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = name;
    map["walletTypeId"] = walletTypeId;
    map["dateTime"] = dateTime.toString();
    map["currencyUnit"] = currencyUnit.toString();
    map["description"] = description;
    map["initialAmount"] = initialAmount ?? 0;
    map["totalDeposit"] = totalDeposit ?? 0;
    map["totalWithdraw"] = totalWithdraw ?? 0;
    map["balance"] = balance ?? 0;
    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  Wallet.fromObject(dynamic o) {
    this.id = o["id"];
    this.name = o["name"];
    this.walletTypeId = o["walletTypeId"];
    this.dateTime = DateTime.parse(o["dateTime"]);
    this.currencyUnit = o["currencyUnit"];
    this.description = o["description"];
    this.initialAmount = o["initialAmount"];
    this.totalDeposit = o["totalDeposit"];
    this.totalWithdraw = o["totalWithdraw"];
    this.balance = o["balance"];
  }
}
