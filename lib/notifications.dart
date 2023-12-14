
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:async';

var notifs;

class Notification_page extends StatefulWidget {
  Notification_page({Key? key}) : super(key: key);

  @override
  State<Notification_page> createState() => _Notification_pageState();
}

class _Notification_pageState extends State<Notification_page> {
  Stream<QuerySnapshot<Map<String, dynamic>>> notificationStream =
      firestoreNotifications
          .orderBy('seconds_passed', descending: true)
          .snapshots();

  @override
  Widget build(BuildContext context) {
//    raisons['nothing'] = true;
    return StreamBuilder<QuerySnapshot>(
        stream: notificationStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return MaterialApp(
            home: Scaffold(
              body: ListView(
                  children: snapshot.data!.docs.map((e) {
                Map<String, dynamic> notif = e.data()! as Map<String, dynamic>;
                return ListTile(
                    style: ListTileStyle.list,
                    visualDensity: VisualDensity.standard,
                    title: Row(
                      children: [
                        Text(
                          '${notif['date']}',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text('${notif['heure']}')
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                    ),
                    subtitle: Text('${notif['message']}'),
                    trailing: IconButton(
                        onPressed: () {
                          firestoreNotifications.get().then((value) {
                            var notif_to_delete = value.docs
                                .where((element) =>
                                    element.data().toString() ==
                                    notif.toString())
                                .first
                                .id;

                            firestoreNotifications
                                .doc(notif_to_delete)
                                .delete();
                            print(notif_to_delete);
                            print(DateTime.now().toString());
                          });
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        )));
              }).toList()),
            ),
            debugShowCheckedModeBanner: false,
          );
        });
  }
}
