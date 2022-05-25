import 'package:firebase_new/FireBaseService/Firebase_auth_service.dart';
import 'package:firebase_new/FireBaseService/google_service.dart';
import 'package:firebase_new/View/2.SignUp.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? userEmail;
  String? userName;
  String? image;

  Future getUserEmail() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final results = _prefs.getString("Email");
    setState(() {
      userEmail = results;
    });
  }

  Future getUserName() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final results = _prefs.getString("username");
    setState(() {
      userName = results;
    });
  }

  Future getUserImage() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final results = _prefs.getString("image");
    setState(() {
      image = results;
    });
  }

  @override
  void initState() {
    getUserEmail();
    getUserName();
    getUserImage();
    super.initState();
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
              "Home Screen",
              style: TextStyle(color: Colors.pink),
              textScaleFactor: 3,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                FireBaseAuth.getUserInfo();
              },
              child: Text("Info")),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                SharedPreferences _prefs =
                    await SharedPreferences.getInstance();
                _prefs.remove("Email");

                FireBaseAuth.logOut()
                    .whenComplete(() => _prefs.remove("Email"))
                    .then((value) => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUp(),
                        )));
              },
              child: Text("Logout")),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                SharedPreferences _prefs =
                    await SharedPreferences.getInstance();
                _prefs.remove("Email").then(
                      (value) => signOutGoogle().then(
                        (value) => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUp(),
                          ),
                        ),
                      ),
                    );
              },
              child: Text("LogOut With Google")),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Username : $userName",
                  style: TextStyle(fontSize: 20, color: Colors.red),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Email : $userEmail",
                  style: TextStyle(fontSize: 20, color: Colors.red),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                    child: Image.network(
                  "$image",
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
