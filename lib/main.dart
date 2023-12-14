// ignore_for_file: unused_field

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'package:timezone/data/latest.dart' as tz;
import 'notifications.dart';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'pushnotifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lcash/wrapper.dart';
import 'package:share_plus/share_plus.dart';
import 'theme.dart';
import 'package:flutter/material.dart';
import 'modelpage.dart';
import 'testenvoyer.dart';
import 'menu.dart';
import 'package:http/http.dart' as http;

Future<void> onbackground_messagae(RemoteMessage message) async {
  print('message received in background');
}

bool possibleuser = false;
int tentatives = 3;
var currentbalance = 600.0, currentpass = '', phonenumber = '';
var firestoreTransactions =
    firestoreInstance.doc(instance.currentUser?.uid).collection('transactions');
var firestoreNotifications = firestoreInstance
    .doc(instance.currentUser?.uid)
    .collection('notifications');

String? fullname = instance.currentUser?.displayName == null
    ? ''
    : instance.currentUser?.displayName;
Future fun() async {
  await getdata(firestoreInstance, 'users', 'nom').then((value) {
    fullname = value;
    print(value);
  });
}

/*objectostring(Object? o) {
  Client k = jsonDecode(o.toString());

  return k.nom;
}
*/
/*funn() {
  firestoreInstance
      .doc(instance.currentUser?.uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      print('Document data: ${documentSnapshot.data()}');
      fullname = objectostring(documentSnapshot.data());
    } else {
      print('Document does not exist on the database');
    }
  });
} */
bool status = false;
authentication possible = authentication();
verifyauth() {
  possible.authenticate().then((value) {
    status = value;
  });
}

updategoogle() {
  GoogleSignIn().isSignedIn().then((value) {
    possibleuser = value;
    //print(value);
  });
//  print(possibleuser);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load();
  } catch (e) {
    print("@@@@ ${e}");
  }
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: dotenv.env['Firebase_apiKey']!,
          appId: dotenv.env["Firebase_appId"]!,
          messagingSenderId: dotenv.env["Firebase_messagingSenderId"]!,
          projectId: dotenv.env['Firebase_projectId']!));

  tz.initializeTimeZones();
  FlutterNativeSplash.remove();
  /*int aa = 2;
  if (instance.currentUser!.phoneNumber != null ||
      instance.currentUser!.phoneNumber!.isEmpty) {
    print(4);
    print(instance.currentUser!.phoneNumber);
    runApp(Phone());
  } else */
  FirebaseMessaging.onBackgroundMessage(onbackground_messagae);
  LocalNotification.initialize();
  runApp(wrap());
//  FirebaseMessaging.;
}

SendNotification(String title, String token) async {
  final data = {
    "click_action": "FLUTTER_NOTIFICATION_CLICK",
    "id": "1",
    "status": "done",
    "message": title
  };
  try {
    http.Response response =
        await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
            headers: <String, String>{
              "Content-Type": "application/json",
              "Authorization":
                  "key=" + dotenv.env['Notification_authorization_key']!
            },
            body: json.encode(<String, dynamic>{
              "notification": <String, dynamic>{
                "title": "new notification",
                "body": "qwertyuio"
              },
              "sound": "true",
              "priority": "high",
              'importance': "max",
              "data": data,
              "to": token
            }));

    if (response.statusCode == 200)
      print('notification successfully sended');
    else
      print('error ${response.statusCode}');
    print('${response.body}');
    print(response.reasonPhrase);
  } catch (e) {
    print(e);
  }
}

//final firestoreInstance = FirebaseFirestore.instance.collection('users');
FirebaseAuth instance = FirebaseAuth.instance;
User? user = instance.currentUser;

class MyApp extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyApp({Key? key, User? c}) : super(key: key) {
    user = c;
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
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  RemoteMessage testt = RemoteMessage(
      notification: RemoteNotification(
          title: 'arthur',
          body: 'nothing',
          android: AndroidNotification(
              priority: AndroidNotificationPriority.highPriority,
              channelId: 'mychanel')));
  FirebaseMessaging firebase_messaging = FirebaseMessaging.instance;

