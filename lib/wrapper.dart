import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'modelpage.dart';
import 'connect.dart';
import 'main.dart';

//String result2 = '';
int aa = 5, bb = 2;

class wrap extends StatefulWidget {
  wrap({Key? key}) : super(key: key);

  @override
  _wrapState createState() => _wrapState();
}

class _wrapState extends State<wrap> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    dynamic person = _auth.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {});
      if (user == null) {
        //  print('User is currently signed out!');
        // a = Connect();

      } else {
        /*user.delete();
        print('User is signed in!');
        blockuser(user.uid).then((value3) {
          result2 = value3 == null ? 'not found' : value3;
          // print(result2);
          setState(() {});
          //print('####${result2}###');
        });
        setState(() {});
        a = MyApp(c: user);
      print(user.uid); */
      }

      // blockuser(user!.uid).then((value3) {
      // result2 = value3 == null ? 'not found' : value3;
      // print(result2);

      //print('####${result2}###');
      //});
    });

    if (person != null)
      try {
        /* if (result2.length > 9)
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                  body: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text(
                      'Votre compte a ete bloque car vous avez entre 3 mot de passe incorrects ',
                      style: fontbuttons,
                    ),
                    TextButton(
                        onPressed: () {
                          result2 = '';
                          instance.signOut();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Connect()));
                        },
                        child: const Text("Connecter avec un autre compte"),
                        style: const ButtonStyle(
                            alignment: Alignment.bottomCenter))
                  ]))); */
        //   else {
        /*    if ((instance.currentUser?.phoneNumber == null ||
                instance.currentUser!.phoneNumber!.isEmpty) &&
            (instance.currentUser != null))
          return MaterialApp(debugShowCheckedModeBanner: false, home: Phone());
        //if (newuser != null) instance.signInWithCredential(newuser!);
        else { */
        //  String? phone = instance.currentUser!.phoneNumber;
        //if (phone == null) instance.signInWithCredential(newuser!);

        // {
        firestoreNotifications = firestoreInstance
            .doc(instance.currentUser?.uid)
            .collection('notifications');
        firestoreTransactions = firestoreInstance
            .doc(instance.currentUser?.uid)
            .collection('transactions');
        return MaterialApp(
          initialRoute: '/',
          //  routes: {
          //   '/Notification_page': (context) => const Historiquetransactions()
          //},
          home: Scaffold(
              body: MyApp(
            c: person,
          )),
          debugShowCheckedModeBanner: false,
        );
        //}
        // }
      } catch (error) {
        return MaterialApp(
            home: Scaffold(
                body: MaterialApp(
          home: Connect(),
          debugShowCheckedModeBanner: false,
        )));
      }
    else {
      setState(() {});
      return MaterialApp(
        home: Connect(),
        debugShowCheckedModeBanner: false,
      );
    }
  }
}
