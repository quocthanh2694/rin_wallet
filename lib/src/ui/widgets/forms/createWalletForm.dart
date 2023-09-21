// Create a Form widget.
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:rin_wallet/src/base/db.dart';
import 'package:rin_wallet/src/constant/constant.dart';
import 'package:rin_wallet/src/models/appStore.dart';
import 'package:provider/provider.dart';
import 'package:rin_wallet/src/models/wallet.dart';
import 'package:uuid/uuid.dart';

class CreateWalletForm extends StatefulWidget {
  const CreateWalletForm({super.key});

  @override
  CreateWalletFormState createState() {
    return CreateWalletFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class CreateWalletFormState extends State<CreateWalletForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final walletTypeController = TextEditingController();
  final currencyUnitController = TextEditingController();
  final descriptionController = TextEditingController();
  final initialAmountController = TextEditingController(text: '0');
  final dateTimeController =
      TextEditingController(text: DateTime.now().toString());

  var dbHelper = new DbHelper();

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
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
                TextFormField(
                  controller: initialAmountController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Initial Amount',
                  ),
                ),
                DropdownButtonFormField(
                  items: CurrencyUnit.values.map((item) {
                    return DropdownMenuItem<String>(
                      value: item.name,
                      child: Text(item.name),
                    );
                  }).toList(),
                  onChanged: (val) {
                    print(val);
                    currencyUnitController.text = val.toString();
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Required';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Currency Unit',
                  ),
                ),
                DropdownButtonFormField(
                  items: <String>['walletType 1', 'walletTYpe 2'].map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (val) {
                    print(val);
                    walletTypeController.text = val.toString();
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Required';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Wallet Type',
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
                          print(walletTypeController.text);
                          // print(currencyUnitController.text);
                          // print(descriptionController.text);
                          // print(initialAmountController.text);
                          // print(dateTimeController.text);
                          // print(nameController.text);
                          // var appStore = context.read<AppStoreModel>();
                          Wallet wallet = Wallet(
                            id: (new Uuid()).v1(),
                            name: nameController.text,
                            walletTypeId: (new Uuid()).v1(),
                            dateTime: DateTime.parse(dateTimeController.text),
                            currencyUnit: currencyUnitController.text,
                            description: descriptionController.text,
                            initialAmount:
                                double.parse(initialAmountController.text),
                          );

                          // appStore.addWallet(wallet);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Added wallet')),
                          );
                          Navigator.pop(context);
                          print(wallet.toMap());
                          dbHelper.insertWallet(wallet);
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
