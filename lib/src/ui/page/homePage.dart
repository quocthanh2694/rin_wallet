import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rin_wallet/src/base/db.dart';
import 'package:rin_wallet/src/models/cart.dart';
import 'package:rin_wallet/src/models/catalog.dart';
import 'package:rin_wallet/src/models/wallet.dart';
import 'package:rin_wallet/src/ui/layout/baseAppBar.dart';
import 'package:rin_wallet/src/ui/page/addWalletPage.dart';
import 'package:rin_wallet/src/ui/page/walletDetailPage.dart';
import 'package:rin_wallet/src/ui/widgets/walletCard.dart';

class Test {
  int id = 0;
  String name = 'Hello';
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  getItems() {
    var jsonData = new Test();

    return jsonData;
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // int _counter = 0;
  File? imageFile;
  final List<String> items = List.generate(20, (index) => '${index}');
  var dbHelper = new DbHelper();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  late List<Wallet> wallets = [];
  int walletCount = 0;

  getWallets() async {
    List<Wallet> data = await dbHelper.getWallets();
    setState(() {
      this.wallets = data;
      walletCount = data.length;
    });
  }

  @override
  void initState() {
    // super.initState();
    getWallets();
  }

  void _createWallet() {
    // setState(() {
    //   _counter++;
    // });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddWalletPage()),
    );
  }

  void _addToCart() {
    var cart = context.read<CartModel>();
    cart.add(new Item(1, 'Abc'));
  }

  void _navigateToSetting() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WalletDetailPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: 'Home'),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        // color: Colors.white,
        // backgroundColor: Colors.blue,
        strokeWidth: 4.0,
        onRefresh: () async {
          await getWallets();
          // return Future<void>.delayed(const Duration(seconds: 3));
        },
        child: ListView.builder(
          // Providing a restorationId allows the ListView to restore the
          // scroll position when a user leaves and returns to the app after it
          // has been killed while running in the background.
          restorationId: 'sampleItemListView',
          itemCount: wallets.length,
          itemBuilder: (BuildContext context, int index) {
            final item = wallets[index];

            return ListTile(
                title: Padding(
                  padding: EdgeInsets.all(1),
                  child: WalletCard(wallet: item, onPressed: () => {}),
                ),
                leading: const CircleAvatar(
                  // Display the Flutter Logo image asset.
                  foregroundImage: AssetImage('assets/images/flutter_logo.png'),
                ),
                onTap: () {});
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createWallet,
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
