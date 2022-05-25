import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_new/FireBaseService/constant.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  final String name;
  final String task;
  final String id;
  const EditPage({
    Key? key,
    required this.name,
    required this.task,
    required this.id,
  }) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final task1 = TextEditingController();
  final taskTitle1 = TextEditingController();
  @override
  void initState() {
    task1.text = widget.task;
    taskTitle1.text = widget.name;
    super.initState();
  }

  Future update() async {
    FirebaseFirestore.instance
        .doc(lFirebaseAuth.currentUser!.uid)
        .collection('data')
        .doc(widget.id)
        .update(
      {'title': taskTitle1.text, 'task': task1.text},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: taskTitle1,
            decoration: const InputDecoration(
              hintText: "title",
            ),
          ),
          TextField(
            controller: task1,
          ),
          ElevatedButton(
            onPressed: () {
              update();
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.add,
            ),
          )
        ],
      ),
    );
  }
}
