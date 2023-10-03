import 'package:flutter/material.dart';
import 'package:rin_wallet/src/ui/layout/baseAppBar.dart';
import 'package:rin_wallet/src/ui/widgets/forms/create_transaction_form.dart';

class AddTransactionPage extends StatelessWidget {
  const AddTransactionPage({super.key, @required this.walletId});

  final String? walletId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
          title: 'Add Transaction',
          bgColor: Theme.of(context).colorScheme.tertiaryContainer),
      body: Center(
        child: CreateTransactionForm(
          walletId: walletId,
        ),
      ),
    );
  }
}
