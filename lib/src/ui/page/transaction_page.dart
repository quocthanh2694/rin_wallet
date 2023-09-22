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
    Wallet data = await dbHelper.getWalletById(widget.walletId!);
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
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        strokeWidth: 4.0,
        onRefresh: () async {
          await getWalletById();
        },
        child: ListView(
          children: [
            wallet == null
                ? const SizedBox()
                : WalletCard(wallet: wallet!, onPressed: () => {}),
            ListView.builder(
              shrinkWrap: true,
              restorationId: 'transactionPageList',
              itemCount: transactions.length,
              itemBuilder: (BuildContext context, int index) {
                final item = transactions[index];

                return Column(
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
                );
              },
            ),
          ],
        ),
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
