
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lcash/main.dart';
import 'package:lcash/theme.dart';

class authentication {
  LocalAuthentication auth = LocalAuthentication();
  Future<bool> supported() async {
    return await auth.canCheckBiometrics;
  }

  Future<List<BiometricType>> available() async {
    return await auth.getAvailableBiometrics();
  }

  Future<bool> authenticate() async {
    return await auth.authenticate(
        localizedReason: 'Veuiller vous authentifier',
        options: AuthenticationOptions(stickyAuth: true));
  }
}

arthur() async {
  await firestoreTransactions.get().then((value) {
    print('done');
    //lists = value.size;
    if (value.size > 1) firestoreTransactions.doc('first').delete();
  });
}

update() {
  // print(instance.currentUser?.uid);
  firestoreTransactions = firestoreInstance
      .doc(instance.currentUser?.uid)
      .collection('transactions');
}

bool isPasswordCompliant(String password, [int minLength = 6]) {
  if (password.isEmpty) {
    return false;
  }

  bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
  bool hasDigits = password.contains(new RegExp(r'[0-9]'));
  bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
  bool hasSpecialCharacters =
      password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>+-]'));
  bool hasMinLength = password.length > minLength;

  return hasDigits &
      hasUppercase &
      hasLowercase &
      hasSpecialCharacters &
      hasMinLength;
}

String strongpassw(String p) {
  // ignore: unused_local_variable
  int minlength = 6,
      l = p.length,
      digits = 0,
      lower = 0,
      upper = 0,
      symbols = 0;
  String re = 'abcdefghijklmnopqrstuvwxyz';
  bool hasMinLength = l > minlength;
  for (int h = 0; h < l; h++) {
    if (re.contains(p[h]))
      lower += 1;
    else if (re.toUpperCase().contains(p[h]))
      upper += 1;
    else if ('1,2,3,4,5,6,7,8,9,0'.contains(p[h]))
      digits += 1;
    else
      symbols += 1;
  }
  if (lower > 0 && upper > 0 && digits > 0 && symbols == 0)
    return 's';
  else if (lower > 0 && upper > 0 && digits == 0 && symbols > 0)
    return 'd';
  else if (lower > 0 && upper == 0 && digits > 0 && symbols > 0)
    return 'u';
  else if (lower == 0 && upper > 0 && digits > 0 && symbols > 0)
    return 'l';
  else if (lower > 0 && upper > 0 && digits > 0 && symbols > 0 && l < minlength)
    return 'len';
  else if (lower == 0 ||
      upper == 0 ||
      digits == 0 ||
      symbols == 0 ||
      l < minlength)
    return 'all';
  else
    return 'good';
}

var firestoreInstance = FirebaseFirestore.instance.collection('users'),
    blockedusers = FirebaseFirestore.instance.collection('blockedusers'),
    agents = FirebaseFirestore.instance.collection('agents'),
    probs = FirebaseFirestore.instance.collection('problems'),
    firestoreMotifsupression =
        FirebaseFirestore.instance.collection('motifsuppression');

Future agent(String personuid) async {
  var solution, uid;
  solution = agents.get().then((querysnapshot) {
    var snapshots = querysnapshot.docs;
    for (int h = 0; h < snapshots.length; h++) {
      try {
        // print('${snapshots[h].id}     ${personuid}');
        if (personuid.compareTo(snapshots[h].id) == 0) {
          uid = snapshots[h].id;
          // print(uid);
          return uid;
        }
      } catch (e) {}
    }
  });

  return solution;
}

Future verify(CollectionReference database, String info, String from) async {
  var solution, personuid;
  personuid = database.get().then((querysnapshot) {
    solution = querysnapshot.docs;
    for (int h = 0; h < solution.length; h++) {
      try {
        //print(solution[h].get('phone'));
        if (info.compareTo(solution[h].get(from)) == 0) {
          personuid = solution[h].id;

          //setState(() {});

          // receiverbalance = solution[h]
          //   .get('balance');
          //print('yes${solution[h].id} ${solution[h].get('balance')}');

          return personuid;
        }
      } catch (e) {}
    }
  });

  try {
    if (personuid == null) solution = 'not found';
    return personuid;
  } catch (e) {
    return 'not found';
  }
//  return solution;
}

