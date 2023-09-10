import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
// import 'package:rin_wallet/ui/layout/baseAppBar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rin_wallet/src/models/cart.dart';
import 'package:rin_wallet/src/models/catalog.dart';
import 'package:rin_wallet/src/ui/page/walletDetailPage.dart';

class Test {
  int id = 0;
  String name = 'Hello';
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

class SettingPage extends StatefulWidget {
  const SettingPage({
    super.key,
  });

  getItems() {
    var jsonData = new Test();

    return jsonData;
  }

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
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
    var data = SettingPage().getItems();
    var jsonData = data.toJson();

    return Scaffold(
      // appBar: BaseAppBar(
      //   title: Text('Settings'),
      //   appBar: AppBar(),
      //   widgets: <Widget>[Icon(Icons.more_vert)],
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: _addToCart,
              child: const Text('Add item to cart'),
            ),
            TextButton(
              onPressed: _navigateToSetting,
              child: const Text('NavigateTo detail wallet'),
            ),
            TextButton(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => Dialog(
                    child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Column(children: <Widget>[
                          SizedBox(height: 15),
                          Text('This is a typical dialog.'),
                          SizedBox(height: 15),
                        ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Close'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Submit'),
                              )
                            ]),
                      ],
                    ),
                  ),
                )),
              ),
              child: const Text('Show Dialog'),
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter your text',
              ),
            ),
            JsonView.map(
              jsonData,
              theme: const JsonViewTheme(
                backgroundColor: Colors.white,
                keyStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                doubleStyle: TextStyle(
                  color: Colors.orange,
                  fontSize: 16,
                ),
                intStyle: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                stringStyle: TextStyle(
                  color: Color.fromARGB(255, 255, 85, 0),
                  fontSize: 16,
                ),
                boolStyle: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                ),
                closeIcon: Icon(
                  Icons.arrow_drop_up,
                  color: Colors.green,
                  size: 20,
                ),
                openIcon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.green,
                  size: 20,
                ),
                separator: Text(':'),
              ),
            ),
            Text(jsonEncode(data.toJson())),
            ElevatedButton(
              child: const Text('Copy json'),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: jsonEncode(jsonData)));
                Fluttertoast.showToast(
                    msg: "Coppied!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
