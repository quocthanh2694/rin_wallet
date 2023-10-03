import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rin_wallet/src/base/db.dart';
import 'package:rin_wallet/src/models/charts/bar_chart.dart';
import 'package:rin_wallet/src/models/dashboards/transactionByMonth.dart';
import 'package:rin_wallet/src/models/transaction_type.dart';
import 'package:rin_wallet/src/ui/layout/baseAppBar.dart';
import 'package:rin_wallet/src/ui/page/dashboard/bar_chart.dart';
import 'package:rin_wallet/src/ui/page/dashboard/pie_chart_budget.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({super.key});

  @override
  State<StatefulWidget> createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  final db = new DbHelper();

  List<BarChartModel> list = [];
  TransactionType transactionType = TransactionType();

  initData() async {
    List<BarChartModel> _list = [];

    var res = await db.getTransactionTotalAmountByMonth();

    var groupByDate = groupBy(res, (obj) => obj.month);

    double i = 0;
    groupByDate.forEach((date, list) {
      print(date);
      print(list);

      List<TransactionByMonth> transactions = list as dynamic;
      double y1 = 0;
      dynamic originalY1 = 0;
      double y2 = 0;
      dynamic originalY2 = 0;

      for (int j = 0; j < transactions.length; j++) {
        TransactionByMonth element = transactions[j];
        if (transactionType.isDeposit(element.walletTransactionTypeId)) {
          y1 = element.total;
          originalY1 = element;
        }
        if (transactionType.isWithdraw(element.walletTransactionTypeId) ||
            transactionType.isTransfer(element.walletTransactionTypeId)) {
          y2 = element.total;
          originalY2 = element;
        }
      }

      BarChartModel temp = BarChartModel(
        x: i,
        originalX: date,
        y1: y1,
        originalY1: originalY1,
        y2: y2,
        originalY2: originalY2,
      );
      _list.add(temp);
      i++;
    });

    setState(() {
      this.list = _list;
    });
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: 'Dashboard'),
      body: ListView(children: [
        BarChartSample(
          rawData: list,
          title: 'Transactions'
        ),
        PieChartBudget(),
      ]),
    );
  }
}