  var _currentPage = 0;
  var notificationStream = firestoreNotifications.snapshots();
  User? _y;

  // ignore: prefer_final_fields

  final Stream<DocumentSnapshot> documentStream = firestoreInstance
      .doc(instance.currentUser?.uid)
      .snapshots()
      .handleError((e) {
    return firestoreInstance.doc('first id').snapshots();
  });
  late StreamSubscription<ConnectivityResult> subscription;
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      notif_subscription;
  storenotificationtoken() async {
    firebase_messaging.getToken().then((value) => firestoreInstance
        .doc(instance.currentUser?.uid)
        .update({'token': value}));
  }

  @override
  void initState() {
    super.initState();

    subscription = Connectivity().onConnectivityChanged.listen((event) {
      var hasconnection = SnackBar(
        content: Text(
          'Connection',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 4),
      );
      var noconnetion = SnackBar(
        content: Text(
          'No connection',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      );
      if (event == ConnectivityResult.wifi ||
          event == ConnectivityResult.mobile)
        ScaffoldMessenger.of(context).showSnackBar(hasconnection);
      else
        ScaffoldMessenger.of(context).showSnackBar(noconnetion);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print('Firebamessaging.getIntialmessage');
      if (message != null) {
        print('new notification');
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      if (event.notification != null) {
        print(event.notification!.title);
        print(event.notification!.body);
        //print('message.detail ${event.data}');
        LocalNotification.show(event);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('message opened');
//flutter build apk --obfuscate --split-debug-info=/lcash/arthur
      _currentPage = 1;
    });
    storenotificationtoken();
  }
  //ScaffoldMessenger.of(context).showSnackBar(hasconnection);

  @override
  void dispose() {
    super.dispose();

    subscription.cancel();
  }

  /*void initConnectivity() {
    Connectivity myconnectivity = Connectivity();

    myconnectivity.checkConnectivity().then((value) {
      print("@@@@{$value}@@@@");
    }); } */

  Widget build(BuildContext context) {
    /* notif_subscription = notificationStream
        .listen((QuerySnapshot<Map<String, dynamic>> newnotif) {
      if (newnotif.docs.last.get('type').toString() == 'entrant')
        LocalNotification().show('nouveau_message');
      print('er');
    });
    */

    return StreamBuilder<DocumentSnapshot>(
        stream: documentStream,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            instance.signOut();

            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          currentbalance = snapshot.data?.get('balance') as double;
          currentpass = snapshot.data?.get('password');
          sender =
              snapshot.data?.get('nom') + ' ' + snapshot.data?.get('prenom');

          if (instance.currentUser?.displayName == null) {
            instance.currentUser?.updateDisplayName(
                '${snapshot.data?.get('nom')} ${snapshot.data?.get('prenom')}');
          }
          phonenumber = instance.currentUser!.phoneNumber != null
              ? instance.currentUser!.phoneNumber!
              : snapshot.data?.get('phone');
          //instance.currentUser?.updateDisplayName(
          //  "${snapshot.data?.get('nom')} ${snapshot.data?.get('prenom')} ") ;
          //phonenumber = snapshot.data?.get('phone');
          var _pages = [
            Container(
              //color: Colors.black,
              alignment: Alignment.center,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      alignment: Alignment.topRight,
                      child: Theme(
                          data: currenttheme,
                          child: FloatingActionButton(
                              tooltip: 'inviter un ami',
                              onPressed: () {
                                Share.share(
                                    'https://play.google.com/store/apps/details?id=com.netflix.mediaclient');
                              },
                              child: Icon(Icons.share)))),
                  /*     Text(
                    '${fullname}\n',
                    style: GoogleFonts.pacifico(
                      fontSize: 28,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    '${phonenumber}\n${instance.currentUser?.email}\nemailverified  :${user?.emailVerified}\n',
                    style: GoogleFonts.pacifico(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ), */

                  Expanded(
                      child: Center(
                          child: Text(
                              '\n\nBalance :\$${currentbalance.toStringAsFixed(3)}',
                              style: GoogleFonts.pacifico(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 15,
                                      offset: Offset(10, 10),
                                      color: currenttheme.primaryColor,
                                    )
                                  ])))),
                ],
              ),
            ),
            Notification_page(),
            const Tnvoyer(),
            //  const Demander(),
            //const Text("Page 4 - Menu")
            Menu(), Themes()
          ];
          /*  if (instance.currentUser?.phoneNumber == null ||
              instance.currentUser!.phoneNumber!.isEmpty) {
            print('arthur');
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => MaterialApp(
                    debugShowCheckedModeBanner: false, home: Phone())));
            return MaterialApp(
                debugShowCheckedModeBanner: false, home: Phone());
          } else
          */
          if (status != true) verifyauth();
          updategoogle();

