
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class DisplayScreen extends StatefulWidget {
  const DisplayScreen({Key? key}) : super(key: key);

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Result"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("students").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//show data from firebase
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((document) {
              return Card(
                elevation: 10,
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: FittedBox(child: Text(document["score"])),
                  ),
                  title: Text(document["fname"]+" "+document["lname"]),
                  subtitle: Text(document["email"]),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
