import 'package:flutter/material.dart';
import 'package:rin_wallet/src/ui/layout/baseAppBar.dart';
import 'package:rin_wallet/src/ui/widgets/forms/createWalletForm.dart';

class AddWalletPage extends StatelessWidget {
  const AddWalletPage({super.key, @required this.count});

  final int? count;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // appBar: BaseAppBar(
      //   title: Text('Wallet Detail'),
      //   appBar: AppBar(),
      //   widgets: <Widget>[Icon(Icons.more_vert)],
      // ),
      appBar: BaseAppBar(title: 'Add Wallet'),
      body: Center(
        child: CreateWalletForm(),
      ),
    );
  }
}
