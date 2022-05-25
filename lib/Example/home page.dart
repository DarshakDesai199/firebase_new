import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_new/FireBaseService/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'edit page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final task = TextEditingController();
  final taskTitle = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Column(
                  children: [
                    TextField(
                      controller: taskTitle,
                      decoration: const InputDecoration(hintText: 'Title'),
                    ),
                    TextField(
                      controller: task,
                      decoration: const InputDecoration(hintText: 'Task'),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .doc(lFirebaseAuth.currentUser!.uid)
                          .collection('data')
                          .add(
                        {
                          'title': taskTitle.text,
                          'task': task.text,
                        },
                      );
                      Get.back();
                      taskTitle.clear();
                      task.clear();
                    },
                    child: const Text('Add'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      taskTitle.clear();
                      task.clear();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .doc(lFirebaseAuth.currentUser!.uid)
            .collection('data')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var info = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPage(
                            name: info.get('title'),
                            task: info.get('task'),
                            id: info.id,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Column(
                        children: [
                          Text('${info.get('title')}'),
                          Text('${info.get('task')}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
