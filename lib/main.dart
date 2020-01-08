import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/rendering.dart';

import './pages/home_page.dart';
import './pages/authentication.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> user = {
    "name": "",
    "username": "",
    "token": "",
    "isAuthenticated": false,
    "email": "",
    "password": ""
  };

  void autoAuthenticate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    var _token = prefs.getString("token");
    if (_token != null) {
      setState(() {
        user["isAuthenticated"] = true;
        user["username"] = prefs.getString("username");
        user["token"] = prefs.getString("token");
        user["email"] = prefs.getString("email");
        user["password"] = prefs.getString("password");
        user["name"] = prefs.getString("name");
      });
    }
  }

  @override
  void initState() {
    autoAuthenticate();
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
          accentColor: Colors.black),
      routes: {
        "/": (BuildContext context) =>
            user["isAuthenticated"] ? HomePage(user) : AuthPage(user),
      },
    );
  }
}
