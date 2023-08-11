import 'package:flutter/material.dart';
import 'package:ui_design/send_message.dart';
import 'main.dart';
import 'todo_management/todo_list_store.dart';
import 'todo_management/todo.dart';
import 'profile.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'report.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'continuation.dart';

class menu extends StatefulWidget {
  final TODO? todo;
  menu([this.todo]);
  @override
  State<menu> createState() {
    return _todo_listState();
  }
}

class calendar {
  late int year;
  late int month;
  late int day;
  late String title;
  late int datetime_milliseconds;
  calendar(
    this.year,
    this.month,
    this.day,
    this.title,
    this.datetime_milliseconds,
  );

  Map toJson() {
    return {
      'year': year,
      'month': month,
      'day': day,
      'title': title,
      'datetime': datetime_milliseconds,
    };
  }

  calendar.fromJson(Map json) {
    year = json['year'];
    month = json['month'];
    day = json['day'];
    title = json['title'];
    datetime_milliseconds = json['datetime'];
  }
}

class calendarStore {
  List<calendar> calendar_list = [];
  //List<Map<String, dynamic>> calendar_list = [];
  String _key = 'calendar';

  static final calendarStore _instance = calendarStore._internal();
  calendarStore._internal();
  factory calendarStore() {
    return _instance;
  }

  calendar findByIndex(int index) {
    return calendar_list[index];
  }

  List<calendar> findall() {
    return calendar_list;
  }

  int count() {
    return calendar_list.length;
  }

  // void add_to_calendar(DateTime datetime) {
  //   calendar_list.add({
  //     'year': int.parse(datetime.year.toString()),
  //     'month': int.parse(datetime.month.toString()),
  //     'day': int.parse(datetime.day.toString()),
  //   });
  //   save();
  // }

  void add_to_calendar(DateTime datetime, String title) {
    int year = int.parse(datetime.year.toString());
    int month = int.parse(datetime.month.toString());
    int day = int.parse(datetime.day.toString());
    int datetime_milliseconds = datetime.millisecondsSinceEpoch;
    var CALENDAR = calendar(year, month, day, title, datetime_milliseconds);
    //print('保存したリスト:$CALENDAR');
    calendar_list.add(CALENDAR);
    save();
  }

  void save() async {
    var prefs = await SharedPreferences.getInstance();
    var saveTargetList =
        calendar_list.map((a) => json.encode(a.toJson())).toList();

    prefs.setStringList(_key, saveTargetList);
    // print(saveTargetList);
  }

  void load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loadTargetList = prefs.getStringList(_key) ?? [];
    print("load_list" + loadTargetList.toString());
    calendar_list =
        loadTargetList.map((a) => calendar.fromJson(json.decode(a))).toList();
  }

  void delete() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    calendar_list.clear();
  }
}

class _todo_listState extends State<menu> {
  final continuationStore1 = continuationStore();
  int continuation_dates_count = 0;
  String int_key = "a";
  int list_count = -1;

  int index_num = 0;
  var calendarclass = calendarStore();
  Color color = Colors.black;
  final controller = TextEditingController();
  final _score = TodoListStore();
  late String _title;
  late String _detail;
  late bool _done;
  var myHomePage = MyHomePage(0);
  var datetime;

  void save_int(int a) async {
    var prefs = await SharedPreferences.getInstance();
    var saveTarget = a.toString();
    prefs.setString(int_key, saveTarget);
  }

  void load_int() async {
    var prefs = await SharedPreferences.getInstance();
    int target_toint = int.parse(prefs.getString(int_key)!);
    list_count = target_toint;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var todo = widget.todo;
    _title = todo?.title ?? "";
    _detail = todo?.detail ?? "";
    _done = todo?.done ?? false;

    setState(() {
      _score.load();
      calendarclass.load();
      load_int();
      // date_fuc();
      // continuation(datetime_list);
      // continuation_date(continuation_list);
      //continuationStore1.date_fuc();
      // continuationStore1.continuation();
      // continuationStore1.continuation_date();
    });
  }

  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController count = TextEditingController();
  TextEditingController text = TextEditingController();

  void onPressedRaisedButton() async {
    final DateTime? picked = await DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        currentTime: DateTime.now(),
        maxTime: DateTime.now(),
        locale: LocaleType.jp);

