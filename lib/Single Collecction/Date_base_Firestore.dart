import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Database extends StatefulWidget {
  const Database({Key? key}) : super(key: key);

  @override
  State<Database> createState() => _DatabaseState();
}

///  Cloud Firestore package.

class _DatabaseState extends State<Database> {
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
                            .collection("SingleCollection")
                            .add(
                          {
                            "noteTitle": noteTitle.text,
                            "noteContent": noteContent.text
                          },
                        );

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
              .collection("SingleCollection")
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
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                            hintText: "Enter Note Title"),
                                      ),
                                      TextFormField(
                                        controller: noteContent,
                                        textInputAction: TextInputAction.next,
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
                                            .collection("SingleCollection")
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
                                            .collection("SingleCollection")
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
              return Center(child: Text("Loading....."));
            }
          },
        ));
  }
}
