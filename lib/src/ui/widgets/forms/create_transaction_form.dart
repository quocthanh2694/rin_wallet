// Create a Form widget.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:rin_wallet/src/base/db.dart';
import 'package:rin_wallet/src/models/transaction.dart';
import 'package:rin_wallet/src/models/transaction_category.dart';
import 'package:rin_wallet/src/models/currency_unit.dart';
import 'package:rin_wallet/src/models/transaction_type.dart';
import 'package:rin_wallet/src/models/wallet.dart';
import 'package:rin_wallet/src/models/wallet_type.dart';
import 'package:rin_wallet/src/utils/number.utils.dart';
import 'package:uuid/uuid.dart';

class CreateTransactionForm extends StatefulWidget {
  const CreateTransactionForm({super.key, required this.walletId});

  final String? walletId;

  @override
  CreateTransactionFormState createState() {
    return CreateTransactionFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class CreateTransactionFormState extends State<CreateTransactionForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.

  final transactionType = TransactionType();
  final transactionCategory = TransactionCategory();
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  late TextEditingController transactionTypeController;
  late TextEditingController transactionCategoryController;
  late TextEditingController walletController = TextEditingController();
  final descriptionController = TextEditingController();
  final initialAmountController = TextEditingController(text: '0');
  final dateTimeController =
      TextEditingController(text: DateTime.now().toString());

  var dbHelper = new DbHelper();

  late List<Wallet> wallets = [];

  getWallets() async {
    List<Wallet> data = await dbHelper.getWallets();
    setState(() {
      wallets = data;
    });
    walletController = TextEditingController(text: widget.walletId ?? '');
  }

  @override
  void initState() {
    getWallets();

    transactionTypeController =
        TextEditingController(text: transactionType.getList()[0].id);

    transactionCategoryController =
        TextEditingController(text: transactionCategory.getList()[0].id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
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
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 2,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Description',
                  ),
                ),
                AmountTextFormField(
                    initialAmountController: initialAmountController),
                DropdownButtonFormField(
                  value: walletController.text,
                  items: wallets.map((item) {
                    return DropdownMenuItem<String>(
                      value: item.id,
                      child: Text(item.name),
                    );
                  }).toList(),
                  onChanged: (val) {
                    print(val);
                    walletController.text = val.toString();
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Required';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Wallet',
                  ),
                ),
                DropdownButtonFormField(
                  value: transactionTypeController.text,
                  items: transactionType.getList().map((item) {
                    return DropdownMenuItem<String>(
                      value: item.id,
                      child: Text(item.name),
                    );
                  }).toList(),
                  onChanged: (val) {
                    print(val);
                    transactionTypeController.text = val.toString();
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Required';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Transaction Type',
                  ),
                ),
                DropdownButtonFormField(
                  value: transactionCategoryController.text,
                  items: transactionCategory.getList().map((item) {
                    return DropdownMenuItem<String>(
                      value: item.id,
                      child: Text(item.name),
                    );
                  }).toList(),
                  onChanged: (val) {
                    transactionCategoryController.text = val.toString();
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Required';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Category Type',
                  ),
                ),
                TextFormField(
                  controller: dateTimeController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    print(value);
                    // if (value.isEmpty || value.length < 1) {
                    //   return 'Choose Date';
                    // }
                  },
                  onTap: () {
                    DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      currentTime: DateTime.parse(dateTimeController.text),
                      minTime: DateTime(2018, 3, 5),
                      maxTime: DateTime(2019, 6, 7),
                      locale: LocaleType.en,
                      onChanged: (date) {
                        print('change $date');
                      },
                      onConfirm: (date) {
                        print('confirm $date');
                        dateTimeController.text = date.toString();
                      },
                    );
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Select datetime",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Container(
                    constraints:
                        const BoxConstraints(minWidth: double.infinity),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.

                          // print(_formKey);
                          WalletTransaction _transaction = WalletTransaction(
                            id: (new Uuid()).v1(),
                            description: descriptionController.text,
                            amount: double.parse(initialAmountController.text
                                .replaceAll(',', '')),
                            walletId: walletController.text,
                            walletTransactionTypeId:
                                transactionTypeController.text,
                            categoryId: transactionCategoryController.text,
                            dateTime: DateTime.parse(dateTimeController.text),
                          );

                          // appStore.addWallet(wallet);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Success!')),
                          );
                          Navigator.pop(context);
                          // print(_transaction.toMap());
                          dbHelper.insertTransaction(_transaction);
                        }
                      },
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

class AmountTextFormField extends StatelessWidget {
  const AmountTextFormField({
    super.key,
    required this.initialAmountController,
  });

  final TextEditingController initialAmountController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: initialAmountController,
      keyboardType: TextInputType.number,
      onChanged: (string) {
        String _onlyDigits = string.replaceAll(RegExp('[^0-9]'), "");
        String _newTxt = formatNumber(_onlyDigits);
        initialAmountController.value = TextEditingValue(
          text: _newTxt,
          selection: TextSelection.collapsed(offset: _newTxt.length),
        );
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        return null;
      },
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Amount',
      ),
    );
  }
}