Future blockuser(String personuid) async {
  var solution, uid;
  solution = blockedusers.get().then((querysnapshot) {
    var snapshots = querysnapshot.docs;
    for (int h = 0; h < snapshots.length; h++) {
      try {
        // print('${snapshots[h].id}     ${personuid}');
        if (personuid.compareTo(snapshots[h].id) == 0) {
          uid = snapshots[h].id;
          // print(uid);
          return uid;
        }
      } catch (e) {}
    }
  });

  return solution;
}

Future getdata(CollectionReference<Map<String, dynamic>> collecrefe,
    String? iddoc, String value) async {
  var collectrefe = firestoreInstance;
  var docSnapshot = await collecrefe.doc(iddoc).get();
  Map<String, dynamic>? data = docSnapshot.data();
  //print(data?[value]);
  //return data?[value];
}

dynamic updateuserinfofirebase(
  String field,
  String newvalue,
) async {
  User? user = instance.currentUser;
  if (field.compareTo('nom') == 0 || field.compareTo('prenom') == 0) {
    try {
      await firestoreInstance.doc(user?.uid).update({field: newvalue});

      /*if (field.compareTo('nom') == 0) {
        await user?.updateDisplayName(
            '${newvalue} ${getdata(firestoreInstance, user.photoURL, 'prenom')} ');
      } else {
        await user?.updateDisplayName(
            '${getdata(firestoreInstance, user.photoURL, 'nom')} ${newvalue}');
      }*/
      // print(user?.displayName);
    } catch (e) {
      // print(e);
      return e;
    }
  } else if (field.compareTo('datenaissance') == 0) {
    try {
      await firestoreInstance
          .doc(instance.currentUser?.uid)
          .update({field: newvalue});
    } catch (e) {
      // print(e);
      return e;
    }
  } else if (field.compareTo('email') == 0) {
    try {
      //instance.currentUser!
      //  .sendEmailVerification()
      //.then((value) {
      await user?.verifyBeforeUpdateEmail(newvalue).then((value) async {
        await firestoreInstance
            .doc(user.uid)
            .update({field: newvalue}).whenComplete(() {
          instance.signOut();
        });
      });
      //instance.currentUser!
      //   .updateEmail(tempemail),
      // email = tempemail

      // });

      return 1;
    } catch (e) {
      // print(e);
      return e;
    }
    //Navigator.of(context).push(MaterialPageRoute(
    //  builder: (context) => Confirmemail()));

  }

  instance.currentUser?.reload();
}

class Client {
  String username = '',
      nom = '',
      prenom = '',
      addresse = '',
      id = '',
      sexe = '',
      phone = '',
      password = '',
      email = '',
      pays = '',
      datenaissance = '',
      cin = '',
      position = '';
  bool status = false;
  List<Example_transaction> transactions = [];

  double balance = 0.0;
  Client(
    this.email,
    this.password, {
    this.username = '',
    this.id = '',
    this.sexe = '',
    this.phone = '',
    this.pays = '',
    this.nom = '',
    this.prenom = '',
    this.addresse = '',
    this.datenaissance = '',
    this.cin = '',
    this.position = '',
    this.status = false,
    this.balance = 0.0,
  });
  dynamic todoc() {
    return {
      'email': this.email,
      'password': this.password,
      'username': '',
      'id': '',
      'nom': this.nom,
      'prenom': this.prenom,
      'addresse': '',
      'sexe': '',
      'phone': '',
      'pays': '',
      'datenaissance': this.datenaissance,
      'cin': '',
      'position': '',
      'status': false,
      'balance': 0.0
    };
  }

  Object? clientfromjason(Map<String, dynamic> jsonn) {
    var xx = Client(jsonn['email'], jsonn['password']);
    return xx;
  }
}

var maincolor = Colors.amber;
final buttonsfonts = GoogleFonts.aclonica(),
    titlefonts =
        GoogleFonts.pacifico(fontSize: 20.0, fontWeight: FontWeight.bold),
    fontbuttons = GoogleFonts.aclonica(color: Colors.black);
