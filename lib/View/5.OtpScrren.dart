import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_new/FireBaseService/constant.dart';
import 'package:firebase_new/View/4.Mobilelogin.dart';
import 'package:firebase_new/View/6.Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Otp extends StatefulWidget {
  final mobile;

  const Otp({Key? key, this.mobile}) : super(key: key);

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  String? otp;
  final _globalKey = GlobalKey<ScaffoldState>();

  Future verifyOtp() async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationCode!, smsCode: otp!);
    if (phoneAuthCredential.verificationId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Enter Valid OTP",
          style: TextStyle(color: Colors.white),
        ),
      ));
    } else {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setString("Email", otp.toString());

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    }

    /// important Line
    lFirebaseAuth.signInWithCredential(phoneAuthCredential);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _globalKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 27,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(
            height: height * 0.09,
          ),
          Text(
            "Verification Code",
            style: TextStyle(
                color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 30),
          ),
          SizedBox(
            height: height * 0.05,
          ),
          Text(
            "+91 ${widget.mobile} Send to",
            style: TextStyle(color: Colors.deepOrange, fontSize: 20),
          ),
          SizedBox(
            height: height * 0.05,
          ),
          OtpTextField(
            autoFocus: true,
            numberOfFields: 6,
            textStyle: TextStyle(color: Colors.white),
            borderColor: Color(0xFF512DA8),
            margin: EdgeInsets.only(left: 15),

            showFieldAsBox: false,
            onCodeChanged: (String code) {},
            onSubmit: (String verificationCode) {
              setState(() {
                otp = verificationCode;
              });
            }, // end onSubmit
          ),
          SizedBox(
            height: height * 0.08,
          ),
          SizedBox(
            height: height * 0.05,
            width: width * 0.14,
            child: ElevatedButton(
              onPressed: () async {
                await verifyOtp();
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.pink)),
              child: Text(
                "Confirm",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
