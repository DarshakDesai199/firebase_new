import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_new/Demo/3.Info.dart';
import 'package:firebase_new/FireBaseService/Firebase_auth_service.dart';
import 'package:firebase_new/FireBaseService/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final email = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var height = Get.height;
    var width = Get.width;
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(children: [
            SizedBox(
              height: height * 0.2,
            ),
            TextFormField(
              controller: email,
              validator: (value) {
                if (value!.isEmpty) {
                  return "required";
                }
              },
              decoration: buildInputDecoration().copyWith(
                hintText: "Email",
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            TextFormField(
              controller: password,
              validator: (value) {
                if (value!.isEmpty) {
                  return "required";
                }
              },
              decoration: buildInputDecoration().copyWith(hintText: "Password"),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            GestureDetector(
              onTap: () async {
                if (formKey.currentState!.validate()) {
                  bool status = await FireBaseAuth.signUp(
                      email: email.text, password: password.text);
                  if (status == true) {
                    FirebaseFirestore.instance
                        .collection("Test")
                        .doc(lFirebaseAuth.currentUser!.uid)
                        .set({"Email": email.text, "Password": password.text});

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Info(),
                        ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Failed SignUp"),
                    ));
                  }
                }
              },
              child: Container(
                height: height * 0.07,
                width: width,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            )
          ]),
        ),
      )),
    );
  }
}

InputDecoration buildInputDecoration() {
  return InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(width: 2, color: Colors.grey.shade400),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.black, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1.5),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade500, width: 1.5),
    ),
  );
}
