import 'dart:convert';

import 'package:bili_app/db/hi_cache.dart';
import 'package:bili_app/http/core/hi_error.dart';
import 'package:bili_app/http/request/notice_request.dart';
import 'package:bili_app/model/owner.dart';
import 'package:flutter/material.dart';

import 'http/core/hi_net.dart';
import 'http/dao/login_dao.dart';
import 'http/request/test_request.dart';

void main() {
  runApp(MyApp());
}

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
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

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
  int _counter = 0;
  @override
  void initState() {
    super.initState();
    HiCache.preInit();
  }

  void _incrementCounter() async {
    // test0();
    // test();
    // test1();
    // test2();
    // testLogin();
    testNotice();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void test0() async {
    // LoginRequest request = LoginRequest();
    TestRequest request = TestRequest();
    request.add("add", "dddd").add("bb", "bbbb").add("requestPrams", "kkkk");
    try {
      var result = await HiNet.getInstance().fire(request);
      print(result);
    } on NeedAuth catch (e) {
      print(e);
    } on NeedLogin catch (e) {
      print(e);
    } on HiNetError catch (e) {
      print(e);
    }
  }

  void test() {
    const jsonString =
        "{ \"name\": \"flutter\", \"url\": \"https://coding.imooc.com/class/487.html\" }";
    //json 转 map
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    print('name' + jsonMap['name']);

    //map 转 json
    String json = jsonEncode(jsonMap);
    print('json:$json');
  }

  void test1() {
    var ownerMap = {
      "name": "伊零Onezero",
      "face":
          "http://i2.hdslb.com/bfs/face/1c57a17a7b077ccd19dba58a981a673799b85aef.jpg",
      "fans": 0
    };
    Owner owner = Owner.fromJson(ownerMap);
    print('name:${owner.name}');
  }

  void test2() {
    HiCache.getInstance().setString("aa", "12222");
    var value = HiCache.getInstance().get("aa");
    print("value:$value");
  }

  void testLogin() async {
    try {
      // var result =
      //     await LoginDao.registration('disk', "abc", "101191818", "2219");
      var result = await LoginDao.login('boshi', '123');
      print(result);
    } on NeedAuth catch (e) {
      print(e);
    } on HiNetError catch (e) {
      print(e);
    }
  }

  void testNotice() async {
    try {
      var notice = await HiNet.getInstance().fire(NoticeRequest());
      print(notice);
    } on NeedLogin catch (e) {
      print(e);
    } on NeedAuth catch (e) {
      print(e);
    } on HiNetError catch (e) {
      print(e.message);
    }
  }
}
