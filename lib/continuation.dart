import 'menu.dart';

class continuationStore {
  static final continuationStore instance = continuationStore._internal();
  continuationStore._internal();
  factory continuationStore() {
    return instance;
  }
  List<DateTime> datetime_list = [];
  List<DateTime> continuation_list = [];
  int continuation_dates_count = 0;

  var calendarclass = calendarStore();

  DateTime tommorow = DateTime.now().add(Duration(days: 1));
  void date_fuc() {
    datetime_list.add(tommorow);

    for (int i = 0; i < calendarclass.count(); i++) {
      var item = calendarclass.findByIndex(i);
      DateTime datetime_item =
          DateTime.fromMillisecondsSinceEpoch(item.datetime_milliseconds);
      var dateOnly =
          DateTime(datetime_item.year, datetime_item.month, datetime_item.day);
      datetime_list.add(dateOnly);

      datetime_list.sort((a, b) => b.compareTo(a));
    }
    ;
    print("all_datetime:" + datetime_list.toString());
  }

  void continuation() {
    for (int i = 1; i < datetime_list.length; i++) {
      DateTime prevDate = datetime_list[i];
      DateTime currentDate = datetime_list[i - 1];

      if (!prevDate.isAtSameMomentAs(currentDate)) {
        continuation_list.add(prevDate);
      }
    }

    print("continuation_list:" + continuation_list.toString());
  }

  int continuation_date() {
    clear_count();

    DateTime date_now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime yesterday = DateTime.now().add(Duration(days: -1));
    DateTime date_yesterday =
        DateTime(yesterday.year, yesterday.month, yesterday.day);
    if (continuation_list[0] == date_now ||
        continuation_list[0] == date_yesterday) {
      continuation_dates_count++;
      for (int i = 1; i < continuation_list.length; i++) {
        DateTime currentDate = continuation_list[i - 1];
        DateTime prevDate = continuation_list[i];
        final difference = currentDate.difference(prevDate).inDays;
        if (difference == 1) {
          continuation_dates_count++;
        } else {
          print(continuation_dates_count);
          return continuation_dates_count;
        }
      }
    } else {
      print("継続できていません");
      return 0;
    }
    print(continuation_dates_count.toString() + "日継続しています!!");
    return continuation_dates_count;
  }

  void clear_datetime() {
    datetime_list.clear();
  }

  void clear_continuation() {
    continuation_list.clear();
  }

  void clear_count() {
    continuation_dates_count = 0;
  }
}
