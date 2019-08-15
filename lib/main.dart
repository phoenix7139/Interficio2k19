import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';

import './pages/home_page.dart';

void main() {
  //debugPaintSizeEnabled = true;
  //debugPaintBaselinesEnabled = true;
  //debugPaintPointersEnabled = true;
  runApp(MyApp());
}class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //debugShowMaterialGrid: true,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.red,
        accentColor: Colors.black
      ),
      routes: {
        "/": (BuildContext context) => HomePage(),
      },
    );
  }
}