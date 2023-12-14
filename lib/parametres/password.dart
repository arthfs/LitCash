import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:lcash/main.dart';
import 'package:lcash/theme.dart';
import 'package:lcash/modelpage.dart';

User? x;

class Password extends StatefulWidget {
  Password({Key? key, User? c}) : super(key: key) {
    x = c;
  }

  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  final _formkey = GlobalKey<FormState>();
  final _password1controller = TextEditingController();
  final _password2controller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  String oldpassword = '',
      tempassword1 = '',
      tempassword2 = '',
      tempassword = '';
  @override
  void dispose() {
    _password1controller.dispose();
    _password2controller.dispose();
    _passwordcontroller.dispose();

    super.dispose();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: currenttheme,
      home: Scaffold(
        appBar: wappBarmodel(context),
        //backgroundColor: Colors.grey,
        body: Column(children: [
          Text(
            "Password\n",
            style: titlefonts,
          ),
          Form(
            key: _formkey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(width: 3, style: BorderStyle.solid)),
                    child: Text(
                      "Password : $tempassword1",
                      style: buttonsfonts,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                      alignment: Alignment.center,
                      width: 500,
                      child: Column(children: [
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Ancien password'),
                          controller: _passwordcontroller,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textDirection: TextDirection.ltr,
                          onChanged: (x) {
                            tempassword = x.trimLeft();
                          },
                          validator: (x) {
                            if (x!.isEmpty) return "Entrer l'ancien password";
                            return null;
                            //else if (x.compareTo(oldpassword) != 0)
                            //return "Ce password ne correspond pas a celui que vous aviez eu";
                          },
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Nouveau password'),
                          controller: _password1controller,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textDirection: TextDirection.ltr,
                          onChanged: (x) {
                            tempassword1 = x.trimLeft();
                          },
                          validator: (x) {
                            /* brfore
                              if (x!.isEmpty)
                                return "Entrer le nouveau password";
                              else if (isPasswordCompliant(x) == false)
                                return 'Votre password est trop faible'; */
                            String verif = strongpassw(x!);
                            if (x.isEmpty) return "Entrer votre  mot de passe";

                            if (verif.compareTo('l') == 0)
                              return 'Entrez au moins une lettre minuscule';
                            else if (verif.compareTo('d') == 0)
                              return 'Entrez au moins un chiffre';
                            else if (verif.compareTo('u') == 0)
                              return 'Entrez au moins une lettre majuscule';
                            else if (verif.compareTo('s') == 0)
                              return 'Entrez au moins un symbole';
                            else if (verif.compareTo('len') == 0)
                              return 'Mot de passe trop courte';
                            else if (verif.compareTo('all') == 0)
                              return 'au moins (1 symbole,1 chiffre,1 majuscule)';
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Nouveau password'),
                          controller: _password2controller,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textDirection: TextDirection.ltr,
                          onChanged: (x) {
                            tempassword2 = x.trimLeft();
                          },
                          validator: (x) {
                            if (x!.compareTo(tempassword1) != 0)
                              return "Les deux passwords sont differents.";
                            return null;
                          },
                        )
                      ])),
                  ElevatedButton(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          Future<bool> checkoldpassword() async {
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: instance.currentUser!.email!,
                                      password:
                                          tempassword.trimLeft().trimRight());
                            } on FirebaseException catch (error) {
                              print("${error.code} ${error.message}");
                              return false;
                            }
                            return true;
                            /*await firestoreInstance
                                .doc(instance.currentUser?.uid)
                                .get()
                                .then((value) {
                              oldpassword = value.get('password');
                            });*/
                          }

                          checkoldpassword().then((value) {
                            // print("$tempassword $oldpassword");
                            if (value) {
                              print('yes');
                              update_password() async {
                                try {
                                  await firestoreInstance
                                      .doc(instance.currentUser?.uid)
                                      .update({'password': tempassword1}).then(
                                          (value) async {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                              // backgroundColor: Colors.purple,

                                              title: Text(
                                                  'Mot de passe a été mise à jour avec succès.'),
                                              content: Text(
                                                  'Maintenant reconnecter vous avec votre nouveau mot de passe.'));
                                        });

                                    await instance.currentUser
                                        ?.updatePassword(tempassword1)
                                        .then((value) {
                                      _passwordcontroller.clear();
                                      _password1controller.clear();
                                      _password2controller.clear();

                                      instance.signOut();
                                    });
                                  });
                                } on FirebaseException catch (e) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: Text("${e.code}"),
                                            content: Container(
                                              child: Text('${e.message}'),
                                            ));
                                      });
                                }

                                tempassword2 = tempassword1;
                              }

                              ;
                              update_password();
                            } else {
                              print('no');
                              _passwordcontroller.clear();
                            }
                          });

                          /*   setState(() async {
                            try {
                              await x?.updatePassword(tempassword1);
                            } on FirebaseException catch (e) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: Text("${e.code}"),
                                        content: Container(
                                          child: Text('${e.message}'),
                                        ));
                                  });
                            }
                            ;
                            tempassword2 = tempassword1;
                          }); */
                        }
                      },
                      child: Text('Enregistrer'))
                ]),
          ),
        ]),
        resizeToAvoidBottomInset: false,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
