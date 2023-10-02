import 'package:flutter/material.dart';
import 'package:rin_wallet/src/base/db.dart';
import 'package:rin_wallet/src/models/transaction_category.dart';
import 'package:rin_wallet/src/ui/layout/baseAppBar.dart';
import 'package:rin_wallet/src/ui/page/add_transaction_category_page.dart';

class TransactionCategoryPage extends StatefulWidget {
  const TransactionCategoryPage({
    super.key,
  });

  @override
  State<TransactionCategoryPage> createState() =>
      _TransactionCategoryPageState();
}

class _TransactionCategoryPageState extends State<TransactionCategoryPage> {
  // int _counter = 0;
  var dbHelper = new DbHelper();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  late List<TransactionCategory> categories = [];
  int walletCount = 0;

  getList() async {
    List<TransactionCategory> data = await dbHelper.getTransactionCategories();
    setState(() {
      this.categories = data;
      walletCount = data.length;
    });
    print('@@@@@data');
    print(data);
  }

  @override
  void initState() {
    // super.initState();
    getList();
  }

  void _create() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const AddTransactionCategoryPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: 'Transaction Categories'),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        // color: Colors.white,
        // backgroundColor: Colors.blue,
        strokeWidth: 4.0,
        onRefresh: () async {
          await getList();
          // return Future<void>.delayed(const Duration(seconds: 3));
        },
        child: ListView.builder(
          // Providing a restorationId allows the ListView to restore the
          // scroll position when a user leaves and returns to the app after it
          // has been killed while running in the background.
          restorationId: 'homePageList',
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            final item = categories[index];

            return Dismissible(
              // Each Dismissible must contain a Key. Keys allow Flutter to
              // uniquely identify widgets.
              direction: DismissDirection.startToEnd,
              key: Key(item.id!),
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
                  categories.removeAt(index);
                });
                if (item != null) {
                  await dbHelper.deleteTransactionCategory(item.id!);
                }

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
                    child: Text(item.name!),
                  ),
                  onTap: () {}),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _create,
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
