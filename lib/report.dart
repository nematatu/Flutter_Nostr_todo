import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'profile.dart';
import 'package:table_calendar/table_calendar.dart';
import 'continuation.dart';
import 'todo_management/todo_list_store.dart';

class report extends StatefulWidget {
  State<report> createState() => _reportState();
}

class _reportState extends State<report> {
  final _score = TodoListStore();
  @override
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime? _selectedDay;
  final TextEditingController test = TextEditingController();

  static var a = int.parse("2023");
  static var b = int.parse("10");
  static var c = int.parse("3");

  final sampleMap = {
    DateTime.utc(a, b, c): ['Birth Day', 'sencondEvent'],
    DateTime.utc(2023, 9, 2): ['badminton competition', 'best my self'],
  };
  var eventsample = <DateTime, List<String>>{};
  List<String> _selectedEvents = [];
  String key = 'event';
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

    void save(Map<DateTime, List<String>> a) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> newmap = {};
      a.forEach((key, value) {
        newmap[key.toString()] = a[key];
      });
      final event = json.encode({newmap});
      print(event);

      await prefs.setString(key, event);
    }

    void load() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        eventsample = json.decode(prefs.getString(key) ?? '');
      });
    }

    initState() {
      super.initState();
      setState(() {
        load();
      });
    }

    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text("report"),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.add_outlined)),
          ],
        ),
        drawer: myHomePage.drawer_func(func, func2),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Row(children: [
              Text(
                continuationStore.instance.continuation_dates_count.toString(),
                style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
              ),
              Text(' Days',
                  style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold)),
            ]),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                //scrollDirection: Axis.horizontal,
                itemCount: _score.count(),
                itemBuilder: ((context, index) {
                  var _item = _score.findByIndex(index);
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          side: BorderSide(width: 1),
                        ),
                        onPressed: () {},
                        child: ListTile(
                          title: Text(_item.title),
                        )),
                  );
                })),
          ],
        )));
  }
}
        /*TableCalendar(
                firstDay: DateTime.utc(2023, 1, 1),
                lastDay: DateTime.utc(2023, 10, 3),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusDay;
                    if (!eventsample.containsKey(_focusedDay)) {
                      eventsample[_focusedDay] = [];
                    }
                    //_selectedEvents = eventsample[selectedDay] ?? [];
                  });
                },
                eventLoader: (date) {
                  return eventsample[date] ?? [];
                }),
            Expanded(
              child: ListView.builder(
                itemCount: eventsample[_focusedDay]?.length,
                itemBuilder: (context, index) {
                  var event = eventsample[index];
                  return Card(
                      child: ListTile(
                          title: Text(eventsample[_focusedDay]?[index] ?? "")));
                },
              ),
            ),
            TextField(
              controller: test,
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    eventsample[_focusedDay]?.add(test.text);
                    //print(eventsample);

                    ;
                  });
                },
                child: Text('add events'))*/

        