    if (picked != null) {
      // 日時反映
      setState(() {
        datetime = picked;
        date.text = datetime.year.toString() +
            "年" +
            " " +
            datetime.month.toString() +
            "月" +
            datetime.day.toString() +
            "日" +
            " " +
            datetime.hour.toString() +
            "時" +
            datetime.minute.toString() +
            "分";
      });
    }
  }

  /*void save(List<String> list) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_key, list);
  }

  void load() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      calendar_list = prefs.getStringList(_key) ?? [];
    });
  }*/

  void onPressedtime() async {
    final DateTime? picked = await DatePicker.showTimePicker(context,
        showTitleActions: true,
        showSecondsColumn: false,
        currentTime: DateTime.now(),
        locale: LocaleType.jp);
    if (picked != null) {
      setState(() {
        time.text = picked.hour.toString() +
            "時間" +
            " " +
            picked.minute.toString() +
            "分";
      });
    }
  }

  Widget build(BuildContext context) {
    double _deviceWidth = MediaQuery.of(context).size.width;
    double _deviceHeight = MediaQuery.of(context).size.height;

    Future func() {
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => profile()));
    }

    void func2() {
      return Navigator.pop(context);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("menu"),
          actions: [
            IconButton(
              onPressed: () {
                _done = false;
                showBarModalBottomSheet(
                    //モーダルの背景の色、透過
                    backgroundColor: Colors.transparent,
                    //ドラッグ可能にする（高さもハーフサイズからフルサイズになる様子）
                    //isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                          height: _deviceHeight * 0.9,
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
                                        setState(() {
                                          _score.load();
                                        });
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
        body: SingleChildScrollView(
            child: Column(children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _score.count(),
            itemBuilder: ((context, index) {
              var item = _score.findByIndex(index);
              return Padding(
                  padding: EdgeInsets.all(10),
                  child: TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          side: BorderSide(
                            width: 1,
                          )),
                      onPressed: () {
                        setState(() {
                          index_num = index;
                        });
                        count.text = '練習量';
                        time.text = '練習時間';
                        datetime = DateTime.now();
                        date.text = datetime.year.toString() +
                            "年" +
                            " " +
                            datetime.month.toString() +
                            "月" +
                            datetime.day.toString() +
                            "日" +
                            " " +
                            datetime.hour.toString() +
                            "時" +
                            datetime.minute.toString() +
                            "分";
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                color: Colors.grey[200],
                              ),
                              height: _deviceHeight * 0.95,
                              child: SingleChildScrollView(
                                  child: Column(children: [
                                SizedBox(height: 7),
                                Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(Icons.close),
                                        color: Colors.blue,
                                      ),
                                      Text(
                                        "記録を入力",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      TextButton(
                                        child: Text(
                                          "記録する",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        onPressed: () {
                                          send_message(item.title, time.text,
                                                  text.text)
                                              .sendMessage();
                                          calendarclass.add_to_calendar(
                                              datetime,
                                              _score.findByIndex(index).title);
                                          text.clear();
                                          setState(() {
                                            continuationStore1
                                                .clear_continuation();
                                            continuationStore1.clear_datetime();

                                            calendarclass.load();
                                            continuationStore1.date_fuc();
                                            continuationStore1.continuation();
                                            continuationStore1
                                                .continuation_date();
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Colors.black,
                                  thickness: 0.1,
                                  height: 2,
                                ),
                                SizedBox(height: 30),
                                Divider(
                                  color: Colors.black,
                                  thickness: 0.1,
                                  height: 2,
                                ),
                                Container(
                                    color: Colors.white,
                                    width: double.infinity,
                                    height: 200,
                                    child: Column(
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(width: 20),
                                              Icon(Icons.add),
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Container(
                                                  height: 50,
                                                  child: Center(
                                                    child: Text(item.title,
                                                        style: TextStyle(
                                                            fontSize: 25)),
                                                  )),
                                            ]),
                                        Divider(
                                          color: Colors.black,
                                          thickness: 0.1,
                                          height: 2,
                                          indent: 70,
                                        ),
                                        InkWell(
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Icon(Icons.timer),
                                                  SizedBox(width: 30),
                                                  Expanded(
                                                    child: TextField(
                                                      controller: time,
                                                      enabled: false,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ]),
                                            onTap: () {
                                              onPressedtime();
                                            }),
                                        Divider(
                                          color: Colors.black,
                                          thickness: 0.1,
                                          height: 2,
                                          indent: 70,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            onPressedRaisedButton();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Icon(Icons.calendar_month),
                                              SizedBox(width: 30),
                                              Expanded(
                                                  child: TextField(
                                                decoration: InputDecoration(
                                                    border: InputBorder.none),
                                                style: TextStyle(
                                                    color: Colors.black),
                                                controller: date,
                                                enabled: false,
                                              ))
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.black,
                                          thickness: 0.1,
                                          height: 2,
                                          indent: 70,
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Icon(Icons.sports),
                                              SizedBox(width: 30),
                                              Expanded(
                                                  child: TextField(
                                                style: TextStyle(
                                                    color: Colors.black),
                                                controller: count,
                                                enabled: false,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  suffixIcon: Icon(
                                                      Icons.navigate_next,
                                                      color: Colors.black),
                                                ),
                                              ))
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                                Divider(
                                  color: Colors.black,
                                  thickness: 0.1,
                                  height: 2,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                    color: Colors.white,
                                    height: 300,
                                    child: TextField(
                                      controller: text,
                                      enabled: true,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        //labelText: 'コメントを入力'
                                      ),
                                    ))
                              ])),
                            );
                          },
                        );

                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => menu_input(item),
                          ));
                          */
                      },
                      child: ListTile(
                        leading: Text(item.id.toString()),
                        title: Text(item.title),
                      )));
            }),
          ),
          ListView.builder(
            itemCount: calendarclass.count(),
            itemBuilder: (context, index) {
              var item2 = calendarclass.findByIndex(index);
              return ListTile(
                title: Text(item2.title.toString() +
                    "を" +
                    item2.year.toString() +
                    "年" +
                    item2.month.toString() +
                    "月" +
                    item2.day.toString() +
                    "日" +
                    'に練習しました'),
              );
            },
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  calendarclass.delete();
                  continuationStore1.clear_continuation();
                  continuationStore1.clear_datetime();
                  list_count = -1;
                  save_int(list_count);
                  TodoListStore().deleteall();
                });
                setState(() {});
              },
              child: Text('delete'))
        ])));
  }
}