ThemeData theme2 = ThemeData(
    dividerColor: maincolor,
    dialogBackgroundColor: Colors.white,
    unselectedWidgetColor: Colors.white,
    indicatorColor: Colors.amber,
    appBarTheme: AppBarTheme(
        actionsIconTheme: IconThemeData(color: maincolor),
        backgroundColor: Colors.white,
        titleTextStyle: GoogleFonts.pacifico(
            fontSize: 28.0, fontWeight: FontWeight.bold, color: maincolor)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        unselectedItemColor: Colors.black,
        unselectedLabelStyle: TextStyle(color: Colors.black),
        unselectedIconTheme: IconThemeData(color: Colors.black, size: 25),
        backgroundColor: Colors.white,
        selectedIconTheme: IconThemeData(color: maincolor, size: 25),
        selectedItemColor: Colors.amber,
        selectedLabelStyle: TextStyle(color: maincolor)),
    listTileTheme: ListTileThemeData(
        selectedTileColor: maincolor,
        iconColor: maincolor,
        textColor: maincolor),
    textTheme: TextTheme(
        // button: GoogleFonts.aclonica(color: Colors.white),
        //subtitle2: GoogleFonts.aclonica(color: Colors.tealAccent),
        //subtitle1: GoogleFonts.aclonica(color: Colors.tealAccent),
        // overline: GoogleFonts.aclonica(color: maincolor),
        // bodyText1: GoogleFonts.aclonica(color: Colors.red),
        //bodyText2: GoogleFonts.pacifico(
        //  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
        //caption: GoogleFonts.pacifico(color: Colors.amber),
        //headline1: GoogleFonts.aclonica(color: Colors.white),
        // headline2: GoogleFonts.aclonica(color: Colors.pinkAccent),
        headlineMedium: GoogleFonts.aclonica(color: Colors.purple),
        headlineSmall: GoogleFonts.aclonica(color: Colors.green),
        displaySmall: GoogleFonts.aclonica(color: Colors.blue),
        titleLarge: GoogleFonts.aclonica(color: Colors.amber)),
    iconTheme: IconThemeData(color: maincolor),
    hintColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: maincolor,
    brightness: Brightness.light,
    primarySwatch: maincolor);

PreferredSizeWidget wappBarmodel(BuildContext c) {
  var y = AppBar(
    iconTheme: currenttheme.iconTheme,
    actions: [
      IconButton(
          //color: Colors.black,
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.of(c).push(MaterialPageRoute(
                builder: (context) => MyApp(c: instance.currentUser)));
          })
    ],
    title: Text(
      'Litcash',
      style:
          GoogleFonts.pacifico(color: currenttheme.primaryColor, fontSize: 28),
    ),
    primary: true,
  );

  return y;
}

class Example_transaction {
  String destinataire = '', receveur = '', type = '';
  double montant = 0;
  var date = DateTime.now();
  Example_transaction(
      this.destinataire, this.receveur, this.montant, this.date, this.type);
  Example_transaction.unamed() {
    destinataire = '';
    receveur = '';
    type = '';
    montant = 0;
  }
  dynamic todoc() {
    return {
      'destinataire': this.destinataire,
      'receveur': this.receveur,
      'montant': this.montant,
      'date':
          '${this.date.year}-${this.date.month.toString().padLeft(2, '0')}-${this.date.day.toString().padLeft(2, '0')}',
      'type': this.type,
      'heure':
          '${this.date.hour.toString().padLeft(2, '0')}:${this.date.minute.toString().padLeft(2, '0')}',
      'seconds_passed': this.date.microsecondsSinceEpoch
    };
  }

  dynamic getid(String data) {}
}

class Notifications {
  String message = '';
  Example_transaction nouveau_transaction = Example_transaction.unamed();
  Notifications(this.nouveau_transaction, this.message);

  dynamic tojson() {
    return {
      'destinataire': nouveau_transaction.destinataire,
      'receveur': nouveau_transaction.receveur,
      'montant': nouveau_transaction.montant,
      'date':
          '${nouveau_transaction.date.year}-${nouveau_transaction.date.month.toString().padLeft(2, '0')}-${nouveau_transaction.date.day.toString().padLeft(2, '0')}',
      'type': nouveau_transaction.type,
      'message': this.message,
      'heure':
          '${this.nouveau_transaction.date.hour.toString().padLeft(2, '0')}:${this.nouveau_transaction.date.minute.toString().padLeft(2, '0')}',
      'seconds_passed': this.nouveau_transaction.date.microsecondsSinceEpoch
    };
  }

  Notifications fromjson(Map<String, dynamic> json) {
    return Notifications(
        Example_transaction(
            json['destinataire'],
            json['receveur'],
            json['montant'],
            (json['date'] as Timestamp).toDate(),
            json['type']),
        json['message']);
  }
}

final _codecontroller = TextEditingController();

