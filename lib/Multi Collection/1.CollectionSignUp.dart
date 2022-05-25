import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_new/FireBaseService/Firebase_auth_service.dart';
import 'package:firebase_new/FireBaseService/constant.dart';
import 'package:firebase_new/FireBaseService/google_service.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Multi Collection/3.firebase_database.dart';
import '2.CollectionLogin.dart';

class FirebaseSignUp extends StatefulWidget {
  const FirebaseSignUp({Key? key}) : super(key: key);

  @override
  _FirebaseSignUpState createState() => _FirebaseSignUpState();
}

/// Firebase Storage package

class _FirebaseSignUpState extends State<FirebaseSignUp> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // firebase_storage.FirebaseStorage storage =
  //     firebase_storage.FirebaseStorage.instance;

  final picker = ImagePicker();
  File? _image;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        /// Get Image is File Form
        /// _image is also File form
        _image = File(pickedFile.path);
      });
    }
  }

  /// method of upload imageFile in Firebase Storage

  Future<String?> uploadFile({File? file, String? filename}) async {
    print("File path:$file");

    try {
      var response = await FirebaseStorage.instance
          .ref("user_image/$filename")
          .putFile(file!);

      return response.storage.ref("user_image/$filename").getDownloadURL();
    } on firebase_storage.FirebaseException catch (e) {
      print("ERROR===>>$e");
    }
    return null;
  }

  /// Collection method (set UID)
  Future addUserData() async {
    String? userImage = await uploadFile(
        file: _image, filename: "${lFirebaseAuth.currentUser!.email}");
    FirebaseFirestore.instance
        .collection('users')
        .doc(lFirebaseAuth.currentUser!.uid)
        .set({
      "email": _email.text,
      //"password": _password.text,
      "userImage": userImage,
    }).catchError((e) {
      print("ERROR==<<$e");
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.height;

    var enableBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(width: 2, color: Colors.grey));

    var focusedBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.pink, width: 2));

    var focusedErrorBorder = OutlineInputBorder(
        borderSide: BorderSide(color: Colors.deepOrangeAccent, width: 2),
        borderRadius: BorderRadius.circular(20));

    var errorBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.pink, width: 2));
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.09,
                  ),
                  Text(
                    "FireBase SignUp Screen",
                    style: TextStyle(
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: Container(
                      height: 170,
                      width: 170,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300, shape: BoxShape.circle),
                      child: ClipOval(
                        child: _image == null
                            ? Image.asset("assets/profile.png")
                            : Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _email,
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter a Email";
                      }
                    },
                    decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: enableBorder,
                        focusedBorder: focusedBorder,
                        focusedErrorBorder: focusedErrorBorder,
                        errorBorder: errorBorder),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _password,
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter a Password";
                      }
                    },
                    decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        enabledBorder: enableBorder,
                        focusedBorder: focusedBorder,
                        focusedErrorBorder: focusedErrorBorder,
                        errorBorder: errorBorder),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  SizedBox(
                    height: height * 0.05,
                    width: width * 0.14,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            bool status = await FireBaseAuth.signUp(
                                password: _password.text, email: _email.text);
                            if (status == true) {
                              await addUserData();

                              /// shared preference
                              SharedPreferences _prefs =
                                  await SharedPreferences.getInstance();
                              _prefs
                                  .setString("Email", _email.text)
                                  .whenComplete(
                                    () => ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                          content: Text(
                                            "Successfully Sign up ",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          duration: Duration(seconds: 3),
                                          backgroundColor: Colors.pink,
                                        ))
                                        .closed
                                        .then(
                                      (value) {
                                        /// collection set UID

                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FirebaseDatabase(),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Failed")));
                            }
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.pink)),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Text(
                    "or Continue with ",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Container(
                    height: height * 0.075,
                    width: width,
                    decoration: BoxDecoration(
                      color: Color(0xff367FC0),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/Facebook.svg'),
                          SizedBox(
                            width: width * 0.04,
                          ),
                          const Text(
                            'Login with Facebook',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.035,
                  ),
                  GestureDetector(
                    onTap: () async {
                      SharedPreferences _prefs =
                          await SharedPreferences.getInstance();

                      signInWithGoogle().whenComplete(() {
                        // _prefs.setString("Email", email.toString());
                        // _prefs.setString("username", name.toString());
                        // _prefs.setString('image', imageUrl.toString());
                      }).then((value) => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FirebaseDatabase(),
                          )));
                    },
                    child: Container(
                      height: height * 0.075,
                      width: width,
                      decoration: BoxDecoration(
                        color: Color(0xffDD4B39),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/google-plus-logo.svg'),
                            SizedBox(
                              width: width * 0.04,
                            ),
                            const Text(
                              'Login with Google',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.07,
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
                                builder: (context) => FirebaseLogin(),
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
        ),
      ),
    );
  }
}
