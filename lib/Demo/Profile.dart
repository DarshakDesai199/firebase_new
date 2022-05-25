import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_new/FireBaseService/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final name = TextEditingController();
  final surname = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final address = TextEditingController();
  final country = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var height = Get.height;
    var width = Get.width;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Test")
            .doc(lFirebaseAuth.currentUser!.uid)
            .collection("Personal Info")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final info = snapshot.data!.docs[index];
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Center(
                        child: Container(
                          height: height * 0.165,
                          width: width * 0.35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.black),
                          child: ClipOval(
                              child: Image.network(
                            "${info.get("UserImage")}",
                            fit: BoxFit.cover,
                          )),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        height: height * 0.07,
                        width: width,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Text(
                                "Name : ",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey.shade700),
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Text(
                                "${info.get("Name")}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        height: height * 0.07,
                        width: width,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Text(
                                "Surname : ",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey.shade700),
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Text(
                                "${info.get("Surname")}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        height: height * 0.07,
                        width: width,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Text(
                                "Email : ",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey.shade700),
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Text(
                                "${info.get("Email")}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        height: height * 0.07,
                        width: width,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Text(
                                "Password : ",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey.shade700),
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Text(
                                "${info.get("Password")}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        height: height * 0.07,
                        width: width,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Text(
                                "DOB : ",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey.shade700),
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Text(
                                "${info.get("DOB")}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        height: height * 0.07,
                        width: width,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Text(
                                "Gender : ",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey.shade700),
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Text(
                                "${info.get("Gender")}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        height: height * 0.07,
                        width: width,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Text(
                                "Address : ",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey.shade700),
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Text(
                                "${info.get("Address")}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        height: height * 0.07,
                        width: width,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Text(
                                "Country : ",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey.shade700),
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Text(
                                "${info.get("country")}",
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            name.text = info.get("Name");
                            surname.text = info.get("Surname");
                            email.text = info.get("Email");
                            password.text = info.get("Password");
                            address.text = info.get("Address");
                            country.text = info.get("country");
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Column(
                                  children: [
                                    Text("Update"),
                                    TextFormField(
                                      controller: name,
                                      decoration: InputDecoration(
                                          hintText: "Enter a Name"),
                                    ),
                                    TextFormField(
                                      controller: surname,
                                      decoration: InputDecoration(
                                          hintText: "Enter a Surname"),
                                    ),
                                    TextFormField(
                                      controller: email,
                                      decoration: InputDecoration(
                                          hintText: "Enter a Email"),
                                    ),
                                    TextFormField(
                                      controller: password,
                                      decoration: InputDecoration(
                                          hintText: "Enter a password"),
                                    ),
                                    TextFormField(
                                      controller: address,
                                      decoration: InputDecoration(
                                          hintText: "Enter a Address"),
                                    ),
                                    TextFormField(
                                      controller: country,
                                      decoration: InputDecoration(
                                          hintText: "Enter a Country"),
                                    ),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancel")),
                                  ElevatedButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection("Test")
                                            .doc(lFirebaseAuth.currentUser!.uid)
                                            .collection("Personal Info")
                                            .doc(info.id)
                                            .update({
                                          "Name": name.text,
                                          "Surname": surname.text,
                                          "Email": email.text,
                                          "Password": password.text,
                                          "Address": address.text,
                                          "country": country.text
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Text("Update")),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          height: height * 0.07,
                          width: width,
                          color: Colors.black,
                          child: Center(
                            child: Text(
                              "Update",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
