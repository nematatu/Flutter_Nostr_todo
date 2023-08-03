import 'package:flutter/material.dart';
import 'main.dart';
import 'profile.dart';

class report extends StatelessWidget {
  var myHomePage = MyHomePage(0);
  @override
  Widget build(BuildContext context) {
    Future func() {
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => profile()));
    }

    void func2() {
      return Navigator.pop(context);
    }

    return Scaffold(
        backgroundColor: Colors.pink,
        appBar: AppBar(
          title: Text("report"),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.add_outlined)),
          ],
        ),
        drawer: myHomePage.drawer_func(func, func2),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Icon(
                Icons.cake,
                size: 50,
              ),
            ])));
  }
}
