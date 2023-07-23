import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'todo.dart';

class TodoListStore {
  final String _saveKey = "Todo";
  List<TODO> _list = [];
  static final TodoListStore _instance = TodoListStore._internal();
  TodoListStore._internal();
  factory TodoListStore() {
    return _instance;
  }

  int count() {
    return _list.length;
  }

  TODO findByIndex(int index) {
    return _list[index];
  }

  void add(bool done, String title, String detail) {
    var id = count() == 0 ? 1 : _list.last.id + 1;
    var todo = TODO(id, title, detail, done);
    _list.add(todo);
    save();
  }

  void update(TODO todo, bool done, [String? title, String? detail]) {
    todo.done = done;
    if (title != null) {
      todo.title = title;
    }

    if (detail != null) {
      todo.detail = detail;
    }
    save();
  }

  void delete(TODO todo) {
    _list.remove(todo);
    save();
  }

  void save() async {
    var prefs = await SharedPreferences.getInstance();
    var saveTargetList = _list.map((a) => json.encode(a.toJson())).toList();
    prefs.setStringList(_saveKey, saveTargetList);
  }

  void load() async {
    var prefs = await SharedPreferences.getInstance();
    var loadTargetList = prefs.getStringList(_saveKey) ?? [];
    _list = loadTargetList.map((a) => TODO.fromJson(json.decode(a))).toList();
  }
}
