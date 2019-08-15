import 'package:flutter/material.dart';

import 'dart:math';

import 'package:animator/animator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Text("drawer"),
      ),
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.black,
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/home.jpg'),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //Drawer(),
            Animator(
              duration: Duration(milliseconds: 150),
              //cycles: 0,
              repeats: 0,
              builder: (Animation anim) => Opacity(
                    opacity: anim.value,
                    child: Text(
                      "INTERFICIO",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 61,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
            ),
            _loginButton(),
            _registerButton(),
          ],
        ),
      ),
    );
  }
}

Widget _loginButton() {
  return FlatButton(
    child: Text("LOGIN"),
    color: Colors.red,
    shape: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(20),
    ),
    onPressed: () {},
  );
}

Widget _registerButton() {
  return FlatButton(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Text("REGISTER"),
    color: Colors.red,
    shape: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(20),
    ),
    onPressed: () {},
  );
}
