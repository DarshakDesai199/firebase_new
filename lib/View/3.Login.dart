import 'package:firebase_new/FireBaseService/Firebase_auth_service.dart';
import 'package:firebase_new/FireBaseService/google_service.dart';
import 'package:firebase_new/Multi%20Collection/3.firebase_database.dart';
import 'package:firebase_new/View/6.Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '4.Mobilelogin.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var show = true;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.height;
    return Scaffold(
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.07,
                ),
                Text(
                  "Login Screen",
                  style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                SizedBox(
                  height: height * 0.07,
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
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(width: 2, color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Colors.pink, width: 2))),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _password,
                  style: TextStyle(color: Colors.white),
                  obscureText: show,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter a Password";
                    }
                  },
                  decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.grey),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            show = !show;
                          });
                        },
                        icon: show
                            ? Icon(
                                Icons.visibility,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.visibility_off,
                                color: Colors.white,
                              ),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(width: 2, color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Colors.pink, width: 2))),
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
                          bool status = await FireBaseAuth.logIn(
                              email: _email.text, password: _password.text);
                          if (status == true) {
                            SharedPreferences _prefs =
                                await SharedPreferences.getInstance();
                            _prefs
                                .setString("Email", _email.text)
                                .then((value) => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Home(),
                                    )));
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
                        "Log In",
                        style: TextStyle(fontSize: 20),
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
                  height: height * 0.04,
                ),
                GestureDetector(
                  onTap: () async {
                    SharedPreferences _prefs =
                        await SharedPreferences.getInstance();

                    signInWithGoogle().whenComplete(() {
                      _prefs.setString("Email", email.toString());
                      _prefs.setString("username", name.toString());
                      _prefs.setString('image', imageUrl.toString());
                    }).then(
                      (value) => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FirebaseDatabase(),
                        ),
                      ),
                    );
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
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MobileScreen(),
                        ));
                  },
                  child: Container(
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
                          Image.asset(
                            "assets/phone_Icon.png",
                            height: height * 0.05,
                          ),
                          SizedBox(
                            width: width * 0.04,
                          ),
                          const Text(
                            'Login with Phone',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don\'t have an account ? ",
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
                        "Sign Up",
                        style: TextStyle(fontSize: 18, color: Colors.pink),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
