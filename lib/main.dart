import 'package:flutter/material.dart';
import 'timeline.dart';
import 'CakeScreen.dart';
import 'record.dart';
import 'profile.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BottomNav',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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

// SingleTickerProviderStateMixinを使用。後述
class _MyHomePageState extends State<MyHomePage> {
  final controller = TextEditingController();
  var _screen;
  late String appBar_title;
  Icon icon = Icon(Icons.thumb_up);

  // ページ下部に並べるナビゲーションメニューの一覧
  List<BottomNavigationBarItem> myBottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.sports_mma),
      label: 'Record',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.cake),
      label: 'Cake',
    ),
  ];

  void initState() {
    super.initState();
    this._screen = widget._screen;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      // Appbar

      // ページビュー
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

  List<Widget> wid = [timeline(), record_widget(), CakeScreen(), profile()];
  Widget widget_view(int index) {
    return wid[index];
  }
}
