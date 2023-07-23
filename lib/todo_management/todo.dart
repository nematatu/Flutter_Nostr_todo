class TODO {
  late int id;
  late String title;
  late String detail;
  late bool done;

  TODO(
    this.id,
    this.title,
    this.detail,
    this.done,
  );

  Map toJson() {
    return {
      'id': id,
      'title': title,
      'detail': detail,
      'done': done,
    };
  }

  TODO.fromJson(Map json) {
    id = json['id'];
    title = json['title'];
    detail = json['detail'];
    done = json['done'];
  }
}
