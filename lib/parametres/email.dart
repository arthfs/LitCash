import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lcash/main.dart';
import 'package:lcash/theme.dart';
import 'package:lcash/modelpage.dart';
import 'package:firebase_auth/firebase_auth.dart';


final fontbuttons = GoogleFonts.aclonica(color: Colors.black);

String tempemail = '';
String? email = instance.currentUser!.email;

class Email extends StatefulWidget {
  Email({Key? key}) : super(key: key);

  @override
  _EmailState createState() => _EmailState();
}

class _EmailState extends State<Email> {
  String p = 'not found', blockeduser = 'not found';
  final _formkey = GlobalKey<FormState>();
  final _emailcontroller = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void dispose() {
    _emailcontroller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: currenttheme,
      home: Scaffold(
        appBar: wappBarmodel(context),
        //backgroundColor: Colors.grey,
        body: Column(
          children: [
            Text(
              "Email \n\n",
              style: titlefonts,
            ),
            Form(
              key: _formkey,
              child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      //alignment: Alignment.centerLeft,
                      height: 50,
                      /* decoration: BoxDecoration(
                          border:
                              Border.all(width: 3, style: BorderStyle.solid)),
                              */
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Email : ',
                              style: buttonsfonts,
                            ),
                            Text(
                              "${email}",
                              style: fontbuttons,
                              textAlign: TextAlign.start,
                            )
                          ]),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      alignment: Alignment.center,
                      width: 500,
                      child: TextFormField(
                        controller: _emailcontroller,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textDirection: TextDirection.ltr,
                        onChanged: (x) {
                          tempemail = x.trimLeft().trimRight();
                        },
                        onEditingComplete: () {
                          verify(firestoreInstance,
                                  tempemail.trimLeft().trimRight(), 'email')
                              .then((value3) {
                            setState(() {
                              p = value3 == null ? 'not found' : value3;
                              print(p);
                            });

                            print(p);
                          });
                        },
                        validator: (x) {
                          verify(firestoreInstance,
                                  tempemail.trimLeft().trimRight(), 'email')
                              .then((value3) {
                            setState(() {
                              ;
                              p = value3 == null ? 'not found' : value3;
                              print(p);
                            });

                            print(p);
                          });
                          if (x!.length < 8) return "Entrer un email valide";
                          if (tempemail.compareTo(
                                  instance.currentUser?.email as String) ==
                              0) return 'N entrez pas votre email';
                          if (p.length > 9) return 'cet email est deja pris';
                          return null;
                        },
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            /*
                            setState(() {
                              try {
                                //instance.currentUser!
                                //  .sendEmailVerification()
                                //.then((value) {
                                instance.currentUser!
                                    .verifyBeforeUpdateEmail(tempemail)
                                    .then((value) {
                                  setState(() {
                                    firestoreInstance
                                        .doc(instance.currentUser?.photoURL)
                                        .update({'email': tempemail});
                                    instance.currentUser!.reload();
                                  });
                                  //instance.currentUser!
                                  //   .updateEmail(tempemail),
                                  // email = tempemail
                                });
                                // });

                              } catch (e) {
                                print(e);
                              }
                              //Navigator.of(context).push(MaterialPageRoute(
                              //  builder: (context) => Confirmemail()));
                            });
*/
                            var result =
                                updateuserinfofirebase('email', tempemail);
                            if (result != 1) _emailcontroller.clear();
                            instance.currentUser?.reload();
                            email = instance.currentUser!.email;

                            setState(() {});
                          }
                        },
                        child: Text('Enregistrer')),
                    /*   TextButton(
                        onPressed: () async {
                          await verify(
                                  firestoreInstance,
                                  _emailcontroller.text.trimLeft().trimRight(),
                                  'email')
                              .then((value3) {
                            blockeduser = value3 == null ? 'not found' : value3;
                            print(blockeduser);
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Text(
                                        '\n$tentatives\n${_emailcontroller.text.trimLeft().trimRight()}\n$value3'),
                                    title: Text('error'),
                                  );
                                });
                          }).whenComplete(() {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Text(
                                        '\n$tentatives\n${_emailcontroller.text.trimLeft().trimRight()}\n$blockeduser'),
                                    title: Text('error'),
                                  );
                                });
                          });
                        },
                        child: Text('test')) */
                  ]),
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
