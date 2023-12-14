import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lcash/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lcash/modelpage.dart';
import 'package:lcash/phone.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'theme.dart';

int c = 6;
String? codee = '';
var n;

class Phoneconfirm extends StatefulWidget {
  Phoneconfirm({Key? key, String? ver = '', String? number = ''})
      : super(key: key) {
    codee = ver;
    n = number;
  }

  @override
  _PhoneconfirmState createState() => _PhoneconfirmState();
}

class _PhoneconfirmState extends State<Phoneconfirm> {
  final _formkey = GlobalKey<FormState>();
  String code = '';
  final _codecontroller = TextEditingController();
  @override
  void dispose() {
    _codecontroller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: currenttheme,
      home: Scaffold(
          appBar: AppBar(
              actions: [
                IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.home),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              MyApp(c: instance.currentUser)));
                    })
              ],
              title: Text(
                'Litcash',
                style: GoogleFonts.pacifico(fontSize: 28, color: Colors.blue),
              ),
              primary: true,
              backgroundColor: Colors.white),
          //backgroundColor: Colors.grey,
          body: Column(
            children: [
              Text(
                'Phone Confirmation',
                textAlign: TextAlign.center,
                style: buttonsfonts,
              ),
              Form(
                key: _formkey,
                child: Container(
                    width: 292.7,
                    child: PinCodeTextField(
                      controller: _codecontroller,
                      keyboardType: TextInputType.number,
                      appContext: context,
                      length: c,
                      onChanged: (x) async {
                        code = x;
                        print('usercode=$x vraiecode=$c');
                      },
                      onCompleted: (text) async {
                        //  final instance2 = FirebaseAuth.instance;
                        /*if (text.compareTo(c) == 0)
                          await instance.currentUser!
                              .linkWithPhoneNumber(phone!)
                              .then((value) => Navigator.of(context).pop());
                              */
                      },
                      validator: (x) {
                        if (x!.isEmpty)
                          return 'Entrer le code qu on vous a envoye';
                        return null;
                        // if (x.compareTo(c) != 0) return 'code incorrect';
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    )),
              ),
              TextButton(
                  child: Text('validate'),
                  onPressed: () async {
                    _codecontroller.clear();
                    final instance2 = FirebaseAuth.instance;
                    try {
                      await instance
                          .signInWithCredential(PhoneAuthProvider.credential(
                              verificationId: tempcode,
                              smsCode: _codecontroller.text))
                          .then((value) async {
                        await instance.currentUser!
                            .linkWithPhoneNumber(n)
                            .then((value) => Navigator.of(context).pop());
                        print('@@@${value}');
                      });
                    } on FirebaseException catch (e) {
                      print('@@@error${e.code}');
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: Text('e.code'),
                                content: Text('${e.message!}\n$tempcode'));
                          });
                    }
                  }),
              TextButton(
                  onPressed: () async {
                    _codecontroller.clear();

                    print(countrycode + temphone);
                    await instance.verifyPhoneNumber(
                        timeout: const Duration(seconds: 30),
                        forceResendingToken: resend,
                        phoneNumber: countrycode + temphone,
                        verificationCompleted: (h) {
                          // print(h.smsCode);
                          firestoreInstance
                              .doc(instance.currentUser?.uid)
                              .update({'phone': countrycode + temphone});
                          instance.currentUser!.updatePhoneNumber(h);

                          Navigator.of(context).pop();
                          setState(() {
                            instance.currentUser!.reload();
                          });
                        },
                        verificationFailed: (exception) {
                          print(exception);
                        },
                        codeSent: (codesent, [forceResendingToken]) {
                          tempcode = codesent;
                          setState(() {
                            tempcode = codesent;
                          });
                          print('newone $tempcode');

                          // i = u.smsCode;

                          // print('*****$tempcode*****');
                          // print('**maybe$i*****');
                        },
                        codeAutoRetrievalTimeout: (coderetrieval) {
                          tempcode = coderetrieval;
                          setState(() {
                            tempcode = coderetrieval;
                          });
                          print('after$coderetrieval');
                        });
                  },
                  child: Text('resend code'))
            ],
          )),
      debugShowCheckedModeBanner: false,
    );
  }
}
