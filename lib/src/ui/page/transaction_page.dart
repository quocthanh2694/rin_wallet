import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rin_wallet/src/base/db.dart';
import 'package:rin_wallet/src/models/transaction.dart';
import 'package:rin_wallet/src/models/wallet.dart';
import 'package:rin_wallet/src/ui/layout/baseAppBar.dart';
import 'package:rin_wallet/src/ui/page/add_transaction_page.dart';
import 'package:rin_wallet/src/ui/widgets/transaction_card.dart';
import 'package:rin_wallet/src/ui/widgets/walletCard.dart';

class TransactionPage extends StatefulWidget {
  TransactionPage({super.key, required this.walletId});

  String? walletId;

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  // int _counter = 0;
  File? imageFile;
  final List<String> items = List.generate(20, (index) => '${index}');
  var dbHelper = new DbHelper();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Wallet? wallet;
  List<WalletTransaction> transactions = [];

  getWalletById() async {
    if (widget.walletId!.isEmpty) return;
    Wallet? data = await dbHelper.getWalletById(widget.walletId!);
    if (data == null) return;
    setState(() {
      this.wallet = data;
    });
  }

  getTransactions() async {
    if (widget.walletId!.isEmpty) return;
    List<WalletTransaction> data =
        await dbHelper.getTransactions(widget.walletId!);
    setState(() {
      this.transactions = data;
    });
    print('Transactions result: ');
    print(data);
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: 'Transaction'), // wallet?.name),
      body: Column(
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
            child: RefreshIndicator(
                key: _refreshIndicatorKey,
                strokeWidth: 4.0,
                onRefresh: () async {
                  getWalletById();
                  getTransactions();
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  restorationId: 'transactionPageList',
                  itemCount: transactions.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = transactions[index];
          
                    return Dismissible(
                      // Each Dismissible must contain a Key. Keys allow Flutter to
                      // uniquely identify widgets.
                      direction: DismissDirection.startToEnd,
                      key: Key(item.id),
                      // Provide a function that tells the app
                      // what to do after an item has been swiped away.
                      confirmDismiss: (DismissDirection direction) async {
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
                                        Navigator.of(context).pop(true),
                                    child: const Text("DELETE")),
                                MaterialButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
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
          
                        await dbHelper.deleteTransaction(item.id);
          
                        // Then show a snackbar.
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Deleted successfull!')));
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
                                    transaction: item, onPressed: () => {}),
                              ),
                              leading: const CircleAvatar(
                                // Display the Flutter Logo image asset.
                                foregroundImage:
                                    AssetImage('assets/images/flutter_logo.png'),
                              ),
                              onTap: () {}),
                        ],
                      ),
                    );
                  },
                )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createTransaction,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(100),
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
                topLeft: Radius.circular(100))),
      ),
    );
  }
}
