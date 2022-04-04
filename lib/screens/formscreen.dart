import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/model/student.dart';
import 'package:form_field_validator/form_field_validator.dart';

class FromScreen extends StatefulWidget {
  const FromScreen({Key? key}) : super(key: key);

  @override
  State<FromScreen> createState() => _FromScreenState();
}

class _FromScreenState extends State<FromScreen> {
//formkey for getting value
  final formKey = GlobalKey<FormState>();
  Student myStudent = Student();

  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  //init firebase
  final CollectionReference _studentCollection =
      FirebaseFirestore.instance.collection("students");
  //Firebase is noSql, tabel is called collection, making  collection

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(title: Text("Error")),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            debugPrint("Sucess lol");
            return Scaffold(
              appBar: AppBar(
                title: const Text("Record score form"),
              ),
              body: Container(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text(
                          "Name",
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          validator: RequiredValidator(errorText: "put name"),
                          onSaved: (fname) {
                            myStudent.fname = fname!;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Surname",
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          validator: RequiredValidator(errorText: "put Lname"),
                          onSaved: (lname) {
                            myStudent.lname = lname!;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "E-mail",
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          validator: MultiValidator([
                            EmailValidator(errorText: "wroung-format"),
                            RequiredValidator(errorText: "put email")
                          ]),
                          onSaved: (email) {
                            myStudent.email = email!;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Score",
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          validator: RequiredValidator(errorText: "put score"),
                          onSaved: (score) {
                            myStudent.score = score!;
                          },
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  debugPrint(
                                      "${myStudent.fname}${myStudent.lname}${myStudent.email}${myStudent.score}");
                                  await _studentCollection.add({
                                    //json obj
                                    "fname": myStudent.fname,
                                    "lname": myStudent.lname,
                                    "email": myStudent.email,
                                    "score": myStudent.score,
                                  });
                                  formKey.currentState!.reset();
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          const AlertDialog(
                                            content: Text("Done"),
                                          ));
                                }
                              },
                              child: const Text(
                                "Save",
                                style: TextStyle(fontSize: 20),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
