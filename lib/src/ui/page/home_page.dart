import 'dart:io';

import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rin_wallet/src/base/db.dart';
import 'package:rin_wallet/src/models/cart.dart';
import 'package:rin_wallet/src/models/catalog.dart';
import 'package:rin_wallet/src/models/wallet.dart';
import 'package:rin_wallet/src/ui/layout/baseAppBar.dart';
import 'package:rin_wallet/src/ui/page/add_wallet_page.dart';
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
    ).then((value) {
      if (value == true) {
        getWallets();
      }
    });
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
            restorationId: 'homePageList',
            itemCount: wallets.length,
            itemBuilder: (BuildContext context, int index) {
              final item = wallets[index];

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
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("DELETE")),
                          MaterialButton(
                            onPressed: () => Navigator.of(context).pop(false),
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
                    wallets.removeAt(index);
                  });

                  await dbHelper.deleteWallet(item.id);

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
                                  bodyColor:
                                      Theme.of(context).dialogBackgroundColor)
                              .headlineSmall,
                        )),
                      ),
                    ],
                  ),
                ),
                child: ListTile(
                    title: Padding(
                      padding: EdgeInsets.all(1),
                      child: WalletCard(wallet: item, onPressed: () => {}),
                    ),
                    leading: const CircleAvatar(
                      // Display the Flutter Logo image asset.
                      foregroundImage:
                          AssetImage('assets/images/flutter_logo.png'),
                    ),
                    onTap: () {}),
              );
            },
          ),
        ),
        floatingActionButton: DraggableFab(
          child: FloatingActionButton(
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
        ));
  }
}
