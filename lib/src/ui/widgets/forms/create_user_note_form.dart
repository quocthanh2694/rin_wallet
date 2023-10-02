// Create a Form widget.
import 'package:flutter/material.dart';
import 'package:rin_wallet/src/base/db.dart';
import 'package:rin_wallet/src/models/user_note.dart';
import 'package:uuid/uuid.dart';

class CreateUserNoteForm extends StatefulWidget {
  const CreateUserNoteForm({
    super.key,
  });

  @override
  CreateUserNoteFormState createState() {
    return CreateUserNoteFormState();
  }
}

class CreateUserNoteFormState extends State<CreateUserNoteForm> {
  final _formKey = GlobalKey<FormState>();
  final noteController = TextEditingController();
  final descriptionController = TextEditingController();

  var dbHelper = new DbHelper();

  _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      UserNote _formData = UserNote(
        id: (new Uuid()).v1(),
        note: noteController.text,
        description: descriptionController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Success!')),
      );
      await dbHelper.insertUserNotes(_formData);
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
                  controller: noteController,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
                TextFormField(
                  controller: descriptionController,
                  maxLines: null,
                  minLines: 8,
                  keyboardType: TextInputType.multiline,
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