          return MaterialApp(
            theme: currenttheme,
            title: "Litcash",
            home: GestureDetector(
                onHorizontalDragEnd: (DragEndDetails details) {
                  if (details.primaryVelocity! < 0) {
                    if (_currentPage > 0)
                      setState(() {
                        _currentPage -= 1;
                        //LocalNotification.show(testt);
                        SendNotification('test',
                            'dMqzBH3fROebGu90LptS3Y:APA91bFdOm1gl0--LXnlk6cA9aHon6LClMB4mmD5G__YtMCXQBF5trET3-lizlRqS3b5KSz0Zn2A7c_Yv7eOHxPO0QFI3lMs89lciTciODqkLSKI7T3k3tn04XV57Y57NDPegH2MBlkn');
                      });
                  }
                  if (details.primaryVelocity! > 0) {
                    if (_currentPage < _pages.length - 1)
                      setState(() {
                        _currentPage += 1;
                      });
                  }
                },
                child: Scaffold(
                  appBar: AppBar(
                      actions: [
                        IconButton(
                            icon: Icon(Icons.home),
                            onPressed: () {
                              // Navigator.of(context)
                              //   .push(MaterialPageRoute(builder: (context) => MyApp()));
                            })
                      ],
                      title: Container(
                          //decoration: BoxDecoration(
                          //  gradient: LinearGradient(
                          //    colors: [Colors.yellow, Colors.blue])),
                          child: Text(
                        'Litcash',
                        style: GoogleFonts.pacifico(
                            fontSize: 28,
                            color: currenttheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            shadows: [
                              Shadow(
                                  blurRadius: 10,
                                  offset: Offset(5, 5),
                                  color: Colors.blueGrey)
                            ]),
                      )),
                      primary: true,
                      backgroundColor: Colors.white),
                  body: Center(
                    child: _pages.elementAt(_currentPage),
                  ),
                  bottomNavigationBar: BottomAppBar(
                      elevation: 20.0,
                      shape: CircularNotchedRectangle(),
                      color: Colors.green,
                      child: BottomNavigationBar(
                        landscapeLayout:
                            BottomNavigationBarLandscapeLayout.linear,
                        type: BottomNavigationBarType.shifting,
                        items: const <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                              icon: Icon(Icons.home), label: "Acceuil"),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.notifications_active_rounded),
                              label: "Notifications"),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.send_to_mobile),
                              label: "Envoyer"),
                          //  BottomNavigationBarItem(
                          //    icon: Icon(Icons.present_to_all), label: "Demander"),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.menu), label: "Menu"),
                          //  BottomNavigationBarItem(
                          //    icon: Icon(Icons.widgets), label: "Theme")
                        ],
                        iconSize: 18.0,
                        selectedFontSize: 10.0,
                        selectedItemColor: currenttheme.primaryColor,
                        unselectedItemColor: currenttheme.unselectedWidgetColor,
                        backgroundColor: Colors.white,
                        showUnselectedLabels: true,
                        currentIndex: _currentPage,
                        onTap: (int index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                      )),
                  resizeToAvoidBottomInset: false,
                )),
            debugShowCheckedModeBanner: false,
          );
        });
  }
}
