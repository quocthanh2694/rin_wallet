import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:rin_wallet/src/constant/constant.dart';
import 'package:rin_wallet/src/models/wallet.dart';
import 'package:uuid/uuid.dart';

class Transaction {
  final Uuid id;
  final Wallet wallet;
  final Float amount;
  final TransactionType type;
  final Category category;

  // optional
  final String description = '';
  final DateTime dateTime = DateTime.now();
  final List<String> imgUrl = [];

  Transaction(
      {required this.id,
      required this.wallet,
      required this.amount,
      required this.type,
      required this.category}) {}
}
