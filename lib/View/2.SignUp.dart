import 'package:firebase_new/FireBaseService/Firebase_auth_service.dart';
import 'package:firebase_new/FireBaseService/google_service.dart';
import 'package:firebase_new/View/3.Login.dart';
import 'package:firebase_new/View/6.Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.height;
    var focusErrorBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.yellow, width: 2));
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Center(
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
                  "SignUp Screen",
                  style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _email,
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    RegExp regex = RegExp(
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                    if (!regex.hasMatch(value!)) {
                      return "Enter valid Email";
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
                        borderSide: BorderSide(color: Colors.pink, width: 2),
                      ),
                      focusedErrorBorder: focusErrorBorder,
                      errorBorder: OutlineInputBorder(
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
                  validator: (value) {
                    RegExp regex = RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                    if (!regex.hasMatch(value!)) {
                      return "Enter valid password";
                    }
                  },
                  decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.pink, width: 2)),
                      focusedErrorBorder: focusErrorBorder,
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.pink, width: 2),
                          borderRadius: BorderRadius.circular(20))),
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
                            /// shared preference
                            SharedPreferences _prefs =
                                await SharedPreferences.getInstance();
                            _prefs.setString("Email", _email.text).whenComplete(
                                  () => ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                        content: Text(
                                          "Successfully Sign up ",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        duration: Duration(seconds: 3),
                                        backgroundColor: Colors.pink,
                                      ))
                                      .closed
                                      .then(
                                    (value) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Home(),
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
                    }).then(
                      (value) => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(),
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
      ),
    );
  }
}
