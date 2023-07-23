import 'package:flutter/material.dart';
import 'dart:io';
import 'main.dart';
import 'package:ui_design/record.dart';
import 'package:ui_design/todo_management/todo_list_store.dart';
import 'todo_management/todo.dart';
import 'profile.dart';
import 'package:image_picker/image_picker.dart';

class timeline extends StatefulWidget {
  State<timeline> createState() => _timelineState();
}

class _timelineState extends State<timeline> {
  var myHomePage = MyHomePage(0);
  File? image;
  final picker = ImagePicker();
  Future getImage() async {
    final XFile? _image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (_image != null) {
        image = File(_image.path);
      }
    });
  }

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
        backgroundColor: Colors.green[100],
        appBar: AppBar(
          title: Text("timeline"),
        ),
        drawer: myHomePage.drawer_func(func, func2),
        floatingActionButton: FloatingActionButton(
          onPressed: getImage,
          child: Icon(
            Icons.photo,
          ),
        ),
        body: Center(
            child: image == null
                ? Text('画像がありません')
                : Image.file(image!, fit: BoxFit.cover)));
  }
}
