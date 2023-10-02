import 'package:flutter/material.dart';
import 'package:rin_wallet/src/base/db.dart';
import 'package:rin_wallet/src/models/transaction_category.dart';
import 'package:rin_wallet/src/models/user_note.dart';
import 'package:rin_wallet/src/ui/layout/baseAppBar.dart';
import 'package:rin_wallet/src/ui/page/add_transaction_category_page.dart';
import 'package:rin_wallet/src/ui/page/add_user_note_page.dart';

class UserNotePage extends StatefulWidget {
  const UserNotePage({
    super.key,
  });

  @override
  State<UserNotePage> createState() => _UserNotePageState();
}

class _UserNotePageState extends State<UserNotePage> {
  var dbHelper = new DbHelper();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  late List<UserNote> userNotes = [];
  int walletCount = 0;

  getList() async {
    List<UserNote> data = await dbHelper.getUserNotes();
    setState(() {
      this.userNotes = data;
      walletCount = data.length;
    });
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

  void _create() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddUserNotePage()),
    ).then((value) {
      if (value == true) {
        getList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: 'Notes'),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        strokeWidth: 4.0,
        onRefresh: () async {
          await getList();
        },
        child: ListView.builder(
          restorationId: 'homePageList',
          itemCount: userNotes.length,
          itemBuilder: (BuildContext context, int index) {
            final item = userNotes[index];

            return Dismissible(
              // Each Dismissible must contain a Key. Keys allow Flutter to
              // uniquely identify widgets.
              direction: DismissDirection.startToEnd,
              key: Key(item.id!),
              // Provide a function that tells the app
              // what to do after an item has been swiped away.
              confirmDismiss: (DismissDirection direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirm"),
                      content: const Text(
                          "Are you sure you wish to delete this item?"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text("DELETE")),
                        MaterialButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("CANCEL"),
                        ),
                      ],
                    );
                  },
                );
              },
              onDismissed: (direction) async {
                // Remove the item from the data source.
                setState(() {
                  userNotes.removeAt(index);
                });
                if (item != null) {
                  await dbHelper.deleteUserNote(item.id!);
                }

                // Then show a snackbar.
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Deleted successfull!')));
              },
              // Show a red background as the item is swiped away.
              background: Container(
                color: Colors.red,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text(
                        'Delete',
                        style: Theme.of(context)
                            .textTheme
                            .apply(
                                bodyColor:
                                    Theme.of(context).dialogBackgroundColor)
                            .headlineSmall,
                      )),
                    ),
                  ],
                ),
              ),
              child: ListTile(
                  title: Padding(
                    padding: EdgeInsets.all(1),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Text(
                            item.note,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(item.description),
                        ]),
                      ),
                    ),
                  ),
                  onTap: () {}),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _create,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(100),
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
                topLeft: Radius.circular(100))),
      ),
    );
  }
}
