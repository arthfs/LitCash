import 'package:flutter/material.dart';
import 'package:lcash/main.dart';
import 'package:lcash/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lcash/modelpage.dart';

class Problems extends StatefulWidget {
  Problems({Key? key}) : super(key: key);

  @override
  State<Problems> createState() => _ProblemsState();
}

class _ProblemsState extends State<Problems> {
  final _formkey = GlobalKey<FormState>();

  final _messagecontroller = TextEditingController();
  @override
  void dispose() {
    _messagecontroller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        theme: currenttheme,
        home: Scaffold(
            appBar: wappBarmodel(context),
            body: Container(
                alignment: Alignment.center,
                child: Column(children: [
                  Text(
                    "Reporter un problème \n\n",
                    style: titlefonts,
                  ),
                  Container(
                      width: 200,
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.0)),
                      child: TextField(
                        maxLength: 500,
                        maxLines: 5,
                        controller: _messagecontroller,
                      )),
                  ElevatedButton(
                      onPressed: () async {
                        if (_messagecontroller.text.length >= 5)
                          try {
                            await probs.add({
                              'email': instance.currentUser?.email,
                              'error': _messagecontroller.text
                            }).whenComplete(() {
                              _messagecontroller.clear();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: Text('Succès'),
                                        content: Text(
                                            'Merci de nous avoir fait remarquer ce problème.'));
                                  });
                            });
                          } on FirebaseException catch (e) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: Text("Une erreur s'est produite."),
                                      content: Text(e.message!));
                                });
                          }
                      },
                      child: Text('Soumetre'))
                ]))),
        debugShowCheckedModeBanner: false);
  }
}
