import 'package:flutter/material.dart';
import 'main.dart';
import 'package:ui_design/todo_list.dart';
import 'package:ui_design/todo_management/todo_list_store.dart';
import 'todo_management/todo.dart';
import 'profile.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:nostr/nostr.dart';

class timeline extends StatefulWidget {
  State<timeline> createState() => _timelineState();
}

class _timelineState extends State<timeline> {
  var myHomePage = MyHomePage(0);
  final myChannel = WebSocketChannel.connect(Uri.parse('wss://r.kojira.io'));
  List<Map<String, dynamic>> myMessages = [];
  List<Map<String, dynamic>> _list = [];
  List<Map<String, dynamic>> img_list = [];
  List<Map<String, dynamic>> test = [];
  List<String> test2 = [];

  final channel = WebSocketChannel.connect(Uri.parse('wss://r.kojira.io'));
  final imgChannel = WebSocketChannel.connect(Uri.parse('wss://r.kojira.io'));
  void initState() {
    Request requestWithFilter = Request(generate64RandomHexChars(), [
      Filter(
        kinds: [1],
        limit: 50,
      )
    ]); // ①
    channel.sink.add(requestWithFilter.serialize()); // ②
    channel.stream.listen((payload) {
      try {
        final _msg = Message.deserialize(payload);
        if (_msg.type == 'EVENT') {
          setState(() {
            _list.add({
              "createdAt": _msg.message.createdAt,
              "content": _msg.message.content,
            });
            img_list.add({
              "pubKey": _msg.message.pubkey,
              "createdAt": _msg.message.createdAt,
            });
            test2.add(_msg.message.pubkey);
            //print(test2);

            _list.sort((a, b) {
              return b['createdAt'].compareTo(a['createdAt']);
            });
            img_list.sort((a, b) {
              return b['createdAt'].compareTo(a['createdAt']);
            });
          });
          //print(img_list);
        }
      } catch (e) {}
    });

    const privKey =
        'cad36caa1b5d5e80e835c21bf6f413b945a7599ea2c59b039dd9a82efb7eb746';
    final Keys = Keychain(privKey);
    Request myRequestWithFilter = Request(generate64RandomHexChars(), [
      Filter(
        kinds: [1],
        limit: 50,
        authors: [Keys.public],
      )
    ]);
    myChannel.sink.add(myRequestWithFilter.serialize());
    myChannel.stream.listen((payload) {
      try {
        final _msg = Message.deserialize(payload);
        if (_msg.type == 'EVENT') {
          setState(() {
            myMessages.add({
              "createdAt": _msg.message.createdAt,
              "content": _msg.message.content,
            });
            myMessages.sort((a, b) {
              return b['createdAt'].compareTo(a['createdAt']);
            });
          });
        }
      } catch (e) {}
    });
    super.initState();
  }

  Widget messageWidget(List<Map<String, dynamic>> messages, index) {
    return SingleChildScrollView(
        child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black38, width: 1),
              ),
            ),
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /*Container(
                width: 70,
                height: 70,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image(
                      image: NetworkImage(test[index]["picture"]),
                    ))),*/
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('にょーん',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        Text(messages[index]["content"],
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ],
            )));
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

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              title: Text("SNS"),
              bottom: TabBar(tabs: [
                Tab(icon: Icon(Icons.person)),
                Tab(icon: Icon(Icons.search)),
              ])),
          body: TabBarView(
            children: [
              Center(
                  child: ListView.builder(
                      itemCount: myMessages.length,
                      itemBuilder: (context, index) {
                        return messageWidget(myMessages, index);
                      })),
              Center(
                child: ListView.builder(
                    itemCount: _list.length,
                    itemBuilder: (context, index) {
                      return messageWidget(_list, index);
                    }),
              ),
            ],
          ),
        ));
  }
}
