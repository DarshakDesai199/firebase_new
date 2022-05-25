import 'dart:async';

import 'package:firebase_new/View/2.SignUp.dart';
import 'package:firebase_new/View/6.Home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  var data;
  void initState() {
    getData().whenComplete(() => Timer(
        Duration(seconds: 3),
        () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => data == null ? SignUp() : Home(),
            ))));
    super.initState();
  }

  Future getData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final results = _prefs.getString("Email");
    setState(() {
      data = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Splash Screen",
              style: TextStyle(color: Colors.pink),
              textScaleFactor: 3,
            ),
          )
        ],
      ),
    );
  }
}
