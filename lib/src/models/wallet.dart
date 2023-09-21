import 'dart:ffi';
import 'package:rin_wallet/src/constant/constant.dart';
import 'package:rin_wallet/src/models/transaction.dart';
import 'package:rin_wallet/src/models/walletType.dart';
import 'package:uuid/uuid.dart';

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
  // List<String>? transactionIds = [];

//  Map<String, Object?> map,
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
    map["initialAmount"] = initialAmount;
    map["totalDeposit"] = totalDeposit;
    map["totalWithdraw"] = totalWithdraw;
    map["balance"] = balance;
    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  Wallet.fromObject(dynamic o) {
    this.id = o["id"];
    this.name = o["name"];
    this.walletTypeId = o["walletTypeId"];
    this.dateTime =  DateTime.parse(o["dateTime"]);
    this.currencyUnit = o["currencyUnit"];
    this.description = o["description"];
    this.initialAmount = o["initialAmount"];
    this.totalDeposit = o["totalDeposit"];
    this.totalWithdraw = o["totalWithdraw"];
    this.balance = o["balance"];
  }

  // Wallet.fromObject(dynamic o) {
  //   this.id = o["id"];
  //   this.name = o["name"];
  //   this.walletTypeId = o["walletTypeId"];
  //   this.dateTime = o["dateTime"];
  //   this.currencyUnit = o["currencyUnit"];
  //   this.description = o["description"];
  //   this.initialAmount = o["initialAmount"];
  //   this.totalDeposit = o["totalDeposit"];
  //   this.totalWithdraw = o["totalWithdraw"];
  //   this.balance = o["balance"];
  // }
}
