import 'package:flutter/material.dart';
import 'package:rin_wallet/src/ui/layout/baseAppBar.dart';
import 'package:rin_wallet/src/ui/widgets/forms/create_transaction_category_form.dart';

class AddTransactionCategoryPage extends StatelessWidget {
  const AddTransactionCategoryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: 'Add Transaction Category'),
      body: Center(
        child: const CreateTransactionCategoryForm(),
      ),
    );
  }
}
