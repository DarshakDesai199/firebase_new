import 'package:flutter/material.dart';

import '../FireBaseService/constant.dart';
import '3.Login.dart';
import '5.OtpScrren.dart';

String? verificationCode;

class MobileScreen extends StatefulWidget {
  const MobileScreen({Key? key}) : super(key: key);

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  final _mobile = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future sendOtp() async {
    await lFirebaseAuth.verifyPhoneNumber(
      phoneNumber: "+91" + _mobile.text,
      verificationCompleted: (phoneAuthCredential) {
        print("Verification Complete");
      },
      verificationFailed: (error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$error")));
      },
      codeSent: (verificationId, forceResendingToken) {
        setState(() {
          verificationCode = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.09,
              ),
              Center(
                child: Text(
                  "Enter Mobile Number",
                  style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              ),
              SizedBox(
                height: height * 0.1,
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: _mobile,
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter a Mobile No.";
                  }
                },
                decoration: InputDecoration(
                    hintText: "Mobile Number",
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(width: 2, color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.pink, width: 2)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.red, width: 2))),
              ),
              SizedBox(
                height: height * 0.06,
              ),
              SizedBox(
                height: height * 0.05,
                width: width * 0.14,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await sendOtp().then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Otp(
                              mobile: _mobile.text,
                            ),
                          )));
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.pink)),
                  child: Text(
                    "OTP",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already Have an Account? ",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ));
                    },
                    child: Text(
                      "Log in",
                      style: TextStyle(fontSize: 18, color: Colors.pink),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
