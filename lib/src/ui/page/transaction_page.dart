import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rin_wallet/src/base/db.dart';
import 'package:rin_wallet/src/models/transaction.dart';
import 'package:rin_wallet/src/models/transaction_category.dart';
import 'package:rin_wallet/src/models/transaction_type.dart';
import 'package:rin_wallet/src/models/wallet.dart';
import 'package:rin_wallet/src/ui/layout/baseAppBar.dart';
import 'package:rin_wallet/src/ui/page/add_transaction_page.dart';
import 'package:rin_wallet/src/ui/widgets/transaction_card.dart';
import 'package:rin_wallet/src/ui/widgets/walletCard.dart';
import 'package:rin_wallet/src/utils/number.utils.dart';

class TransactionPage extends StatefulWidget {
  TransactionPage({super.key, required this.walletId});

  String? walletId;

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  // int _counter = 0;
  File? imageFile;
  List<GroupedTransactionsByDate> groupedTransactions = [];
  final List<String> items = List.generate(20, (index) => '${index}');
  var dbHelper = new DbHelper();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Wallet? wallet;
  List<WalletTransaction> transactions = [];
  TransactionType transactionType = TransactionType();

  getWalletById() async {
    if (widget.walletId!.isEmpty) return;
    Wallet? data = await dbHelper.getWalletById(widget.walletId!);
    if (data == null) return;
    setState(() {
      this.wallet = data;
    });
  }

  generateGroupedTransaction() {
    List<GroupedTransactionsByDate> groupedTrans = [];
    var groupByDate = groupBy(
        transactions, (transaction) => transaction.dateTime!.substring(0, 10));

    groupByDate.forEach((date, list) {
      double totalDeposit = 0;
      double totalWithdraw = 0;
      list.forEach((element) {
        if (transactionType.isDeposit(element.walletTransactionTypeId)) {
          totalDeposit += element.amount;
        }
        if (transactionType.isWithdraw(element.walletTransactionTypeId)) {
          totalWithdraw += element.amount;
        }
      });
      var temp = GroupedTransactionsByDate(
          date: date,
          transactions: list,
          totalDeposit: totalDeposit,
          totalWithdraw: totalWithdraw);
      groupedTrans.add(temp);
    });
    setState(() {
      groupedTransactions = groupedTrans;
    });
  }

  getTransactions() async {
    if (widget.walletId!.isEmpty) return;
    List<WalletTransaction> data =
        await dbHelper.getTransactions(widget.walletId!);
    setState(() {
      this.transactions = data;
      generateGroupedTransaction();
    });
  }

  @override
  void initState() {
    super.initState();
    getWalletById();
    getTransactions();
  }

  void _createTransaction() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddTransactionPage(
                walletId: widget.walletId,
              )),
    ).then((value) {
      if (value == true) {
        getWalletById();
        getTransactions();
      }
    });
  }

  void _onViewImage(String? base64Image) {
    if (base64Image == null) return;

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
          child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(children: <Widget>[
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  height: 500,
                  child: PhotoView(
                    imageProvider: Image.memory(
                            const Base64Decoder().convert(base64Image!))
                        .image,
                    enableRotation: true,
                  ),
                ),
                const SizedBox(height: 15),
              ]),
            ],
          ),
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BaseAppBar(title: 'Transaction'), // wallet?.name),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          strokeWidth: 4.0,
          onRefresh: () async {
            getWalletById();
            getTransactions();
          },
          child: Column(
            children: [
              wallet == null
                  ? Container(
                      height: 0,
                      child: null,
                    )
                  : Container(
                      height: 100,
                      child: WalletCard(wallet: wallet!, onPressed: () => {})),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    // physics: const ClampingScrollPhysics(),
                    itemCount: groupedTransactions.length,
                    itemBuilder: (BuildContext context, int groupedIndex) {
                      final groupedTran = groupedTransactions[groupedIndex];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${groupedTran.date}"),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      formatNumber(trailingZero(
                                          groupedTran.totalDeposit ?? 0.0)),
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 16),
                                    ),
                                    Text(
                                      formatNumber(trailingZero(
                                          groupedTran.totalWithdraw ?? 0.0)),
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 16),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            // physics: ScrollPhysics(),
                            // physics: const AlwaysScrollableScrollPhysics(),
                            restorationId: 'transactionPageList',
                            itemCount: groupedTran.transactions.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = groupedTran.transactions[index];

                              return Dismissible(
                                // Each Dismissible must contain a Key. Keys allow Flutter to
                                // uniquely identify widgets.
                                direction: DismissDirection.startToEnd,
                                key: Key(item.id),
                                // Provide a function that tells the app
                                // what to do after an item has been swiped away.
                                confirmDismiss:
                                    (DismissDirection direction) async {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Confirm"),
                                        content: const Text(
                                            "Are you sure you wish to delete this item?"),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text("DELETE")),
                                          MaterialButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: const Text("CANCEL"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                onDismissed: (direction) async {
                                  // Remove the item from the data source.
                                  setState(() {
                                    transactions.removeAt(index);
                                  });

                                  await dbHelper.deleteTransaction(
                                      item.id, item);

                                  // Then show a snackbar.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Deleted successfull!')));

                                  // get wallet for update amount
                                  getWalletById();
                                },
                                // Show a red background as the item is swiped away.
                                background: Container(
                                  color: Colors.red,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child: Text(
                                          'Delete',
                                          style: Theme.of(context)
                                              .textTheme
                                              .apply(
                                                  bodyColor: Theme.of(context)
                                                      .dialogBackgroundColor)
                                              .headlineSmall,
                                        )),
                                      ),
                                    ],
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Padding(
                                        padding: EdgeInsets.all(1),
                                        child: TransactionCard(
                                            transaction: item,
                                            onPressed: () => {}),
                                      ),
                                      leading: Container(
                                          width: 50,
                                          height: 50,
                                          child: item.base64Image == null
                                              ? const CircleAvatar(
                                                  // Display the Flutter Logo image asset.
                                                  radius: 2,
                                                  foregroundImage: AssetImage(
                                                      'assets/images/flutter_logo.png'),
                                                )
                                              : Image.memory(
                                                  const Base64Decoder().convert(
                                                      item.base64Image!))
                                          // PhotoView(
                                          //     imageProvider: Image.memory(
                                          //             const Base64Decoder()
                                          //                 .convert(item.base64Image!))
                                          //         .image,
                                          //     enableRotation: true,
                                          //   ),
                                          ),
                                      //  const CircleAvatar(
                                      //     // Display the Flutter Logo image asset.
                                      //     // radius: 2,
                                      //     foregroundImage: AssetImage(
                                      //   base64Decode(item.imageBytes as Uint8List),
                                      // )
                                      //     //  AssetImage(
                                      //     //     'assets/images/flutter_logo.png'),
                                      //     ),
                                      // onTap: () {}
                                      onTap: () =>
                                          _onViewImage(item.base64Image),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
        // floatingActionButtonAnimator: NoScalingAnimation(),
        floatingActionButton: DraggableFab(
          child: FloatingActionButton(
            onPressed: _createTransaction,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(100),
                    bottomLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100),
                    topLeft: Radius.circular(100))),
          ),
        ));
  }
}
