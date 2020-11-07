import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import 'hskPhotoPickerTool.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

///http://apiwl3.atjubo.com/uppic.ashx

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List mFileList = List();
  List<MultipartFile> mSubmitFileList = List();
  int type = 2;

  void _uploadImage() async {
    if (mFileList.length == 0) {
      Fluttertoast.showToast(msg: '请选择图片', gravity: ToastGravity.CENTER);
      return;
    }
    //上传多张图片
    for (int i = 0; i < mFileList.length; i++) {
      mSubmitFileList
          .add(MultipartFile.fromFileSync(mFileList.elementAt(i).path));
    }

    //上传单张图片 类型需要转换 MultipartFile.fromFileSync(slectFile.path)
    //File slectFile = File(mFileList[0].path);

    print(mFileList);
    FormData formData = FormData.fromMap({"imgFile": mSubmitFileList});

    Dio dio = new Dio();
    var respone = await dio.post<String>("http://apiwl3.atjubo.com/uppic.ashx",
        data: formData);

    print(respone);
    Fluttertoast.showToast(msg: '上传成功', gravity: ToastGravity.CENTER);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(80, 10, 30, 10),
                color: Colors.grey,
                child: HskPhotoPickerTool(
                  lfPaddingSpace: 110,
                  type: type,
                  callBack: (var img, var file) {
                    mFileList = file;
                  },
                )),
            RaisedButton(
                child: Text(
                  '上传照片',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                onPressed: () {
                  _uploadImage();
                }),
            Row(
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    type == 1;
                  },
                  child: Text('单张'),
                ),
                RaisedButton(
                  onPressed: () {
                    type == 2;
                  },
                  child: Text('多张'),
                ),
              ],
            )
          ],
        ));
  }
}
