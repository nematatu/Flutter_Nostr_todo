import 'package:flutter/material.dart';
import 'timeline.dart';
import 'main.dart';
import 'todo_management/todo_list_store.dart';
import 'todo_management/todo.dart';
import 'profile.dart';

class record_widget extends StatefulWidget {
  final TODO? todo;
  record_widget([this.todo]);
  @override
  State<record_widget> createState() {
    return _record_widgetState();
  }

  static dynamic toto() {
    return print('test');
  }
}

class _record_widgetState extends State<record_widget> {
  final controller = TextEditingController();
  final _score = TodoListStore();
  late String _title;
  late String _detail;
  late bool _done;
  var myHomePage = MyHomePage(0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var todo = widget.todo;
    _title = todo?.title ?? "";
    _detail = todo?.detail ?? "";
    _done = todo?.done ?? false;
  }

  Widget build(BuildContext context) {
    Future func() {
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => profile()));
    }

    void func2() {
      return Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("record"),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  //モーダルの背景の色、透過
                  backgroundColor: Colors.transparent,
                  //ドラッグ可能にする（高さもハーフサイズからフルサイズになる様子）
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                        height: 550,
                        margin: EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          //モーダル自体の色
                          color: Colors.white,
                          //角丸にする
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Container(
                            padding: EdgeInsets.all(30),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CheckboxListTile(
                                    title: Text('Complete'),
                                    value: _done,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _done = value ?? false;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  TextField(
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      labelText: "タイトル",
                                    ),
                                    controller: controller,
                                    onChanged: (String value) {
                                      _title = value;
                                    },
                                  ),
                                  SizedBox(height: 30),
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: '詳細',
                                    ),
                                    onChanged: (String value) {
                                      _detail = value;
                                    },
                                  ),
                                  SizedBox(height: 30),
                                  ElevatedButton(
                                    onPressed: () {
                                      _score.add(_done, _title, _detail);
                                      controller.clear();
                                      Navigator.of(context).pop();
                                      _done = false;
                                    },
                                    child: Text('保存'),
                                  ),
                                  SizedBox(height: 30),
                                ])));
                  });
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      drawer: myHomePage.drawer_func(func, func2),
      body: ListView.builder(
        itemCount: _score.count(),
        itemBuilder: ((context, index) {
          var item = _score.findByIndex(index);
          return ListTile(
            leading: Text(item.id.toString()),
            title: Text(item.title),
            trailing: Checkbox(
              value: item.done,
              onChanged: (bool? value) {
                setState(() {
                  _score.update(item, value!);
                });
              },
            ),
          );
        }),
      ),
    );
  }
}
/*
                  DatePicker.showTimePicker(context,
                      showTitleActions: true,
                      showSecondsColumn: false, onChanged: (date) {
                    print(date);
                  }, onConfirm: (date) {
                    print(date);
                  }, currentTime: DateTime.now(), locale: LocaleType.jp);
                },
                */