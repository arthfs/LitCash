import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lcash/main.dart';
import 'modelpage.dart';
import 'theme.dart';

AuthCredential? newuser = null;

int jour = DateTime.now().day,
    mois = DateTime.now().month,
    annee = DateTime.now().year - 18;

/*Future<String?> getdata(CollectionReference<Map<String, dynamic>> collecrefe,
    String? iddoc, String value) async {
  var collectrefe = firestoreInstance;
  var docSnapshot = await collecrefe.doc(iddoc).get();
  Map<String, dynamic>? data = docSnapshot.data();
  print(data?[value]);
  return data?[value];
}

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
); */

String idcollection = '';

String password = '', tempassword = '';
double formheight = 429.5, fieldspace = 7;

class Inscrire extends StatefulWidget {
  const Inscrire({Key? key}) : super(key: key);

  @override
  _InscrireState createState() => _InscrireState();
}

class _InscrireState extends State<Inscrire> {
  DateTime? tempdate = DateTime.utc(annee, jour, annee);
  final _formkey = GlobalKey<FormState>();
  final _passwordcontroller = TextEditingController(),
      _confirmpasswordcontroller = TextEditingController(),
      _emailcontroller = TextEditingController(),
      _nomcontroller = TextEditingController(),
      _prenomcontroller = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  //69

