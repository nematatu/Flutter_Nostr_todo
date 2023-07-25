import 'package:flutter/material.dart';
import 'main.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:math';

class profile extends StatefulWidget {
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  Future<File> urlToFile(String imageUrl) async {
    final String tempPath = (await getTemporaryDirectory()).path;
    final File file = File('$tempPath${Random().nextInt(100)}.png');
    http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  String imageUrl =
      'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh2a-tFaH8VM7HJuWjoSXSLaU-09yX_M2mkEVvwuKPn8nD7Dx5iv-Tai59PwCVdubS3V3lrarzJifdd_jOIuwAICE7aDYo1MxGc6MmJIp9xSpcbC11w12avBA6nCBm6DdGtR7Gn3fz94rTUkhWgdlHlzp8xZMgU1Z8EIb5vhb9qRMWOFOyEKSb9rQs7yGgq/s992/bluebird_fired.png';
  final Image ProfileImage = Image(
      width: 2000,
      height: 2000,
      image: NetworkImage(
          'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh2a-tFaH8VM7HJuWjoSXSLaU-09yX_M2mkEVvwuKPn8nD7Dx5iv-Tai59PwCVdubS3V3lrarzJifdd_jOIuwAICE7aDYo1MxGc6MmJIp9xSpcbC11w12avBA6nCBm6DdGtR7Gn3fz94rTUkhWgdlHlzp8xZMgU1Z8EIb5vhb9qRMWOFOyEKSb9rQs7yGgq/s992/bluebird_fired.png'));

  File? image;
  final picker = ImagePicker();
  Future getImage() async {
    final XFile? _image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (_image != null) {
        image = File(_image.path);
      } else {
        print('No Image Selected.');
      }
    });
  }

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
                        width: 200,
                        height: 200,
                        child: /*CircleAvatar(
                        child: ClipOval(
                          child: image == Null
                              ? Text('No Image Selected.')
                              : Image.file(image!),
                        ),
                        radius: 25,
                      ),*/
                            image == null
                                ? Text('画像がありません')
                                : CircleAvatar(
                                    child: ClipOval(
                                        child: Container(
                                            width: 200,
                                            height: 200,
                                            child: Image.file(image!,
                                                fit: BoxFit.cover))),
                                    backgroundColor: Colors.blue,
                                    radius: 25)),
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
                                              onPressed: () {
                                                getImage();
                                              },
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
