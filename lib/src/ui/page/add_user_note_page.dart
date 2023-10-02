import 'package:flutter/material.dart';
import 'package:rin_wallet/src/ui/layout/baseAppBar.dart';
import 'package:rin_wallet/src/ui/widgets/forms/create_user_note_form.dart';

class AddUserNotePage extends StatelessWidget {
  const AddUserNotePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: 'Add Note'),
      body: Center(
        child: const CreateUserNoteForm(),
      ),
    );
  }
}
