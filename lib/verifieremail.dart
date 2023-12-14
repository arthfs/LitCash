import 'package:flutter/material.dart';

import 'package:lcash/main.dart';
import 'package:lcash/theme.dart';

import 'modelpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Verifieremail extends StatefulWidget {
  Verifieremail({Key? key}) : super(key: key);

  @override
  State<Verifieremail> createState() => _VerifieremailState();
}

class _VerifieremailState extends State<Verifieremail> {
  @override
  // ignore: override_on_non_overriding_member

  Widget build(BuildContext context) {
    var a = instance.currentUser?.emailVerified;
    if (a == false) {
      print(a);
      instance.currentUser?.reload();
    }
    return MaterialApp(
      theme: currenttheme,
      home: Scaffold(
          appBar: wappBarmodel(context),
          //backgroundColor: Colors.grey,
          body:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
                padding: EdgeInsets.only(top: 50),
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: () {
                      try {
                        instance.currentUser
                            ?.sendEmailVerification()
                            .then((value) {
                          a = (instance.currentUser?.emailVerified);
                          setState(() {});
                        });
                      } on FirebaseException catch (e) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text(e.message!),
                                title: Text(e.code),
                              );
                            }).whenComplete(() {
                          instance.signOut();
                        });
                      }

                      //  setState(() {
                      //  instance.currentUser?.reload();
                      //});
                    },
                    child: Text('Envoyer un email de confirmation')))

            //,Text('$a')
          ])),
      debugShowCheckedModeBanner: false,
    );
  }
}
