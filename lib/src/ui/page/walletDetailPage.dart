import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rin_wallet/src/models/cart.dart';

class WalletDetailPage extends StatelessWidget {
  const WalletDetailPage({super.key, @required this.count});

  final int? count;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: BaseAppBar(
      //   title: Text('Wallet Detail'),
      //   appBar: AppBar(),
      //   widgets: <Widget>[Icon(Icons.more_vert)],
      // ),
      body: Center(
        child: Column(
          children: [
            Consumer<CartModel>(
                builder: (context, cart, child) => Text(
                      '\$${cart.totalPrice} - ${cart.items.length}',
                    )),
            Text('${this.count}'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go back!'),
            )
          ],
        ),
      ),
    );
  }
}
