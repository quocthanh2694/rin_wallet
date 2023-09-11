import 'dart:ffi';
import 'package:rin_wallet/src/constant/constant.dart';
import 'package:rin_wallet/src/models/transaction.dart';
import 'package:rin_wallet/src/models/walletType.dart';
import 'package:uuid/uuid.dart';

class Wallet {
  // required
  final Uuid id;
  final String name;
  final WalletType type;

  // optional
  final CurrencyUnit currencyUnit = CurrencyUnit.vnd;
  final String description = '';
  final Float initialAmount = 0 as Float;
  final DateTime dateTime = DateTime.now();

  // others
  final Float totalDeposit = 0 as Float;
  final Float totalWithdraw = 0 as Float;
  final Float balance = 0 as Float;
  final List<Transaction> transactions = [];

  Wallet({required this.id, required this.name, required this.type}) {}
}
