import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lcash/main.dart';
import 'package:lcash/verifieremail.dart';
import 'package:lcash/modelpage.dart';
import 'package:lcash/parametres/nom.dart';
import 'package:lcash/theme.dart';
import 'package:lcash/phone.dart';
import 'package:lcash/parametres/prenom.dart';
import 'package:lcash/parametres/email.dart';
import 'package:lcash/parametres/password.dart';
import 'package:lcash/parametres/datenaissance.dart';

User? x;

class Parametre extends StatefulWidget {
  Parametre({Key? key, User? c}) : super(key: key) {
    x = c;
  }

  @override
  _ParametreState createState() => _ParametreState();
}

class _ParametreState extends State<Parametre> {
  Map<String, bool> raisons = <String, bool>{
    "Je ne comprends pas l' application ": false,
    "Je n' aime pas l' application": false,
    "L' application ne réponds pas à mes besoins": false
  };
  List<String> motifs = [];
  @override
  int i = 0;
  Widget build(BuildContext context) {
    List<TextButton> menubuttons = [
      TextButton(
        style: const ButtonStyle(alignment: Alignment.centerLeft),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Nom()));
        },
        child: Text(
          'Ajouter/Changer Nom',
          style: buttonsfonts,
        ),
      ),
      TextButton(
          style: const ButtonStyle(alignment: Alignment.centerLeft),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Prenom()));
          },
          child: Text(' Ajouter/Changer Prenom', style: buttonsfonts)),
      TextButton(
          style: const ButtonStyle(alignment: Alignment.centerLeft),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Email()));
          },
          child: Text(' Ajouter/Changer Email', style: buttonsfonts)),
      TextButton(
          style: const ButtonStyle(alignment: Alignment.centerLeft),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Phone()));
          },
          child: Text(' Changer numero de telephone', style: buttonsfonts)),
      TextButton(
          style: const ButtonStyle(alignment: Alignment.centerLeft),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Datenaissance()));
          },
          child:
              Text('Ajouter/Changer Date de naissance', style: buttonsfonts)),
      if (possibleuser != true)
        TextButton(
            style: const ButtonStyle(alignment: Alignment.centerLeft),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Password()));
            },
            child: Text('Changer password', style: buttonsfonts)),
      if (possibleuser != true)
        TextButton(
            style: const ButtonStyle(alignment: Alignment.centerLeft),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Verifieremail()));
            },
            child: Text('Verifier mon email', style: buttonsfonts)),
      TextButton(
          style: const ButtonStyle(alignment: Alignment.centerLeft),
          onPressed: () async {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Text(
                          'Voulez vous definitivement supprimer votre compte?'),
                      content: Container(
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      child: ElevatedButton(
                                        child: Text('Oui'),
                                        onPressed: () async {
                                          print(raisons);
                                          Navigator.of(context).pop();
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                    title: Text(
                                                        'Pourquoi voulez vous supprimer votre compte'),
                                                    content: Container(
                                                        height: 300,
                                                        child: Column(
                                                            children: [
                                                              Column(
                                                                  children: raisons
                                                                      .keys
                                                                      .map((e) {
                                                                return CheckboxListTile(
                                                                    title:
                                                                        Text(e),
                                                                    value:
                                                                        raisons[
                                                                            e],
                                                                    onChanged:
                                                                        (newvalue) {
                                                                      if (newvalue ==
                                                                          true) {
                                                                        motifs.add(
                                                                            e);
                                                                        raisons[e] =
                                                                            newvalue!;
                                                                      } else if (newvalue ==
                                                                          false) {
                                                                        motifs.remove(
                                                                            e);
                                                                        raisons[e] =
                                                                            newvalue!;
                                                                      }

                                                                      print(e);
                                                                      print(
                                                                          motifs);
                                                                    });
                                                              }).toList()),
                                                              Expanded(
                                                                  child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                    Container(
                                                                        alignment:
                                                                            Alignment
                                                                                .center,
                                                                        child: ElevatedButton(
                                                                            child:
                                                                                Text('Retourner'),
                                                                            onPressed: () => Navigator.of(context).pop())),
                                                                    Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child: ElevatedButton(
                                                                            child: Text('Confirmer'),
                                                                            onPressed: () async {
                                                                              String motif_final = '';
                                                                              print(motifs);
                                                                              //print(raisons);
                                                                              for (int h = 0; h < motifs.length; h++)
                                                                                if (h != motifs.length - 1)
                                                                                  motif_final += '${motifs[h]} , ';
                                                                                else
                                                                                  motif_final += '${motifs[h]}';
                                                                              print(motif_final);
                                                                              var deleteuser;
                                                                              await firestoreInstance.doc(instance.currentUser?.uid).get().then((value) {
                                                                                deleteuser = value.data();
                                                                              });
                                                                              try {
                                                                                firestoreMotifsupression
                                                                                    .add(({
                                                                                  'nom': '${deleteuser['nom']}',
                                                                                  'prenom': '${deleteuser['prenom']}',
                                                                                  'date': DateTime.now().toString(),
                                                                                  'motif': motif_final
                                                                                }))
                                                                                    .then((value) {
                                                                                  Navigator.of(context).pop();
                                                                                  try {
                                                                                    GoogleSignIn().disconnect().whenComplete(() async {
                                                                                      await firestoreTransactions.get().then((value) {
                                                                                        var documents = value.docs;
                                                                                        for (var u in documents) {
                                                                                          u.reference.delete();
                                                                                        }
                                                                                      });

                                                                                      await firestoreNotifications.get().then((value) {
                                                                                        var documents = value.docs;
                                                                                        for (var u in documents) {
                                                                                          u.reference.delete();
                                                                                        }
                                                                                      });

                                                                                      await firestoreInstance.doc(instance.currentUser?.uid).delete();
                                                                                      await instance.currentUser?.delete().then((value) {}).whenComplete(() {});
                                                                                    });
                                                                                  } catch (e) {
                                                                                    print(e);
                                                                                  }
                                                                                });
                                                                                /*print({
                                                                                  'nom': '${deleteuser['nom']}',
                                                                                  'prenom': '${deleteuser['prenom']}',
                                                                                  'date': DateTime.now().toString(),
                                                                                  'motif': motif_final
                                                                                });*/
                                                                              } on FirebaseException catch (error) {
                                                                                showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return AlertDialog(
                                                                                          // backgroundColor: Colors.purple,
                                                                                          title: Text('${error.code}'),
                                                                                          content: Text('${error.message}'));
                                                                                    });
                                                                              }
                                                                            }))
                                                                  ]))
                                                            ])));
                                              });

                                          /*  try {
                                              GoogleSignIn()
                                                  .disconnect()
                                                  .whenComplete(() async {
                                                await firestoreInstance
                                                    .doc('transactions')
                                                    .delete();
                                                await firestoreInstance
                                                    .doc('notifications')
                                                    .delete();
                                                await firestoreInstance
                                                    .doc(instance
                                                        .currentUser?.uid)
                                                    .delete();
                                                await instance.currentUser
                                                    ?.delete()
                                                    .then((value) {})
                                                    .whenComplete(() {});
                                              });
                                            } catch (e) {
                                              print(e);
                                            } */
                                        },
                                      )),
                                  Container(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton(
                                          child: Text('Non'),
                                          onPressed: () =>
                                              Navigator.of(context).pop())),
                                ],
                              )
                            ],
                          )));
                });
          },
          child: Text('Supprimer mon compte', style: buttonsfonts)),
    ];
    return MaterialApp(
      theme: currenttheme,
      home: Scaffold(
        appBar: wappBarmodel(context),
        body: ListView.builder(
          itemBuilder: (BuildContext context, i) {
            return Wparametresbuttons(menubuttons[i]);
          },
          itemCount: menubuttons.length,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
