import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lcash/main.dart';
import 'menu/problems.dart';
import 'package:lcash/theme.dart';
import 'modelpage.dart';
import 'menu/transactions.dart';
import 'menu/conversions.dart';
import 'menu/parametres.dart';

import 'menu/apropos.dart';

//import 'package:map_launcher/map_launcher.dart';

//var b = TextButton.icon(onPressed: (){}, icon: Icon (Icons.send), label: Text('label'));
GoogleSignInAccount? googleuser = GoogleSignIn().currentUser;
User? y;
String _urlinsta = 'https://www.instagram.com/_litcash_/';
String _urlmeta = 'https://facebook.com/arthur.freestyler99/';
String _urlgmail =
    'https://mail.google.com/mail/u/0/#inbox?compose=GTvVlcSBmWwRLxvXxQsGpqBpntlNTHwZPWLQxlfNNQtmBQNPBpGsVKzldPDcnzqtwBqBnXmcnvkDt';
void art() {
  // ignore: avoid_print
  print("2");
}

int active = 1;

class Menu extends StatefulWidget {
  Menu({Key? key, User? c}) : super(key: key) {
    void deleteuser(User? c) async {
      try {
        await c?.delete();
      } catch (e) {
        print(e);
      }
    }

    user = c;
    y = c;
  }

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  // final _passwordcontroller = TextEditingController();
  String tempassword = '';
  int b = 1;
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    Iterable<Widget> menubuttons = [
      TextButton.icon(
        style: const ButtonStyle(alignment: Alignment.centerLeft),
        icon: const Icon(Icons.price_change_outlined),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const Conversion()));
        },
        label: Text(
          'Conversion devises',
          style: buttonsfonts,
        ),
      ),
    ];
    active = 1;
    /* if (b == 0) {
      tentatives = 3;
      instance.signOut();
    }
    */

    return MaterialApp(
      theme: currenttheme,
      home: Scaffold(
        body: ListView(
            children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              //subtitle: Divider(color: Colors.white),
              contentPadding: const EdgeInsets.only(bottom: 20),
              style: ListTileStyle.list,
              title: TextButton.icon(
                style: const ButtonStyle(alignment: Alignment.centerLeft),
                icon: const Icon(
                  Icons.price_change_outlined,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Conversion()));
                },
                label: Text(
                  'Conversion devises',
                  style: buttonsfonts,
                ),
              ),
            ),
            ListTile(
              //subtitle: Divider(color: Colors.white),
              contentPadding: const EdgeInsets.only(bottom: 20),
              title: TextButton.icon(
                  style: const ButtonStyle(alignment: Alignment.centerLeft),
                  icon: const Icon(Icons.location_on),
                  onPressed: () async {
                    final availableMaps = await MapLauncher.installedMaps;
                    //print(
                    //  availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

                    await availableMaps.first.showDirections(
                      destination:
                          Coords(18.526500840598498, -72.32146744954757),
                      destinationTitle: "Université Quisqueya",
                    );
                  },
                  label: Text('Agent le plus proche', style: buttonsfonts)),
            ),
            ListTile(
              //subtitle: Divider(color: Colors.white),
              contentPadding: const EdgeInsets.only(bottom: 20),
              title: TextButton.icon(
                  style: const ButtonStyle(alignment: Alignment.centerLeft),
                  icon: const Icon(
                    Icons.content_paste_sharp,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Historiquetransactions()));
                  },
                  label: Text('Historique transactions', style: buttonsfonts)),
            ),
            ListTile(
              // subtitle: Divider(color: Colors.white),
              contentPadding: const EdgeInsets.only(bottom: 20),
              title: TextButton.icon(
                  style: const ButtonStyle(alignment: Alignment.centerLeft),
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    {
                      /*if (tentatives > 0) {
                        {
                         if (tentatives != 99)
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  if (tentatives > 0) {
                                    return AlertDialog(
                                        // backgroundColor: Colors.purple,
                                        title:
                                            Text('Entrer votre mot de passe'),
                                        content: Container(
                                            height: 200,
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Container(
                                                    child: TextFormField(
                                                      obscureText: true,
                                                      obscuringCharacter: '*',
                                                      decoration:
                                                          InputDecoration(
                                                              labelText:
                                                                  'Password'),
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .deny("1234567890")
                                                      ],
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
                                                        tempassword =
                                                            x.trimLeft();
                                                      },
                                                      validator: (x) {
                                                        if (x!.isEmpty)
                                                          return "Entrer le mot de passe";
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      height: 30,
                                                      child: ElevatedButton(
                                                          onPressed: () {
                                                            if (currentpass
                                                                    .compareTo(
                                                                        tempassword) ==
                                                                0) {
                                                              active = 0;

                                                              Navigator.of(
                                                                      context)
                                                                  .pushReplacement(
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              Parametre(
                                                                                c: user,
                                                                              )));
                                                              tentatives = 3;
                                                            }
                                                            tentatives -= 1;

                                                            _passwordcontroller
                                                                .clear();
                                                          },
                                                          child: Text(
                                                              'confirmer')))
                                                ])));
                                  } else {
                                    try {
                                      blockedusers
                                          .doc(instance.currentUser?.uid)
                                          .set({'nom': 'nothing'}).then(
                                              (value) {
                                        b = 0;
                                      });
                                    } catch (e) {
                                      print(e);
                                    }

                                    return AlertDialog(
                                        // backgroundColor: Colors.purple,
                                        title:
                                            Text('Entrer votre mot de passe'),
                                        content: Container(
                                            height: 200,
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                      'Votre compte a ete bloque car vous avez entre 3 mot de passe incorrects')
                                                ])));
                                  }
                                }); 
                        }
                      }*/
                      authentication possible = authentication();
                      possible.supported().then((value) {
                        if (value == true)
                          possible.authenticate().then((value) {
                            if (value == false) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        // backgroundColor: Colors.purple,
                                        title: Text('error'),
                                        content: Text(
                                            'failed to authenticate user'));
                                  });
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Parametre(
                                        c: user,
                                      )));
                            }
                          });
                        else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    // backgroundColor: Colors.purple,
                                    title: Text('No biometrics'),
                                    content: Text(
                                        'configurer une methode securitaire'));
                              });
                        }
                      });
                    }
                  },
                  label: Text('Paramètres du compte', style: buttonsfonts)),
            ),
            ListTile(
              // subtitle: Divider(color: Colors.white),
              contentPadding: const EdgeInsets.only(bottom: 20),
              title: TextButton.icon(
                  style: const ButtonStyle(alignment: Alignment.centerLeft),
                  icon: const Icon(
                    Icons.accessibility_rounded,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Apropos()));
                  },
                  label: Text('A propos de nous', style: buttonsfonts)),
            ),
            ListTile(
              // subtitle: Divider(color: Colors.white),
              contentPadding: const EdgeInsets.only(bottom: 20),
              title: TextButton.icon(
                  style: const ButtonStyle(alignment: Alignment.centerLeft),
                  icon: const Icon(
                    Icons.report_problem,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Problems()));
                  },
                  label: Text('Reporter un problème', style: buttonsfonts)),
            ),
            ListTile(
              //subtitle: Divider(color: Colors.white),
              contentPadding: const EdgeInsets.only(bottom: 20),
              title: TextButton.icon(
                  style: const ButtonStyle(alignment: Alignment.centerLeft),
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: Text('Voulez vous déconnecter?'),
                              content: Container(
                                  height: 200,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(),
                                                alignment: Alignment.centerLeft,
                                                child: ElevatedButton(
                                                  child: Text('Oui'),
                                                  onPressed: () async {
                                                    try {
                                                      //tentatives = 3;
                                                      possibleuser = false;
                                                      GoogleSignIn()
                                                          .disconnect()
                                                          .whenComplete(() {
                                                        instance
                                                            .signOut()
                                                            .whenComplete(() =>
                                                                setState(() {
                                                                  instance
                                                                      .currentUser
                                                                      ?.reload();
                                                                }));
                                                      });
                                                      //  instance.signOut();
                                                      Navigator.of(context)
                                                          .pop();
                                                    } catch (e) {
                                                      print('@@@$e');
                                                    }
                                                    possibleuser = false;
                                                  },
                                                )),
                                            Container(
                                                decoration: BoxDecoration(),
                                                alignment:
                                                    Alignment.centerRight,
                                                child: ElevatedButton(
                                                  child: Text('Non'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                )),
                                          ],
                                        ),
                                      ])));
                        });
                  },
                  label: Text('Déconnection', style: buttonsfonts)),
            ),
            /* Container(
                color: Colors.amber,
                height: 70,
                child: ListTile(
                    //subtitle: Divider(color: Colors.white),
                    contentPadding: const EdgeInsets.only(bottom: 20),
                    title: Row(children: [
                      IconButton(
                        onPressed: () {
                          _launchURL(_urlinsta);
                        },
                        icon: Image.asset('assets/images/insta.jpg',
                            alignment: Alignment.centerLeft,
                            fit: BoxFit.contain),
                        tooltip: "Instagram",
                        iconSize: 10,
                      ),
                      IconButton(
                        onPressed: () {
                          _launchURL(_urlgmail);
                        },
                        icon: Image.asset('assets/images/Gmail.png',
                            alignment: Alignment.centerLeft),
                        tooltip: "Gmail",
                        iconSize: 10,
                      ),
                      IconButton(
                        onPressed: () {
                          _launchURL(_urlmeta);
                        },
                        icon: Image.asset(
                          'assets/images/Meta.png',
                          alignment: Alignment.centerLeft,
                        ),
                        tooltip: "Meta",
                        iconSize: 10,
                      )
                    ]))),*/
          ],
        ).toList()),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
