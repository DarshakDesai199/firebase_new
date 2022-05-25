import 'dart:async';

import 'package:firebase_new/Demo/3.Info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 3),
      () => Get.to(Info()),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Text(
        "Splash Screen",
        style: TextStyle(color: Colors.white, fontSize: 35, wordSpacing: 4.0),
      )),
    );
  }
}