  double fieldheight = 45, fieldwidth = 275;
  String tempemail = '', email = '', result = '';
  bool? conditions = false, policies = false;
  String countrycode = '+509';
  @override
  void dispose() {
    _passwordcontroller.dispose();
    _confirmpasswordcontroller.dispose();
    _emailcontroller.dispose();
    _nomcontroller.dispose();
    _prenomcontroller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
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
            body: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Inscription",
                    style: titlefonts,
                  ),
                  Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Container(
                            constraints: BoxConstraints(minWidth: 392.7),
                            //   color: Colors.red,
                            height: formheight,
                            //width: fieldwidth,
                            //alignment: Alignment.center,
                            child: Form(
                              key: _formkey,
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(top: fieldspace),
                                      width: fieldwidth,
                                      height: fieldheight,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            labelText: 'Nom',
                                            border: OutlineInputBorder()),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            new RegExp(r'[a-zA-Z]'),
                                          ),
                                        ],
                                        controller: _nomcontroller,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.text,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        textDirection: TextDirection.ltr,
                                        onChanged: (x) {},
                                        validator: (x) {
                                          if (x != null && x.isEmpty ||
                                              x!.length < 4)
                                            return 'entrer votre nom';
                                          return null;
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: fieldspace),
                                      width: fieldwidth,
                                      height: fieldheight,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            labelText: 'Prenom',
                                            border: OutlineInputBorder()),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              new RegExp(r'[a-zA-Z]')),
                                        ],
                                        controller: _prenomcontroller,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.text,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        textDirection: TextDirection.ltr,
                                        onChanged: (x) {},
                                        validator: (x) {
                                          if (x != null && x.isEmpty ||
                                              x!.length < 4)
                                            return 'entrer votre Prenom';
                                          return null;
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: fieldspace),
                                      width: fieldwidth,
                                      height: fieldheight,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            labelText: 'Email',
                                            border: OutlineInputBorder()),
                                        controller: _emailcontroller,
                                        textInputAction: TextInputAction.next,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        textDirection: TextDirection.ltr,
                                        onTap: () {
                                          result = '';
                                        },
                                        onChanged: (x) {
                                          result = '';
                                          tempemail = x.trimLeft().trimRight();
                                        },
                                        validator: (x) {
                                          if (x != null && x.isEmpty)
                                            return 'entrer votre email';
                                          if (result
                                                  .compareTo('invalid-email') ==
                                              0) return 'Email invalide';

                                          if (result.compareTo(
                                                  'email-already-in-use') ==
                                              0)
                                            return 'Cet email est deja utilise';
                                          return null;
                                        },
                                      ),
                                    ),
                                    Container(
                                        constraints: BoxConstraints(
                                            maxHeight: fieldheight,
                                            maxWidth: fieldwidth),
                                        padding:
                                            EdgeInsets.only(top: fieldspace),
                                        width: fieldwidth,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            border: Border.all()),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                '     ${tempdate?.year} - ${tempdate?.month} - ${tempdate?.day}',
                                                textAlign: TextAlign.center,
                                              ),
                                              Expanded(
                                                  child: Container(
                                                      width: 200,
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: TextButton.icon(
                                                          autofocus: true,
                                                          onPressed: () async {
                                                            await showDatePicker(
                                                                    context:
                                                                        context,
                                                                    initialDate:
                                                                        DateTime.utc(
                                                                            2004),
                                                                    firstDate: DateTime
                                                                        .fromMicrosecondsSinceEpoch(
                                                                            123),
                                                                    lastDate:
                                                                        DateTime(
                                                                            2004,
                                                                            1,
                                                                            1))
                                                                .then((value) {
                                                              tempdate = value;
                                                              setState(() {});
                                                            });
                                                          },
                                                          icon: Icon(
                                                            Icons
                                                                .calendar_today,
                                                            size: 20,
                                                          ),
                                                          label: Text(""))))
                                            ])),
                                    Container(
                                        width: fieldwidth,
                                        height: fieldheight,
                                        padding:
                                            EdgeInsets.only(top: fieldspace),
                                        child: TextFormField(
                                          obscureText: true,
                                          obscuringCharacter: '*',
                                          decoration: InputDecoration(
                                              errorMaxLines: 1,
                                              labelText: 'Password',
                                              border: OutlineInputBorder()),
                                          controller: _passwordcontroller,
                                          textInputAction: TextInputAction.done,
                                          keyboardType: TextInputType.text,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          textDirection: TextDirection.ltr,
                                          onChanged: (x) {
                                            result = '';
                                            tempassword =
                                                x.trimLeft().trimRight();
                                          },
                                          onTap: () {
                                            result = '';
                                          },
                                          validator: (x) {
                                            String verif = strongpassw(x!);
                                            if (x.isEmpty)
                                              return "Entrer votre  mot de passe";

                                            if (verif.compareTo('l') == 0)
                                              return 'Entrez au moins une lettre minuscule';
                                            else if (verif.compareTo('d') == 0)
                                              return 'Entrez au moins un chiffre';
                                            else if (verif.compareTo('u') == 0)
                                              return 'Entrez au moins une lettre majuscule';
                                            else if (verif.compareTo('s') == 0)
                                              return 'Entrez au moins un symbole';
                                            else if (verif.compareTo('len') ==
                                                0)
                                              return 'Mot de passe trop courte';
                                            else if (verif.compareTo('all') ==
                                                0)
                                              return 'au moins (1 symbole,1 chiffre,1 majuscule)';
                                            return null;
                                          },
                                        )),
                                    Container(
                                      padding: EdgeInsets.only(top: fieldspace),
                                      width: fieldwidth,
                                      height: fieldheight,
                                      child: TextFormField(
                                        obscureText: true,
                                        obscuringCharacter: '*',
                                        decoration: InputDecoration(
                                            labelText: 'Confirmer password',
                                            border: OutlineInputBorder()),
                                        controller: _confirmpasswordcontroller,
                                        textInputAction: TextInputAction.done,
                                        keyboardType: TextInputType.text,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        textDirection: TextDirection.ltr,
                                        onChanged: (x) {
                                          result = '';
                                          // tempassword = x.trimLeft().trimRight();
                                        },
                                        onTap: () {
                                          result = '';
                                        },
                                        validator: (x) {
                                          if (x!.isEmpty)
                                            return "Entrer le meme  mot de passe";
                                          if (x.compareTo(
                                                  _passwordcontroller.text) !=
                                              0)
                                            return 'Les deux mot de passe ne sont pas identiques';
                                          return null;
                                          //else if (validateStructure(x) == false)
                                          // return 'Votre mot de passe est trop faible';
                                        },
                                      ),
                                    ),
                                    Container(
                                     
                                      width: fieldwidth + 80,
                                      alignment: Alignment.center,
                                      child: Center(
                                          child: Column(
                                        children: [
                                          Container(
                                              height: 30,
                                              child: Row(
                                                  // mainAxisAlignment:
                                                  //MainAxisAlignment.center
                                                  children: [
                                                    Checkbox(
                                                        //checkColor: Colors.green,
                                                        autofocus: true,
                                                        value: policies,
                                                        onChanged: (choix) {
                                                          setState(() {
                                                            policies = choix;
                                                          });
                                                        }),
                                                    Text(
                                                      "J'ai lu et j'accepte les",
                                                      //textAlign: TextAlign.center,
                                                    ),
                                                    TextButton(
                                                        autofocus: true,
                                                        onPressed: () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  content:
                                                                      Text(''),
                                                                  title: Text(
                                                                      "Conditions d'utilisations"),
                                                                );
                                                              });
                                                        },
                                                        child: Text(
                                                          "conditions d'utilisations",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue),
                                                        ))
                                                  ])),
                                          Container(
                                              height: 33,
                                              child: Row(
                                                  //mainAxisAlignment:
                                                  //  MainAxisAlignment.center,
                                                  children: [
                                                    Checkbox(
                                                        //checkColor: Colors.green,
                                                        autofocus: true,
                                                        value: conditions,
                                                        onChanged: (choix) {
                                                          setState(() {
                                                            conditions = choix;
                                                          });
                                                        }),
                                                    Text(
                                                      "J'ai lu et j'accepte la",
                                                      //textAlign: TextAlign.right,
                                                    ),
                                                    TextButton(
                                                        autofocus: true,
                                                        onPressed: () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  content: Text(
                                                                      'privacypolicies'),
                                                                  title: Text(
                                                                      "Politique de confidentialité"),
                                                                );
                                                              });
                                                        },
                                                        child: Text(
                                                          'politique de confidentialité',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue),
                                                        ))
                                                  ])),
                                        ],
                                      )),
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          if (_formkey.currentState!
                                                  .validate() &&
                                              conditions == true &&
                                              policies == true) {
                                            try {
                                              await FirebaseAuth.instance
                                                  .createUserWithEmailAndPassword(
                                                      email: tempemail
                                                          .trimLeft()
                                                          .trimRight(),
                                                      password: tempassword
                                                          .trimLeft()
                                                          .trimRight())
                                                  .then((value1) {
                                                newuser = value1.credential;
                                                Client x = Client(
                                                    tempemail, tempassword,
                                                    datenaissance:
                                                        '${tempdate?.year}-${tempdate?.month.toString().padLeft(2, '0')}-${tempdate?.day.toString().padLeft(2, '0')}',
                                                    nom: _nomcontroller.text,
                                                    prenom:
                                                        _prenomcontroller.text,
                                                    balance: 0.0);

                                                firestoreInstance
                                                    .doc(instance
                                                        .currentUser?.uid)
                                                    .set(x.todoc())
                                                    .then((value2) {
                                                  _emailcontroller.clear();
                                                  _nomcontroller.clear();
                                                  _prenomcontroller.clear();
                                                  _passwordcontroller.clear();
                                                  _confirmpasswordcontroller
                                                      .clear();
                                                  try {
                                                    var transactionsref =
                                                        firestoreInstance
                                                            .doc(instance
                                                                .currentUser
                                                                ?.uid)
                                                            .collection(
                                                                'transactions');
                                                    transactionsref
                                                        .doc('first')
                                                        .set({
                                                      'date': '9999-11-12',
                                                      'destinataire': 'first',
                                                      'montant': -99,
                                                      'receveur': 'first',
                                                      'type': 'sortant'
                                                    }).then((value) {
                                                      var notificationsref =
                                                          firestoreInstance
                                                              .doc(instance
                                                                  .currentUser
                                                                  ?.uid)
                                                              .collection(
                                                                  'notifications');
                                                      notificationsref
                                                          .doc('first')
                                                          .set({
                                                        'date': '9999-11-12',
                                                        'destinataire': 'first',
                                                        'montant': -99,
                                                        'receveur': 'first',
                                                        'type': 'sortant',
                                                        'message': 'nothing'
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    });
                                                  } on FirebaseException catch (e) {
                                                    setState(() {});
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            content: Text(
                                                                e.message!),
                                                            title: Text(e.code),
                                                          );
                                                        });
                                                    //  print(e);
                                                    result = e.code;
                                                    return e;
                                                  }
                                                  /* idcollection = value2.id;

                                        x.id = value2.id;
                                        firestoreInstance.doc(x.id).update(

                                            {'id': instance.currentUser!.uid});
                                        value1.user?.updatePhotoURL(value2.id);
                                        */
                                                });
                                                instance.signInWithCredential(
                                                    value1.credential!);
                                                return value1;
                                              });
                                            } on FirebaseException catch (error) {
                                              result = error.code;
                                              setState(() {});
                                              // print(result);
                                            }
                                          }
                                        },
                                        child: const Text("S' inscrire"),
                                        style: ElevatedButton.styleFrom(
                                            shape: StadiumBorder(),
                                            side: BorderSide(
                                                color: Colors.black,
                                                width: 2))),
                                    /* TextButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: StadiumBorder(),
                                      side: BorderSide(
                                          color: Colors.black, width: 2)),
                                  onPressed: () async {
                                    await linkGoogle().then(
                                        (value) => Navigator.of(context).pop());
                                  },
                                  child: Text('Inscrire avec Google')),*/
                                    Container(
                                        /* decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(2),
                                      color: Colors.black),*/
                                        child: SignInButton(
                                      Buttons.Google,
                                      elevation: 4,
                                      onPressed: () async {
                                        await linkGoogle().then((value) =>
                                            Navigator.of(context).pop());
                                      },
                                    )),
                                  ]),
                            ))
                      ]))
                ]),
            resizeToAvoidBottomInset: false),
        debugShowCheckedModeBanner: false);
  }
}
