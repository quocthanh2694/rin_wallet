import 'package:flutter/material.dart';
import 'package:rin_wallet/src/ui/layout/baseAppBar.dart';
import 'package:rin_wallet/src/ui/widgets/forms/create_wallet_form.dart';

class AddWalletPage extends StatelessWidget {
  const AddWalletPage({super.key, @required this.count});

  final int? count;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: BaseAppBar(title: 'Add Wallet'),
      body: Center(
        child: CreateWalletForm(),
      ),
    );
  }
}
