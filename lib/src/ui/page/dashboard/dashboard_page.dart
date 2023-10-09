import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:rin_wallet/src/base/db.dart';
import 'package:rin_wallet/src/models/charts/bar_chart.dart';
import 'package:rin_wallet/src/models/charts/chart_type.dart';
import 'package:rin_wallet/src/models/charts/pie_chart.dart';
import 'package:rin_wallet/src/models/dashboards/total_withdraw_by_wallet.dart';
import 'package:rin_wallet/src/models/dashboards/transactionByMonth.dart';
import 'package:rin_wallet/src/models/transaction_type.dart';
import 'package:rin_wallet/src/models/wallet.dart';
import 'package:rin_wallet/src/ui/layout/baseAppBar.dart';
import 'package:rin_wallet/src/ui/page/dashboard/bar_chart.dart';
import 'package:rin_wallet/src/ui/page/dashboard/pie_chart.dart';
import 'package:rin_wallet/src/utils/datetime.util.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({super.key});

  @override
  State<StatefulWidget> createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  final db = new DbHelper();

  final chartType = ChartType();

  List<PieChartModel> pieChartData = [];
  List<BarChartModel> list = [];
  TransactionType transactionType = TransactionType();
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();
  final chartTypeController = TextEditingController();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  late TextEditingController walletController = TextEditingController();
  var dbHelper = new DbHelper();
  late List<Wallet> wallets = [];

  final fromDatePieChartController = TextEditingController();
  final toDatePieChartController = TextEditingController();

  initPieChart() async {
    var res = await db.getTotalWithdrawByWallet(
      fromDate: fromDatePieChartController.text.isNotEmpty
          ? DateTime.parse(fromDatePieChartController.text)
          : null,
      toDate: toDatePieChartController.text.isNotEmpty
          ? DateTime.parse(toDatePieChartController.text)
          : null,
    );
    List<PieChartModel> list = [];
    for (int j = 0; j < res.length; j++) {
      TotalWithdrawByWallet element = res[j];
      PieChartModel temp = PieChartModel(
        name: element.walletName,
        value: element.total,
      );
      list.add(temp);
    }
    setState(() {
      pieChartData = list;
    });
  }

  initBarChartData() async {
    List<BarChartModel> _list = [];

    var res = await db.getTransactionTotalAmountStatistic(
        type: chartTypeController.text,
        walletId: walletController.text,
        fromDate: fromDateController.text.isNotEmpty
            ? DateTime.parse(fromDateController.text)
            : null,
        toDate: toDateController.text.isNotEmpty
            ? DateTime.parse(toDateController.text)
            : null);

    var groupByDate = groupBy(res, (obj) => obj.month);

    double i = 0;
    groupByDate.forEach((date, list) {
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

  getWallets() async {
    List<Wallet> data = await dbHelper.getWallets();
    setState(() {
      wallets = data;
    });
  }

  // _onSubmitFilter() {
  //   initData();
  // }

  _onClear() {
    fromDateController.clear();
    toDateController.clear();
    _key.currentState?.reset();
    walletController.clear();
    initBarChartData();
  }

  @override
  void initState() {
    super.initState();
    // bar chart
    initBarChartData();
    getWallets();

    // pie chart
    initPieChart();
  }

  @override
  Widget build(BuildContext context) {
    print('@@@@@@@@@@@@@@@@@@@@@@@@');
    print(pieChartData);

    return Scaffold(
      appBar: const BaseAppBar(title: 'Dashboard'),
      body: ListView(children: [
        // bar chart
        TotalDepositWithdrawChart(),

        // pie chart
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Total withdraw (VND)',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
              Row(
                children: [
                  FromDateWidget(
                      fromDateController: fromDatePieChartController,
                      initData: initPieChart),
                  ToDateWidget(
                      toDateController: toDatePieChartController,
                      initData: initPieChart),
                ],
              ),
              pieChartData.length > 0
                  ? PieChartSample(
                      rawData: pieChartData,
                    )
                  : Container(
                      child: Text('Empty Data'),
                    ),
            ],
          ),
        ),
      ]),
    );
  }

  Container TotalDepositWithdrawChart() {
    return Container(
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Transactions (VND)',
                style: TextStyle(color: Colors.black, fontSize: 22),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField(
                        key: _key,
                        hint: Text('All wallet'),
                        value: walletController.text.isNotEmpty
                            ? walletController.text
                            : null,
                        items: wallets.map((item) {
                          return DropdownMenuItem<String>(
                            value: item.id,
                            child: Text(item.name),
                          );
                        }).toList(),
                        onChanged: (val) {
                          walletController.text = val.toString();
                          initBarChartData();
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Required';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Wallet',
                        ),
                      ),
                    ),
                    Expanded(
                      child: DropdownButtonFormField(
                        hint: Text('Month'),
                        value: chartTypeController.text.isNotEmpty
                            ? chartTypeController.text
                            : null,
                        items: chartType.getList().map((item) {
                          return DropdownMenuItem<String>(
                            value: item.id,
                            child: Text(item.name),
                          );
                        }).toList(),
                        onChanged: (val) {
                          chartTypeController.text = val.toString();
                          initBarChartData();
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Required';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Chart Type',
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    FromDateWidget(
                        fromDateController: fromDateController,
                        initData: initBarChartData),
                    ToDateWidget(
                        toDateController: toDateController,
                        initData: initBarChartData),
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: _onClear,
                      child: const Text('Clear'),
                    ),
                    // ElevatedButton(
                    //   onPressed: _onSubmitFilter,
                    //   child: const Text('Submit'),
                    // ),
                  ],
                ),
              ],
            ),
          ),
          BarChartSample(
            rawData: list,
          ),
        ],
      ),
    );
  }
}

class ToDateWidget extends StatelessWidget {
  const ToDateWidget({
    super.key,
    required this.toDateController,
    required this.initData,
  });

  final TextEditingController toDateController;
  final dynamic initData;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: toDateController,
        keyboardType: TextInputType.phone,
        validator: (value) {},
        onTap: () {
          DatePicker.showDatePicker(
            context,
            showTitleActions: true,
            currentTime: toDateController.text.isEmpty
                ? null
                : DateTime.parse(toDateController.text),
            minTime: DateTime(2020, 1, 1),
            locale: LocaleType.en,
            onChanged: (date) {},
            onConfirm: (date) {
              toDateController.text = formatDate(date);
              initData();
            },
          );
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: "To Date",
        ),
      ),
    );
  }
}

class FromDateWidget extends StatelessWidget {
  const FromDateWidget({
    super.key,
    required this.fromDateController,
    required this.initData,
  });

  final TextEditingController fromDateController;
  final dynamic initData;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: fromDateController,
        keyboardType: TextInputType.phone,
        validator: (value) {},
        onTap: () {
          DatePicker.showDatePicker(
            context,
            showTitleActions: true,
            currentTime: fromDateController.text.isEmpty
                ? null
                : DateTime.parse(fromDateController.text),
            minTime: DateTime(2020, 1, 1),
            locale: LocaleType.en,
            onChanged: (date) {},
            onConfirm: (date) {
              fromDateController.text = formatDate(date);
              initData();
            },
          );
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: "From Date",
        ),
      ),
    );
  }
}
