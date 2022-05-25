import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_new/FireBaseService/constant.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'Profile.dart';

class Info extends StatefulWidget {
  const Info({Key? key}) : super(key: key);

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  int isTap = 0;
  DateTime dateTime = DateTime.now();
  String dateOfBirth = "Choose Date";
  String selectedGroup = "Male";
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final surname = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final address = TextEditingController();
  final country = TextEditingController();

  final picker = ImagePicker();
  File? _image;

  Future getImages({required fromGallery}) async {
    final pickedFile = await picker.pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> uploadsFile({File? file, String? filename}) async {
    try {
      var response = await FirebaseStorage.instance
          .ref("user_image/$filename")
          .putFile(file!);
      return response.storage.ref("user_image/$filename").getDownloadURL();
    } on firebase_storage.FirebaseException catch (e) {
      print("ERROR ==> $e");
    }
    return null;
  }

  Future adduserInfo() async {
    String? userImages = await uploadsFile(
        file: _image, filename: "${lFirebaseAuth.currentUser!.email}");

    FirebaseFirestore.instance
        .collection('Test')
        .doc(lFirebaseAuth.currentUser!.uid)
        .collection("Personal Info")
        .add({
      "Name": name.text,
      "Surname": surname.text,
      "Email": email.text,
      "Password": password.text,
      "Address": address.text,
      "country": country.text,
      "DOB": dateOfBirth,
      "Gender": selectedGroup,
      "UserImage": userImages,
    }).catchError((e) {
      print("ERROR==>$e");
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = Get.height;
    var width = Get.width;
    var style = TextStyle(fontSize: 17, fontWeight: FontWeight.w400);
    var sizedBox = SizedBox(
      height: height * 0.0035,
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "Personal Information",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            )),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Info")
              .doc(lFirebaseAuth.currentUser!.uid)
              .collection("Personal Info")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return Form(
              key: formKey,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              getImages(fromGallery: true);
                            },
                            child: Container(
                              height: height * 0.17,
                              width: width * 0.38,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.black),
                              child: ClipOval(
                                child: _image == null
                                    ? Image.asset("assets/profile.png")
                                    : Image.file(
                                        _image!,
                                        fit: BoxFit.fill,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Text(
                          "Name",
                          style: style,
                        ),
                        sizedBox,
                        TextFormField(
                          controller: name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter a Name";
                            }
                          },
                          textInputAction: TextInputAction.done,
                          decoration:
                              buildInputDecoration().copyWith(hintText: "Name"),
                        ),
                        SizedBox(height: height * 0.015),
                        Text(
                          "Surname",
                          style: style,
                        ),
                        sizedBox,
                        TextFormField(
                          controller: surname,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter a Surname";
                            }
                          },
                          textInputAction: TextInputAction.done,
                          decoration: buildInputDecoration()
                              .copyWith(hintText: "Surname"),
                        ),
                        SizedBox(height: height * 0.015),
                        Text(
                          "Email",
                          style: style,
                        ),
                        sizedBox,
                        TextFormField(
                          controller: email,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter a Email";
                            }
                          },
                          textInputAction: TextInputAction.done,
                          decoration: buildInputDecoration()
                              .copyWith(hintText: "Email"),
                        ),
                        SizedBox(height: height * 0.015),
                        Text(
                          "Password",
                          style: style,
                        ),
                        sizedBox,
                        TextFormField(
                          controller: password,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter a Password}";
                            }
                          },
                          textInputAction: TextInputAction.done,
                          decoration: buildInputDecoration()
                              .copyWith(hintText: "Password"),
                        ),
                        SizedBox(height: height * 0.015),
                        Text(
                          "Gender",
                          style: style,
                        ),
                        sizedBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: height * 0.07,
                              width: width * 0.41,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    width: 1.5,
                                    color: selectedGroup == "Male"
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade400),
                              ),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Male",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(
                                      width: width * 0.015,
                                    ),
                                    Radio(
                                      activeColor: Colors.black,
                                      value: "Male",
                                      groupValue: selectedGroup,
                                      onChanged: (String? value) {
                                        setState(() {
                                          selectedGroup = value!;
                                        });
                                      },
                                    )
                                  ]),
                            ),
                            Container(
                              height: height * 0.07,
                              width: width * 0.41,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    width: 1.5,
                                    color: selectedGroup == "Female"
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade400),
                              ),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Female",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(
                                      width: width * 0.015,
                                    ),
                                    Radio(
                                      activeColor: Colors.black,
                                      value: "Female",
                                      groupValue: selectedGroup,
                                      onChanged: (String? value) {
                                        setState(() {
                                          selectedGroup = value!;
                                        });
                                      },
                                    )
                                  ]),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.015),
                        Text(
                          "Date of Birth",
                          style: style,
                        ),
                        sizedBox,
                        Container(
                          height: height * 0.07,
                          width: width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "$dateOfBirth",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey.shade600),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    DateTime? newDate = await showDatePicker(
                                        context: context,
                                        initialDate: dateTime,
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime(2050));

                                    if (newDate != null) {
                                      setState(() {
                                        dateTime = newDate;
                                      });

                                      setState(() {
                                        dateOfBirth =
                                            "${dateTime.day}/${dateTime.month}/${dateTime.year}";
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.keyboard_arrow_down_sharp))
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.015),
                        Text(
                          "Address",
                          style: style,
                        ),
                        sizedBox,
                        TextFormField(
                          controller: address,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter a Address";
                            }
                          },
                          textInputAction: TextInputAction.done,
                          decoration: buildInputDecoration()
                              .copyWith(hintText: "Address"),
                        ),
                        SizedBox(height: height * 0.015),
                        Text(
                          "Country",
                          style: style,
                        ),
                        sizedBox,
                        TextFormField(
                          controller: country,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter a Country";
                            }
                          },
                          textInputAction: TextInputAction.done,
                          decoration: buildInputDecoration()
                              .copyWith(hintText: "Country"),
                        ),
                        SizedBox(height: height * 0.035),
                        GestureDetector(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              await adduserInfo()
                                  .whenComplete(() {})
                                  .then((value) => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Profile(),
                                      )));
                              // else {
                              //   Get.snackbar("", "Failed",
                              //       snackPosition: SnackPosition.BOTTOM,
                              //       backgroundColor: Colors.black);
                              // }

                              // box.write("Image", _image);
                            }
                          },
                          child: Container(
                            height: height * 0.072,
                            width: width,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.035),
                      ]),
                ),
              ),
            );
          },
        ),
      ),
    );
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
}
