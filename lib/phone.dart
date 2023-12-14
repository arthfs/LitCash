import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'theme.dart';
import 'modelpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lcash/main.dart';
import 'phoneconfirmation.dart';

String temphone = '', countrycode = '+509';
String tempcode = '';
int? resend;

var u;

class Phone extends StatefulWidget {
  Phone({Key? key}) : super(key: key);

  @override
  _PhoneState createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  int done = 0;
  String p = 'not found';
  String? phone = instance.currentUser!.phoneNumber;
  final _phonecontroller = TextEditingController();
  String code = '';
  final _formkey1 = GlobalKey<FormState>(), _formkey2 = GlobalKey<FormState>();
  //final FirebaseAuth auth = FirebaseAuth.instance;
  final _codecontroller = TextEditingController();

  @override
  void dispose() {
    _phonecontroller.dispose();
    _phonecontroller.dispose();
    _codecontroller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: currenttheme,
      home: Scaffold(
        appBar: AppBar(
            // iconTheme: currenttheme.iconTheme,
            /*actions: [
      IconButton(
          //color: Colors.black,
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.of(c).push(MaterialPageRoute(
                builder: (context) => MyApp(c: instance.currentUser)));
          })
    ]*/
            title: Text(
              'Litcash',
              style: GoogleFonts.pacifico(
                fontSize: 28,
                color: currenttheme.primaryColor,
              ),
            ),
            primary: true,
            backgroundColor: Colors.white),
        //backgroundColor: Colors.grey,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Phone \n\n",
              style: titlefonts,
            ),
            Form(
              key: _formkey1,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      height: 50,
                      /*   decoration: BoxDecoration(
                          border:
                              Border.all(width: 3, style: BorderStyle.solid)),
                              */
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Phone : ',
                              style: buttonsfonts,
                            ),
                            Text(
                              "$phonenumber",
                              style: buttonsfonts,
                              textAlign: TextAlign.start,
                            )
                          ]),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 500,
                      child: IntlPhoneField(
                        dropdownDecoration:
                            BoxDecoration(shape: BoxShape.rectangle),
                        initialCountryCode: 'HT',
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(','),
                          FilteringTextInputFormatter.deny('.'),
                          FilteringTextInputFormatter.deny('-'),
                          FilteringTextInputFormatter.deny(' '),
                        ],
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          labelText: 'numero de telephone',
                        ),
                        // controller: _destcontroller,

                        onChanged: (a) {
                          setState(() {
                            temphone = a.number.trimRight().trimLeft();
                            //print(a);
                          });
                          if (phone != null)
                            print(phone);
                          else
                            print('newone');
                        },
                        onCountryChanged: (newcountryphone) {
                          setState(() {
                            countrycode = newcountryphone.fullCountryCode;
                          });
                        },

                        validator: (value) {
                          verify(
                                  firestoreInstance,
                                  countrycode + temphone.trimLeft().trimRight(),
                                  'phone')
                              .then((value3) {
                            setState(() {
                              p = value3 == null ? 'not found' : value3;
                              // print(p);
                            });

                            //print("$p   $countrycode$temphone");
                          });
                          //if (value!.length < done) return "Numero invalide";
                          if (instance.currentUser?.phoneNumber !=
                              null) if (temphone.compareTo(instance
                                      .currentUser?.phoneNumber as String) ==
                                  0 &&
                              (temphone.isNotEmpty))
                            return "N' entrez pas votre numero de telephone";
                          if (value!.number.isEmpty)
                            return 'Entrer votre numero de telephone';
                          if (p.length > 9)
                            return 'Ce numero de telephone est deja pris';
                          else
                            return null;
                        },
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          if (_formkey1.currentState!.validate()) {
                            print(countrycode + temphone);
                            await instance
                                .verifyPhoneNumber(
                                    timeout: const Duration(seconds: 60),
                                    forceResendingToken: 1,
                                    phoneNumber: countrycode + temphone,
                                    verificationCompleted: (h) async {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                title: Text('Succes'),
                                                content: Text(
                                                    'verification reussie\n'));
                                          });
                                      await instance.currentUser!
                                          .updatePhoneNumber(h);

                                      await firestoreInstance
                                          .doc(user?.uid)
                                          .update({
                                        'phone': countrycode + temphone
                                      });

                                      // print(h.smsCode);

                                      /*firestoreInstance
                                          .doc(instance.currentUser?.uid)
                                          .update({
                                        'phone': countrycode + temphone
                                      });*/
                                      /* Navigator.of(context).pop();
                                      setState(() {
                                        instance.currentUser!.reload();
                                      }); */
                                    },
                                    verificationFailed: (exception) {
                                      // print("@@$exception");
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                title: Text(exception.code),
                                                content: Text(
                                                    '${exception.message}\n'));
                                          });
                                    },
                                    codeSent: (codesent,
                                        [forceResendingToken]) {
                                      setState(() {
                                        resend = forceResendingToken;
                                        tempcode = codesent;
                                      });

                                      //  i = u.smsCode;
                                      // print('*****$tempcode*****');
                                      //print('**maybe$i*****');
                                    },
                                    codeAutoRetrievalTimeout: (coderetrieval) {
                                      setState(() {
                                        tempcode = coderetrieval;
                                      });
                                      //  print('after$tempcode');
                                      /*      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Phoneconfirm(
                                                    number:
                                                        countrycode + temphone,
                                                    ver: tempcode,
                                                  )));
                                                  */
                                    })
                                .then((value) {
                              setState(() {});
                            });
                          }
                          //  setState(() {
                          //   instance.currentUser?.reload();
                          // });
                        },
                        child: Text('Enregistrer',
                            style: TextStyle(fontWeight: FontWeight.bold)))
                  ]),
            ),
            Form(
                key: _formkey2,
                child: Container(
                    width: 292.7,
                    child: PinCodeTextField(
                      controller: _codecontroller,
                      keyboardType: TextInputType.number,
                      appContext: context,
                      length: c,
                      onChanged: (x) async {
                        code = x;
                        //print('usercode=$x vraiecode=$c');
                      },
                      onCompleted: (text) async {
                        try {
                          PhoneAuthCredential value =
                              await PhoneAuthProvider.credential(
                                  verificationId: tempcode,
                                  smsCode: _codecontroller.text);
                          firestoreInstance.doc(user?.uid).update(
                              {'phone': countrycode + temphone}).then((value2) {
                            return instance.currentUser
                                ?.updatePhoneNumber(value);
                          });

                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: Text('Succes'),
                                    content: Text('Vérification réussie\n'));
                              });
                          /* await instance.currentUser!
                              .linkWithPhoneNumber(countrycode + temphone)
                             .then((value) => Navigator.of(context).pop());
                          await firestoreInstance
                              .doc(user?.uid)
                              .update({'phone': countrycode + temphone}); */
                          // setState(() {});
                          //  print('@@@${value}');
                        } on FirebaseException catch (e) {
                          // print('@@@error${e.code}');
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: Text('Error ${e.code}'),
                                    content: Text('${e.message!}\n'));
                              });
                        }
                      },
                      validator: (x) {
                        if (x!.isEmpty)
                          return "Entrer le code qu'on vous a envoyé";
                        return null;
                        // if (x.compareTo(c) != 0) return 'code incorrect';
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ))),
            TextButton(
                onPressed: () async {
                  _codecontroller.clear();

                  print(countrycode + temphone);
                  await instance.verifyPhoneNumber(
                      timeout: const Duration(seconds: 60),
                      forceResendingToken: resend,
                      phoneNumber: countrycode + temphone,
                      verificationCompleted: (h) async {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text('Succes'),
                                  content: Text('verification reussie\n'));
                            });
                        await instance.currentUser!
                            .updatePhoneNumber(h)
                            .then((value) async {
                          await firestoreInstance
                              .doc(user?.uid)
                              .update({'phone': countrycode + temphone});
                        });
                      },
                      verificationFailed: (exception) {
                        //print("@@$exception");
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text(exception.code),
                                  content: Text('${exception.message}\n'));
                            });
                      },
                      codeSent: (codesent, [forceResendingToken]) {
                        tempcode = codesent;
                        setState(() {
                          tempcode = codesent;
                        });
                        // print('newone $tempcode');

                        // i = u.smsCode;

                        // print('*****$tempcode*****');
                        // print('**maybe$i*****');
                      },
                      codeAutoRetrievalTimeout: (coderetrieval) {
                        tempcode = coderetrieval;
                        setState(() {
                          tempcode = coderetrieval;
                        });
                        //  print('after$coderetrieval');
                      });
                },
                child: Text(
                  'Renvoyer le code',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))
          ],
        ),
        resizeToAvoidBottomInset: true,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
