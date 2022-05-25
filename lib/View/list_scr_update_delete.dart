import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class List_scr extends StatefulWidget {
  const List_scr({Key? key}) : super(key: key);

  @override
  State<List_scr> createState() => _List_scrState();
}

class _List_scrState extends State<List_scr> {
  Color primaryColor = Color(0xff18203d);
  Color secondaryColor = Color(0xff232c51);

  CollectionReference ref = FirebaseFirestore.instance.collection('products');

  final _name = TextEditingController();
  final _price = TextEditingController();
  final _brand = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26,
        elevation: 0,
      ),
      backgroundColor: primaryColor,
      body: StreamBuilder<QuerySnapshot>(
        stream: ref.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var info = snapshot.data!.docs;
            return ListView.builder(
              itemCount: info.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        width: 350,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '${info[index].get('Name')}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            Text(
                              '${info[index].get('Brand')}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            Text(
                              '${info[index].get('Price')}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                "${info[index].get('ImageURL')}",
                                fit: BoxFit.cover,
                                height: 90,
                                width: 70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Column(
                                          children: [
                                            Text('Update Products'),
                                            TextFormField(
                                              controller: _name,
                                              decoration: const InputDecoration(
                                                  hintText: "Change Name"),
                                            ),
                                            TextFormField(
                                              controller: _brand,
                                              decoration: const InputDecoration(
                                                  hintText: "Change Brand"),
                                            ),
                                            TextFormField(
                                              controller: _price,
                                              decoration: const InputDecoration(
                                                  hintText: "Change Price"),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          MaterialButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            color: secondaryColor,
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          MaterialButton(
                                            onPressed: () {
                                              FirebaseFirestore.instance
                                                  .collection('products')
                                                  .doc(info[index].id)
                                                  .update({
                                                'Name': _name.text,
                                                'Brand': _brand.text,
                                                'Price': _price.text
                                              });
                                              Get.back();
                                              _name.clear();
                                              _brand.clear();
                                              _price.clear();
                                            },
                                            color: primaryColor,
                                            child: Text(
                                              'UPDATE',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                              ),
                              child: Text(
                                'UPDATE',
                                style: TextStyle(
                                    color: primaryColor, fontSize: 20),
                              )),
                          ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                          "Do you want to Delete this Products?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: const Text("NO"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection("products")
                                                .doc(info[index].id)
                                                .delete();

                                            Get.back();
                                            _name.clear();
                                            _brand.clear();
                                            _price.clear();
                                          },
                                          child: const Text("YES"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                              ),
                              child: Text(
                                'DELETE',
                                style: TextStyle(
                                    color: primaryColor, fontSize: 20),
                              )),
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          } else
            return Text('');
        },
      ),
    );
  }
}
