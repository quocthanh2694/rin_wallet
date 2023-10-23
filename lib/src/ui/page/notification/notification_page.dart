import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rin_wallet/src/base/db.dart';
import 'package:rin_wallet/src/constant/constant.dart';
import 'package:rin_wallet/src/models/transaction_category.dart';
import 'package:rin_wallet/src/models/user_note.dart';
import 'package:rin_wallet/src/services/notificationservice.dart';
import 'package:rin_wallet/src/ui/layout/baseAppBar.dart';
import 'package:rin_wallet/src/ui/page/add_transaction_category_page.dart';
import 'package:rin_wallet/src/ui/page/add_user_note_page.dart';
import 'package:rin_wallet/src/ui/page/notification/counter_cubit.dart';
import 'package:rin_wallet/src/ui/page/notification/counter_state.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({
    super.key,
  });

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  var dbHelper = new DbHelper();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  late List<UserNote> userNotes = [];
  int walletCount = 0;
  bool hide = true;

  int _counter = 0;
  bool loading = false;

  getList() async {
    NotificationService().getAllScheduleNotifications();
    // List<UserNote> data = await dbHelper.getUserNotes();
    // setState(() {
    //   this.userNotes = data;
    //   walletCount = data.length;
    // });
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

  void _incrementCounter() {
    setState(() {
      loading = true;
    });
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _counter++;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: 'Notifications',
        actions: [
          IconButton(
            icon: Icon(hide ? Icons.remove_red_eye_sharp : Icons.password),
            onPressed: () {
              setState(() {
                this.hide = !this.hide;
              });
            },
          )
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        strokeWidth: 4.0,
        onRefresh: () async {
          await getList();
        },
        child: BlocProvider(
          create: (_) => CounterCubit(),
          child: Column(
            children: [
              loading
                  ? new CircularProgressIndicator()
                  : Text(
                      '$_counter',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
              BlocBuilder<CounterCubit, CounterState>(
                builder: (ctx, state) {
                  var label = state.label;
                  var count = state.count;
                  return Column(
                    children: [
                      Text(
                        "$label",
                      ),
                      Text(
                        "$count",
                      ),
                      ElevatedButton(
                          onPressed: () => ctx.read<CounterCubit>().increment(),
                          child: Text('Test bloc pattern increase')),
                    ],
                  );
                },
              ),
              TextButton(
                  onPressed: () {
                    NotificationService().showNotification(
                      1,
                      'Noti title',
                      'Noti des...',
                    );
                  },
                  child: const Text('Test notification')),
              TextButton(
                  onPressed: () {
                    NotificationService().scheduleShowNotification(
                        1,
                        'Schedule Noti title',
                        'Schedule noti des...',
                        Duration(seconds: 2));
                  },
                  child: const Text('Schedule a notification after 2 seconds')),
              Expanded(
                child: ListView.builder(
                  restorationId: 'notificationPageList',
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
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text("DELETE")),
                                MaterialButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
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
                                        bodyColor: Theme.of(context)
                                            .dialogBackgroundColor)
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        hide
                                            ? "${item.title.substring(0, 4)}${HIDDEN_TEXT}${item.title.length > 10 ? item.title.substring(item.title.length - 5) : ''}"
                                            : item.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                      Text(
                                        hide ? HIDDEN_TEXT : item.note,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      Text(
                                        hide ? HIDDEN_TEXT : item.description,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                          onTap: () {}),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
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