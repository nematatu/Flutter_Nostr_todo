import 'package:flutter/material.dart';
import 'timeline.dart';
import 'report.dart';
import 'menu.dart';
import 'profile.dart';
import 'todo_management/todo_list_store.dart';
import 'menu.dart';

void main() {
  TodoListStore();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BottomNav',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: MyHomePage(0),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  Drawer drawer_func(Function func, Function func2) {
    return Drawer(
        child: ListView(
      children: [
        DrawerHeader(
            child: Text(
              'koso_practice_SNS',
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            )),
        ListTile(
          title: Text('Home'),
          onTap: () {
            func2;
          },
        ),
        ListTile(
          onTap: () {
            _screen = 3;
            func();
          },
          title: Text('Profile'),
        ),
        ListTile(title: Text('')),
      ],
    ));
  }

  int _screen;
  MyHomePage(this._screen);

  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = TextEditingController();
  var _screen;

  // ページ下部に並べるナビゲーションメニューの一覧
  List<BottomNavigationBarItem> myBottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: 'home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.widgets_outlined),
      label: 'menu',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.show_chart),
      label: 'report',
    ),
  ];

  void initState() {
    super.initState();
    this._screen = widget._screen;
    setState(() {
      TodoListStore().load();
    });
    setState(() {
      calendarStore().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: wid[_screen],
      // ページ下部のナビゲーションメニュー
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        // 現在のページインデックス
        currentIndex: _screen,
        // onTapでナビゲーションメニューがタップされた時の処理を定義
        onTap: (index) {
          setState(() {
            _screen = index;
          });
        },
        items: myBottomNavBarItems,
      ),
    );
  }

  List<Widget> wid = [timeline(), menu(), report(), profile()];
  Widget widget_view(int index) {
    return wid[index];
  }
}