void sortbyincreasingdate(List<Example_transaction> x) {
  x.sort((Example_transaction u, Example_transaction v) {
    if (u.date.year > v.date.year)
      return 1;
    else if (u.date.year < v.date.year)
      return -1;
    else {
      if (u.date.month > v.date.month)
        return 1;
      else if (u.date.month < v.date.month)
        return -1;
      else if (u.date.day > v.date.day)
        return 1;
      else if (u.date.day < v.date.day)
        return -1;
      else
        return 0;
    }
  });
}

void sortbydecreasingdate(List<Example_transaction> x) {
  x.sort((Example_transaction u, Example_transaction v) {
    if (u.date.year < v.date.year)
      return 1;
    else if (u.date.year < v.date.year)
      return -1;
    else {
      if (u.date.month < v.date.month)
        return 1;
      else if (u.date.month > v.date.month)
        return -1;
      else if (u.date.day < v.date.day)
        return 1;
      else if (u.date.day > v.date.day)
        return -1;
      else
        return 0;
    }
  });
}

SnackBar show(String message) {
  return SnackBar(
      content: Text(
    message,
    style: TextStyle(color: Colors.amber),
  ));
}

bool validateStructure(String value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~,.-_+=()&%^?/\{}]).{8,}$';
  RegExp regExp = new RegExp(pattern);
  return regExp.hasMatch(value);
}

Widget Wparametresbuttons(TextButton xx) {
  return ListTile(
    subtitle: Divider(color: Colors.white),
    contentPadding: const EdgeInsets.only(bottom: 20),
    title: xx,
  );
}

Future<void> linkGoogle() async {
  // Trigger the Google Authentication flow.
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  possibleuser = true;
  // Obtain the auth details from the request.
  final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;
  // Create a new credential.
  final OAuthCredential googleCredential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Sign in to Firebase with the Google [UserCredential].
  final UserCredential googleUserCredential = await FirebaseAuth.instance
      .signInWithCredential(googleCredential)
      .then((value) async {
    instance.currentUser?.reload();
    print(value.additionalUserInfo?.profile);

    await verify(firestoreInstance, value.user!.email!, 'email').then((value2) {
      if (value2 == null) {
        Client x = Client(value.user!.email!, '',
            //  , tempassword,

            nom: value.additionalUserInfo?.profile?['family_name'],
            prenom: value.additionalUserInfo?.profile?['given_name'],
            balance: 0.0);

        firestoreInstance
            .doc(instance.currentUser?.uid)
            .set(x.todoc())
            .then((value2) {
          /*_emailcontroller.clear();
                                            _nomcontroller.clear();
                                            _prenomcontroller.clear();
                                            _passwordcontroller.clear();
                                            _confirmpasswordcontroller.clear();
                                            */
          try {
            var transactionsref = firestoreInstance
                .doc(value.user?.uid)
                .collection('transactions');
            transactionsref.doc('first').set({
              'date': '9999-11-12',
              'destinataire': 'first',
              'montant': -99,
              'receveur': 'first',
              'type': 'sortant'
            });
            var notificationsref = firestoreInstance
                .doc(instance.currentUser?.uid)
                .collection('notifications');
            notificationsref.doc('first').set({
              'date': '9999-11-12',
              'destinataire': 'first',
              'montant': -99,
              'receveur': 'first',
              'type': 'sortant',
              'message': 'nothing'
            });
          } on FirebaseException catch (e) {
            /* setState(() {});
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      content: Text(e.message!),
                                                      title: Text(e.code),
                                                    );
                                                  });
                                                  */
            //  print(e);
            // result = e.code;
            return e;
          }
        });
      }
    });
    firestoreNotifications = firestoreInstance
        .doc(instance.currentUser?.uid)
        .collection('notifications');
    firestoreTransactions = firestoreInstance
        .doc(instance.currentUser?.uid)
        .collection('transactions');
    return value;
  });
}

Future<String> connectGoogle() async {
  String result = '';
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  possibleuser = true;
  // Obtain the auth details from the request.
  final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;
  // Create a new credential.
  final OAuthCredential googleCredential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Sign in to Firebase with the Google [UserCredential].

  try {
    await FirebaseAuth.instance.signInWithCredential(googleCredential);
  } on FirebaseAuthException catch (error) {
    print('###${error.code}');
    String blockeduser = '';
    if (error.code.compareTo('wrong-password') == 0) {
      {
        tentatives -= 1;
      }
      if (tentatives == 0 || error.code.compareTo('too-many-requests') == 0) {
        try {
          blockedusers.doc(blockeduser).set({'nom': 'nothing'});
        } on FirebaseException catch (e) {
          print(e);
        }
      }
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
  return result;
}
