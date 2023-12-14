import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:lcash/main.dart';
import 'package:lcash/modelpage.dart';
import 'theme.dart';
import 'inscrire.dart';
//import 'inscriree.dart';

final noq = FirebaseFirestore.instance.collection('blockedusers');
String tempemail = '', email = '';

class Connect extends StatefulWidget {
  const Connect({Key? key}) : super(key: key);

  @override
  _ConnectState createState() => _ConnectState();
}

class _ConnectState extends State<Connect> {
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  String result = '', result2 = '', blockeduser = 'not found';
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    return MaterialApp(
      theme: currenttheme,
      home: Scaffold(
          appBar: AppBar(
              title: Text(
                'Litcash',
                style: GoogleFonts.pacifico(
                  color: currenttheme.primaryColor,
                  fontSize: 28,
                ),
              ),
              primary: true,
              backgroundColor: Colors.white),
          //backgroundColor: Colors.grey,
          body: Column(children: [
            Text(
              "Connection \n\n",
              style: titlefonts,
            ),
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Container(
                      alignment: Alignment.center,
                      child: Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              Center(
                                  child: Container(
                                      alignment: Alignment.center,
                                      //   decoration: BoxDecoration(border: Border.all()),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                                width: 300,
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Email',
                                                    // labelStyle:
                                                    //    GoogleFonts.pacifico(
                                                    //      fontSize: 16.0)),
                                                  ),
                                                  controller: _emailcontroller,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  textDirection:
                                                      TextDirection.ltr,
                                                  onChanged: (x) {
                                                    result = '';
                                                    result2 = '';
                                                    tempemail = x
                                                        .trimLeft()
                                                        .trimRight();
                                                  },
                                                  onTap: () {
                                                    result = '';
                                                    result2 = '';
                                                  },
                                                  validator: (x) {
                                                    /*  verify(
                                                            firestoreInstance,
                                                            '+5098187359',
                                                            'phone')
                                                        .then((value3) {
                                                      setState(() {
                                                        blockeduser =
                                                            value3 == null
                                                                ? 'not found'
                                                                : value3;
                                                        print(blockeduser);
                                                      });
                                                    }); */
                                                    if (x!.isEmpty)
                                                      return 'entrer votre email';
                                                    if (result.compareTo(
                                                            'invalid-email') ==
                                                        0)
                                                      return 'email incorrect';

                                                    if (result.compareTo(
                                                            'user-disabled') ==
                                                        0)
                                                      return 'Compte desactive';

                                                    if (result.compareTo(
                                                            'user-not-found') ==
                                                        0)
                                                      return 'Cet email ne correspond  a aucun compte';
                                                    return null;
                                                  },
                                                )),
                                            Container(
                                                width: 300,
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                      labelText: 'Password',
                                                      border:
                                                          OutlineInputBorder()),
                                                  obscureText: true,
                                                  obscuringCharacter: '*',
                                                  controller:
                                                      _passwordcontroller,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  textDirection:
                                                      TextDirection.ltr,
                                                  onChanged: (x) {
                                                    tempassword = x
                                                        .trimLeft()
                                                        .trimRight();
                                                    result = '';
                                                  },
                                                  onTap: () {
                                                    result = '';
                                                  },
                                                  validator: (x) {
                                                    if (x!.isEmpty)
                                                      return "Entrer votre password";
                                                    if (result.compareTo(
                                                            'wrong-password') ==
                                                        0) {
                                                      // tentatives -= 1;
                                                      return 'mot de passe incorrect';
                                                    }
                                                    return null;

                                                    //else if (validateStructure(x) == false)
                                                    //return 'Votre password est trop faible';
                                                  },
                                                )),
                                          ]))),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  ElevatedButton(
                                      onPressed: () async {
                                        //  blockedusers.doc(instance.currentUser?.uid);
                                        if (_formkey.currentState!.validate())
                                          try {
                                            await auth
                                                .signInWithEmailAndPassword(
                                                    email: tempemail
                                                        .trimLeft()
                                                        .trimRight(),
                                                    password: tempassword
                                                        .trimLeft()
                                                        .trimRight())
                                                .then((value) {
                                              _emailcontroller.clear();
                                              _passwordcontroller.clear();

//                                              MyApp();
                                            });
                                          } on FirebaseAuthException catch (error) {
                                            print('###${error.code}');
                                            String blockeduser = '';
                                            if (error.code.compareTo(
                                                    'wrong-password') ==
                                                0) {
                                              {
                                                tentatives -= 1;
                                              }
                                              /* if (tentatives == 0 ||
                                                  error.code.compareTo(
                                                          'too-many-requests') ==
                                                      0) {
                                                try {
                                                  blockedusers
                                                      .doc(blockeduser)
                                                      .set({'nom': 'nothing'});
                                                } on FirebaseException catch (e) {
                                                  print(e);
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          content:
                                                              Text('${e.code}'),
                                                          title:
                                                              Text(e.message!),
                                                        );
                                                      });
                                                }
                                              } */
                                            }
                                            result = error.code;
                                            /*   showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content: Text(
                                                        '${error.code}\n$tentatives\n${_emailcontroller.text.trimLeft().trimRight()}\n$blockeduser'),
                                                    title: Text(error.message!),
                                                  );
                                                }).whenComplete(() {
                                              instance.signOut();
                                            }); */
                                          }
                                      },
                                      child: const Text('Connecter'),
                                      style: ElevatedButton.styleFrom(
                                          shape: StadiumBorder(),
                                          side: BorderSide(
                                              color: Colors.black, width: 2))),
                                  SizedBox(width: 20),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Inscrir()));
                                      },
                                      child: const Text("S'inscrire"),
                                      style: ElevatedButton.styleFrom(
                                          shape: StadiumBorder(),
                                          side: BorderSide(
                                              color: Colors.black, width: 2))),
                                  /*     TextButton(
                                      onPressed: () async {
                                        /*  await verify(
                                                firestoreInstance,
                                                _emailcontroller.text
                                                    .trimLeft()
                                                    .trimRight(),
                                                'email')
                                            .then((value3) {
                                          blockeduser = value3 == null
                                              ? 'not found'
                                              : value3;
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
                                        }); */
                                        // try {
                                        //  noq
                                        //      .doc('dgfdg')
                                        //      .set({'nom': 'nothing'});
                                        // } on FirebaseException catch (e) {
                                        //   print(e);
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: Text(''),
                                                title: Text('test'),
                                              );
                                            });
                                        //}
                                      },
                                      child: Text('test')) */
                                ],
                              ),
                            ],
                          ))),
                  /*  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          side: BorderSide(color: Colors.black, width: 2)),
                      onPressed: () async {
                        /*  await connectGoogle().then((value) {
                          if (value.compareTo('') == 0)
                            Navigator.of(context).pop();
                          else
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Text(''),
                                    title: Text(value),
                                  );
                                });
                        }); */
                        await linkGoogle()
                            .then((value) => Navigator.of(context).pop());
                      },
                      child: Text('Connecter avec Google')) */
                  Container(
                      child: SignInButton(
                    Buttons.Google,
                    elevation: 4,
                    onPressed: () async {
                      await linkGoogle()
                          .then((value) => Navigator.of(context).pop());
                    },
                  ))
                ]))
          ])),
      debugShowCheckedModeBanner: false,
    );
  }
}
