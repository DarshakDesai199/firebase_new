import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'list_scr_update_delete.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({Key? key}) : super(key: key);

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  Color primaryColor = Color(0xff18203d);
  Color secondaryColor = Color(0xff232c51);

  TextEditingController nameController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  late Map<String, dynamic> productToAdd;

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('products');

  /// Gallery photo select

  File? _image;
  final picker = ImagePicker();
  Future pickedImage() async {
    final imagePicked = await picker.pickImage(source: ImageSource.gallery);

    if (imagePicked != null) {
      setState(() {
        _image = File(imagePicked.path);
      });
    }
  }

  /// Upload File

  Future<String?> uploadFile({File? file, String? filename}) async {
    print("File Path ==> $file");
    try {
      var response = await FirebaseStorage.instance
          .ref('filename ==>$filename')
          .putFile(file!);

      return response.storage.ref('filename ==>$filename').getDownloadURL();
    } on firebase_storage.FirebaseException catch (e) {
      print(e);
    }
  }

  /// firebase ma userdata add karavva
  addProducts() async {
    String? imageData =
        await uploadFile(file: _image, filename: '${Random().nextInt(1000)}');

    productToAdd = {
      'Name': nameController.text,
      "Brand": brandController.text,
      "Price": priceController.text,
      "ImageURL": imageData,
    };

    collectionReference.add(productToAdd).whenComplete(
          () => print('Add Products to Cart'),
        );
  }

  _buildTextField(TextEditingController controller, String labelText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: secondaryColor, border: Border.all(color: Colors.blue)),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.white),
            border: InputBorder.none),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.arrow_back_ios_sharp,
          color: Colors.white,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(List_scr());
            },
            child: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          )
        ],
        backgroundColor: Colors.black26,
        elevation: 0,
      ),
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Text(
                'Mobile Added',
                style: TextStyle(fontSize: 30, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    pickedImage();
                  });
                },
                child: Container(
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      border: Border.all(color: Colors.black26, width: 3),
                      borderRadius: BorderRadius.circular(20)),
                  child: _image == null
                      ? const Icon(Icons.person)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            _image!,
                            fit: BoxFit.fill,
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              _buildTextField(nameController, 'Name'),
              SizedBox(
                height: 20,
              ),
              _buildTextField(brandController, 'Brand'),
              SizedBox(
                height: 20,
              ),
              _buildTextField(priceController, 'Price'),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () {
                  addProducts();
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    'Add Products to Cart',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (Set states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.5);
                      }
                      return null; // Use the component's default.
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
