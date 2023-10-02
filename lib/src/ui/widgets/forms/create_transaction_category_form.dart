// Create a Form widget.
import 'package:flutter/material.dart';
import 'package:rin_wallet/src/base/db.dart';
import 'package:rin_wallet/src/models/transaction_category.dart';
import 'package:rin_wallet/src/ui/page/transaction_categories_page.dart';
import 'package:uuid/uuid.dart';

class CreateTransactionCategoryForm extends StatefulWidget {
  const CreateTransactionCategoryForm({
    super.key,
  });

  @override
  CreateTransactionCategoryFormState createState() {
    return CreateTransactionCategoryFormState();
  }
}

class CreateTransactionCategoryFormState
    extends State<CreateTransactionCategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  var dbHelper = new DbHelper();

  _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      TransactionCategory _formData = TransactionCategory(
        id: (new Uuid()).v1(),
        name: nameController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Success!')),
      );
      await dbHelper.insertTransactionCategory(_formData);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Container(
                    constraints:
                        const BoxConstraints(minWidth: double.infinity),
                    child: ElevatedButton(
                      onPressed: _onSubmit,
                      child: const Text('Submit'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
