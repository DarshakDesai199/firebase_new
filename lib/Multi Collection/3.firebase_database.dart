import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_new/FireBaseService/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FirebaseDatabase extends StatefulWidget {
  const FirebaseDatabase({Key? key}) : super(key: key);

  @override
  State<FirebaseDatabase> createState() => _FirebaseDatabaseState();
}

class _FirebaseDatabaseState extends State<FirebaseDatabase> {
  final noteTitle = TextEditingController();
  final noteContent = TextEditingController();
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
                      Text("ADD NOTES"),
                      TextFormField(
                        controller: noteTitle,
                        decoration:
                            InputDecoration(hintText: "Enter Note Title"),
                      ),
                      TextFormField(
                        controller: noteContent,
                        decoration:
                            InputDecoration(hintText: "Enter Note Content"),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        FirebaseFirestore.instance

                            /// for UID set
                            .collection('users')
                            .doc("${lFirebaseAuth.currentUser!.uid}")
                            .collection("notes")
                            .add({
                          "noteTitle": noteTitle.text,
                          "noteContent": noteContent.text
                        });

                        noteTitle.clear();
                        noteContent.clear();
                        Navigator.pop(context);
                      },
                      child: Text("Add"),
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(Icons.add),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc("${lFirebaseAuth.currentUser!.uid}")
              .collection("notes")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              var notes = snapshot.data!.docs;
              return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("${notes[index].get("noteContent")}"),
                    subtitle: Text("${notes[index].get("noteTitle")}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// update Notes.
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Column(
                                    children: [
                                      Text("UPDATE NOTES"),
                                      TextFormField(
                                        controller: noteTitle,
                                        decoration: InputDecoration(
                                            hintText: "Enter Note Title"),
                                      ),
                                      TextFormField(
                                        controller: noteContent,
                                        decoration: InputDecoration(
                                            hintText: "Enter Note Content"),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(
                                                "${lFirebaseAuth.currentUser!.uid}")
                                            .collection("notes")
                                            .doc(notes[index].id)
                                            .update({
                                          "noteTitle": noteTitle.text,
                                          "noteContent": noteContent.text
                                        });

                                        noteTitle.clear();
                                        noteContent.clear();
                                        Navigator.pop(context);
                                      },
                                      child: Text("Add"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.edit),
                        ),

                        /// Delete Notes.
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title:
                                      Text("Do you want to delete this note?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("NO"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(
                                                "${lFirebaseAuth.currentUser!.uid}")
                                            .collection("notes")
                                            .doc(notes[index].id)
                                            .delete();

                                        Navigator.pop(context);
                                      },
                                      child: Text("YES"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              final loading = SpinKitRipple(
                //  duration: Duration(seconds: 3),
                color: Colors.red,
                size: 50,
              );
              return loading;
            }
          },
        ));
  }
}
