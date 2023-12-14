import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lcash/main.dart';
import 'package:lcash/modelpage.dart';
import 'package:lcash/theme.dart';

// sender 73.72   receiver = 23.85
String sender = '';

class Tnvoyer extends StatefulWidget {
  const Tnvoyer({Key? key}) : super(key: key);

  @override
  _TnvoyerState createState() => _TnvoyerState();
}

class _TnvoyerState extends State<Tnvoyer> {
  String p = 'not found', pp = 'not found', result = '';
//  String? _destinateur = '';

  String _usr = '', _dest = '', _pass = '', tempemail = '', email = '';
  // var sender = null;

  var receiverbalance, receivername;
  final _formkey1 = GlobalKey<FormState>();
  final _formkey2 = GlobalKey<FormState>();
  String code = '+509';
  final _emailcontroller = TextEditingController();
  final _scrollcontroller = ScrollController();
  final _destcontroller = TextEditingController();
  double montant = 0,
      balance = 90.0,
      minmontant = 10.0,
      maxmontant = 6000.0,
      taxe = 0.05;
  int curstep = 0,
      moyenauthentif = user?.phoneNumber != null ? 1 : 2,
      maxstep = possibleuser == true ? 2 : 3;
  int b = 1;

  String pass = '';
  PhoneContact? _phoneContact;
  var subscription;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _destcontroller.dispose();
    _scrollcontroller.dispose();
    super.dispose();
    //subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    //if (moyenauthentif == 1) {
    // sender = tempemail;
    //}
    // sender = tempemail;
    /*  if (b == 0) {
      tentatives = 3;
      instance.signOut();
    }*/
    agent(instance.currentUser!.uid).then((value) {
      pp = value;
      if (pp.length > 9) {
        print('@@@5');
        taxe = 0.03 * 0.2;
      } else
        print('@@@3');
    });
    print(maxstep);
    return MaterialApp(
      theme: currenttheme,
      home: Scaffold(
        //backgroundColor: Colors.red,
        body: instance.currentUser!.emailVerified
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                    Text(
                      "Envoyer de l'argent à quelqu'un \n\n",
                      style: titlefonts,
                    ),
                    Expanded(
                        child: Container(
                            //constraints: BoxConstraints(maxHeight: 500, maxWidth: 500),
                            //width: 500,
                            //height: 500,

                            child: Stepper(
                      elevation: 5,
                      currentStep: curstep,
                      type: StepperType.horizontal,
                      steps: [
                        Step(
                            isActive: curstep == 0 ? true : false,
                            title: Text('Destinateur'),
                            state: _formkey1.currentState?.validate() == true
                                ? StepState.complete
                                : StepState.indexed,
                            content: Container(
                                //  color: Colors.black,
                                alignment: Alignment.center,
                                child: Form(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    key: _formkey1,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          IntlPhoneField(
                                            //countryCodeTextColor: theme1.prima,
                                            initialCountryCode: 'HT',
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            autovalidateMode:
                                                AutovalidateMode.disabled,
                                            // textDirection: TextDirection.ltr,
                                            decoration: InputDecoration(
                                                errorMaxLines: 2,
                                                labelText: 'Destinateur',
                                                prefixIcon: const Icon(
                                                    Icons.phone_android_sharp),
                                                suffixIcon: IconButton(
                                                  icon: const Icon(
                                                      Icons.contacts_rounded),
                                                  // color: Colors.black,
                                                  onPressed: () async {
                                                    final PhoneContact contact =
                                                        await FlutterContactPicker
                                                            .pickPhoneContact();

                                                    setState(() {
                                                      _phoneContact = contact;
                                                      _dest = (_phoneContact
                                                                      ?.phoneNumber
                                                                      ?.number ==
                                                                  null
                                                              ? ''
                                                              : _phoneContact
                                                                  ?.phoneNumber!
                                                                  .number)!
                                                          .trim()
                                                          .replaceAll(" ", "")
                                                          .replaceAll("-", "")
                                                          .replaceRange(0,
                                                              code.length, '');
                                                      _destcontroller.text =
                                                          _dest;
                                                      //print("$_destinateur");
                                                    });
                                                  },
                                                )),
                                            controller: _destcontroller,
                                            onChanged: (a) {
                                              print(a);

                                              setState(() {
                                                //code = a.countryCode!;
                                                print("$code");
                                                _dest = a.number
                                                    .replaceAll(" ", "")
                                                    .replaceAll("-", "");
                                                //.replaceRange(0, code.length, '');

                                                //print(a);
                                              });
                                            },
                                            onCountryChanged: (x) {
                                              setState(() {
                                                _destcontroller.clear();
                                                p = '';
                                                code = x.fullCountryCode;
                                                print(x.fullCountryCode);
                                              });
                                            },

                                            validator: (value) {
                                             

                                              if ('${code}${value}'
                                                      .compareTo(phonenumber) ==
                                                  0)
                                                return 'N entrez pas votre numero';
                                              if (value != null) {
                                                if (value.number.length > 4) {
                                                  verify(
                                                          firestoreInstance,
                                                          '${code}${value}',
                                                          'phone')
                                                      .then((value3) {
                                                    setState(() {
                                                      p = value3 == null
                                                          ? 'not found'
                                                          : value3;
                                                    });

                                                    print(p);
                                                  });
                                                }

                                                if (p.compareTo('not found') ==
                                                        0 &&
                                                    value.number.length == 8)
                                                  return "Cet utilisateur n'est pas sur le systeme";
                                                else if (value.number.length == 0)
                                                  return 'Invalid mobile number';
                                                else
                                                  firestoreInstance
                                                      .doc(p)
                                                      .get()
                                                      .then((value5) {
                                                    receiverbalance =
                                                        value5['balance'];
                                                    receivername =
                                                        value5['nom'] +
                                                            ' ' +
                                                            value5['prenom'];
                                                  });
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter.deny(
                                                  ' '),
                                              FilteringTextInputFormatter.deny(
                                                  ','),
                                              FilteringTextInputFormatter.deny(
                                                  '-')
                                            ],
                                            textInputAction:
                                                TextInputAction.done,
                                            keyboardType: TextInputType.number,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            textDirection: TextDirection.ltr,
                                            decoration: InputDecoration(
                                              labelText: 'montant',
                                              prefixIcon: Icon(
                                                  Icons.monetization_on,
                                                  color: Colors.amber.shade400),
                                            ),
                                            // controller: _montantcontroller2,
                                            onChanged: (String a) {
                                              setState(() {
                                                print(a);
                                                montant = a.length == 0
                                                    ? 0
                                                    : double.parse(a);
                                              });
                                            },
                                            onFieldSubmitted: (String a) {
                                              setState(() {});
                                            },
                                            validator: (String? value) {
                                              if (value?.length == 0) {
                                                return "value cannot be null";
                                              } else if (value!.length > 0) {
                                                if (double.parse(value) *
                                                            (1 + taxe) >
                                                        currentbalance &&
                                                    double.parse(value) >
                                                        minmontant)
                                                  return 'Recharger votre compte (vous aurez besoin au moins ${double.parse(value) * (1 + taxe)})';
                                                else if (double.parse(value) <
                                                        minmontant ||
                                                    double.parse(value) >
                                                        maxmontant)
                                                  return "entrer un  ${minmontant}>=montant <=${maxmontant}";
                                              } else
                                                return null;
                                              return null;
                                            },
                                          )
                                        ])))),
                        if (possibleuser != true)
                          Step(
                              isActive: curstep == 1 ? true : false,
                              title: Text('Détails'),
                              state: _formkey2.currentState?.validate() == true
                                  ? StepState.complete
                                  : StepState.indexed,
                              content: Container(
                                  //  color: Colors.black,
                                  alignment: Alignment.center,
                                  child: Form(
                                      key: _formkey2,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            moyenauthentif == 1
                                                ? IntlPhoneField(
                                                    dropdownDecoration:
                                                        BoxDecoration(
                                                            shape: BoxShape
                                                                .rectangle),
                                                    initialCountryCode: 'HT',
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .deny(','),
                                                      FilteringTextInputFormatter
                                                          .deny('.')
                                                    ],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    textAlign: TextAlign.left,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'numero de telephone',
                                                    ),
                                                    // controller: _destcontroller,
                                                    onChanged: (a) {
                                                      setState(() {
                                                        _usr = a.number.trim();
                                                        print(a);
                                                      });
                                                    },
                                                    validator: (value) {
                                                      if (value != null) {
                                                        if (value
                                                                .number.length <
                                                            8)
                                                          return "length must be greater than 8";
                                                      } else
                                                        return null;
                                                      return null;
                                                    },
                                                  )
                                                : TextFormField(
                                                    decoration: InputDecoration(
                                                        labelText: 'Email',
                                                        labelStyle: GoogleFonts
                                                            .pacifico(
                                                                fontSize:
                                                                    16.0)),
                                                    controller:
                                                        _emailcontroller,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    textDirection:
                                                        TextDirection.ltr,
                                                    onChanged: (x) {
                                                      tempemail = x
                                                          .trimLeft()
                                                          .trimRight();
                                                      result = '';
                                                    },
                                                    onTap: () {
                                                      result = '';
                                                    },
                                                    validator: (x) {
                                                      if (x!.length <= 4)
                                                        return "Entrer un email valide";
                                                      if (result.compareTo(
                                                              'invalid-email') ==
                                                          0) {
                                                        //result = '';
                                                        return 'Email Incorrect';
                                                      }
                                                      if (result.compareTo(
                                                              'user-not-found') ==
                                                          0)
                                                        return 'Cet email ne correspond  à aucun compte';
                                                      return null;
                                                    },
                                                  ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            TextFormField(
                                              keyboardAppearance:
                                                  Brightness.light,
                                              obscureText: true,
                                              obscuringCharacter: '*',
                                              textInputAction:
                                                  TextInputAction.done,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              textDirection: TextDirection.ltr,
                                              decoration: InputDecoration(
                                                labelText: 'mot de passe',
                                              ),
                                              // controller: _montantcontroller2,
                                              onChanged: (String a) {
                                                setState(() {
                                                  print(a);
                                                  _pass =
                                                      a.trimLeft().trimRight();
                                                });
                                              },
                                              onFieldSubmitted: (String a) {
                                                setState(() {});
                                              },
                                              validator: (String? value) {
                                                if (value?.length == 0) {
                                                  return "value cannot be null";
                                                } //else if (value!.length > 0) {
                                                //if (value.length < 6)
                                                //return "password must have at least 6 characters";
                                                //}
                                                else
                                                  return null;
                                              },
                                            )
                                          ])))),
                        Step(
                          isActive: curstep == maxstep - 1 ? true : false,
                          title: Text('Confirmer'),
                          state: _formkey2.currentState?.validate() == true &&
                                  _formkey1.currentState?.validate() == true
                              ? StepState.complete
                              : StepState.indexed,
                          content: Container(
                              color: Colors.green.shade200,
                              //  color: Colors.black,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(Icons.arrow_circle_right,
                                      color: Colors.red),
                                  Text('$montant',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  Text('$code ${_destcontroller.text}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700))
                                ],
                              )),
                        ),
                      ],
                      onStepCancel: () {
                        setState(() {
                          if (curstep > 0) curstep -= 1;
                        });
                      },
                      onStepContinue: () {
                        setState(() {
                          if (curstep < maxstep - 1) curstep += 1;
                        });
                      },
                      onStepTapped: (int newstep) {
                        setState(() {
                          curstep = newstep;
                        });

                        ;
                      },
                      controlsBuilder:
                          (BuildContext context, ControlsDetails details) {
                        if (curstep == 0)
                          return Row(children: [
                            ElevatedButton(
                                onPressed: details.onStepContinue,
                                child: Text("Suivant"))
                          ]);
                        else if (curstep == maxstep - 1)
                          return Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(top: 150),
                              // color: Colors.yellow,
                              child: Center(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                    ElevatedButton(
                                        onPressed: () async {
                                          Future<bool>
                                              authenticate_before_sending() async {
                                            if (possibleuser != true) {
                                              try {
                                                await FirebaseAuth.instance
                                                    .signInWithEmailAndPassword(
                                                        email: tempemail
                                                            .trimLeft()
                                                            .trimRight(),
                                                        password: _pass
                                                            .trimLeft()
                                                            .trimRight());
                                                return true;
                                              } catch (error) {
                                                return false;
                                              }
                                            } else
                                              return authentication()
                                                  .authenticate()
                                                  .then((value) => value);
                                          }

                                          authenticate_before_sending()
                                              .then((value) {
                                            if (value) {
                                              try {
                                                print(
                                                    '${_destcontroller.text},${_dest}');
                                                Example_transaction
                                                    new_transaction =
                                                    Example_transaction(
                                                        sender,
                                                        //'${code} ${_destcontroller.text}',
                                                        receivername,
                                                        montant,
                                                        DateTime.now(),
                                                        'sortant');
                                                firestoreTransactions
                                                    .add(
                                                        new_transaction.todoc())
                                                    .whenComplete(() {
                                                  firestoreInstance
                                                      .doc(instance
                                                          .currentUser?.uid)
                                                      .update({
                                                    'balance': currentbalance -
                                                        (montant * (1 + taxe))
                                                  });

                                                  firestoreInstance
                                                      .doc(p)
                                                      .update({
                                                    'balance': receiverbalance +
                                                        montant
                                                  });

                                                  firestoreInstance
                                                      .doc(instance
                                                          .currentUser?.uid)
                                                      .collection(
                                                          'notifications')
                                                      .add(Notifications(
                                                              new_transaction,
                                                              'Vous avez envoye ${new_transaction.montant} a ${new_transaction.receveur}')
                                                          .tojson());

                                                  new_transaction.type =
                                                      'entrant';
                                                  firestoreInstance
                                                      .doc(p)
                                                      .collection(
                                                          'transactions')
                                                      .add(new_transaction
                                                          .todoc());
                                                  firestoreInstance
                                                      .doc(p)
                                                      .collection(
                                                          'notifications')
                                                      .add(Notifications(
                                                              new_transaction,
                                                              'Vous avez recu ${new_transaction.montant} de ${new_transaction.destinataire}')
                                                          .tojson());
                                                  firestoreInstance
                                                      .doc(p)
                                                      .get()
                                                      .then((value) {
                                                    SendNotification(
                                                        'transfert',
                                                        value.get('token'));
                                                  });

                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                            title: Text(
                                                                'Transaction fait avec succes'),
                                                            content: Container(
                                                                child: Text(
                                                                    "Merci d'avoir utilise Litcash")));
                                                      });
                                                  _formkey1.currentState
                                                      ?.reset();
                                                  _formkey2.currentState
                                                      ?.reset();
                                                  _emailcontroller.clear();
                                                  _destcontroller.clear();
                                                  montant = 0;
                                                  tempemail = '';
                                                  _usr = '';
                                                  _dest = '';
                                                }).onError((error, stackTrace) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                            title: Text(
                                                                "Transaction n ' a pas ete fait"),
                                                            content: Container(
                                                              child: Text(
                                                                  '$error'),
                                                            ));
                                                      });
                                                  return firestoreTransactions
                                                      .doc('');
                                                });
                                              } on FirebaseException catch (e) {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                          title:
                                                              Text("${e.code}"),
                                                          content: Container(
                                                            child: Text(
                                                                '${e.message}'),
                                                          ));
                                                    });
                                                print(e);
                                                result = e.code;
                                              }
                                            }
                                          });

                                          print('yes');
                                        },
                                        child: Center(

                                            //color: Colors.yellow,
                                            child: Text("Soumettre")))
                                  ])));
                        else
                          return Theme(
                              data: currenttheme,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                        onPressed: details.onStepContinue,
                                        child: Text("Suivant")),
                                    ElevatedButton(
                                        onPressed: details.onStepCancel,
                                        child: Text("retourner"))
                                  ]));
                      },
                    )))
                  ])
            : AlertDialog(
                title: Text('Vérification email'),
                content:
                    Text('Veuiller vérifier votre email dans les paramètres.')),
        resizeToAvoidBottomInset: false,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
