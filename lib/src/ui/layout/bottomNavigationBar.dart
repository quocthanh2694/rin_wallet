import 'package:flutter/material.dart';
import 'package:rin_wallet/src/sample_feature/sample_item_list_view.dart';
import 'package:rin_wallet/src/ui/page/add_transaction_page.dart';
import 'package:rin_wallet/src/ui/page/dashboard/dashboard_page.dart';
import 'package:rin_wallet/src/ui/page/home_page.dart';
import 'package:rin_wallet/src/ui/page/settingsPage.dart';
import 'package:rin_wallet/src/ui/page/login.dart';
import 'package:rin_wallet/src/ui/page/user_note_page.dart';

class BottomNavigationBarMain extends StatefulWidget {
  const BottomNavigationBarMain({super.key});

  @override
  State<BottomNavigationBarMain> createState() =>
      _BottomNavigationBarMainState();
}

class _BottomNavigationBarMainState extends State<BottomNavigationBarMain> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    // SampleItemListView(),
    DashboardPage(),
    Container(),
    SettingPage(),
    // LoginPage(),
    UserNotePage(),
  ];

  Widget getWidgetContent(int i) {
    return _widgetOptions.elementAt(i);
  }

  void _onItemTapped(int index) {
    if (index != 2) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddTransactionPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('BottomNavigationBar Sample'),
      // ),
      body: Center(
        child: getWidgetContent(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Transaction',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Note',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
