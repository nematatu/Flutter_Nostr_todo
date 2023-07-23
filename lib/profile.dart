import 'package:flutter/material.dart';
import 'main.dart';

class profile extends StatefulWidget {
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  final Image ProfileImage = Image(
      image: NetworkImage(
          'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiLuW2xcJlrbLdQDiw-wTCsElgoQIvbaXRZ40pCZX9vxYuLh1W3njnzZ_SZddy3nVpXeTDZqdKX6rI-MQBECmDwL80RPHDA4d5_lBe89Z8YTbBw9LSlnkTYFbKFmLvObN6tMyyCx7kPVQiMVILHoqH-ze4DDH1n6tf6PIo06l_6w95xdmZ40m7X7Bzx9g/s664/rennai_kaeruka.png'));
  var myHomePage = MyHomePage(0);
  String profile_name = 'test_name';
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
        title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Profile'),
        ]),
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
                        height: 300,
                        margin: EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          //モーダル自体の色
                          color: Colors.white,
                          //角丸にする
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ));
                  },
                );
              },
              icon: Icon(Icons.settings))
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
              padding: EdgeInsets.all(50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: Container(
                      width: 150,
                      height: 150,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiLuW2xcJlrbLdQDiw-wTCsElgoQIvbaXRZ40pCZX9vxYuLh1W3njnzZ_SZddy3nVpXeTDZqdKX6rI-MQBECmDwL80RPHDA4d5_lBe89Z8YTbBw9LSlnkTYFbKFmLvObN6tMyyCx7kPVQiMVILHoqH-ze4DDH1n6tf6PIo06l_6w95xdmZ40m7X7Bzx9g/s664/rennai_kaeruka.png'),
                        radius: 10,
                      ),
                    ),
                    onTap: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                                height: 250,
                                margin: EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    )),
                                child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          height: 60,
                                          child: ElevatedButton(
                                              onPressed: () {},
                                              child: Text(
                                                '写真を撮る',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)))),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 60,
                                          child: ElevatedButton(
                                              onPressed: () {},
                                              child: Text('端末から選択',
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)))),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 60,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'キャンセル',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            style: TextButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                )),
                                          ),
                                        ),
                                      ],
                                    )));
                          });
                    },
                  ),
                  SizedBox(height: 30),
                  Text(profile_name,
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'following:',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'followers',
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  )
                ],
              )),
        ),
      ),
      drawer: myHomePage.drawer_func(func, func2),
    );
  }
}
