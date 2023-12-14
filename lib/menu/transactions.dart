import 'package:flutter/material.dart';
import 'package:lcash/main.dart';
import 'package:lcash/theme.dart';
import 'package:lcash/modelpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

int len = -9, len2 = -9, len3 = -9;

Widget Wtransactions(Example_transaction y) {
  double width_montant = 60, width_name = 150;
  var content = {
    "sortant": [
      Icon(Icons.arrow_circle_left, color: Colors.red),
      Container(
          alignment: Alignment.center,
          width: width_montant,
          child: Text(
            '${y.montant.toString()}',
          )),
      Container(
          alignment: Alignment.center,
          width: width_name,
          child: Text('${y.receveur}')),
      Text(
          '${y.date.year.toString()}-${y.date.month.toString().padLeft(2, '0')}-${y.date.day.toString().padLeft(2, '0')}'),
    ],
    "entrant": [
      Icon(
        Icons.arrow_circle_right,
        color: Colors.green,
      ),
      Container(
          width: width_montant,
          //color: Colors.amber,
          child: Text(
            '${y.montant.toString()}',
            textAlign: TextAlign.center,
          )),
      Container(
          width: width_name,
          alignment: Alignment.center,
          //color: Colors.blue,
          child: Text('${y.destinataire}')),
      Text(
        '${y.date.year.toString()}-${y.date.month.toString().padLeft(2, '0')}-${y.date.day.toString().padLeft(2, '0')}',
        //textAlign: TextAlign.start,
      ),
    ]
  };
  return Container(
    height: 50,
    color: Colors.white,
    child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: content[y.type] as List<StatelessWidget>),
  );
}

class Historiquetransactions extends StatefulWidget {
  const Historiquetransactions({Key? key}) : super(key: key);

  @override
  _HistoriquetransactionsState createState() => _HistoriquetransactionsState();
}

int lists = 1;

dynamic newcollection = firestoreTransactions;
//    .where('receveur', isNotEqualTo: 'first');
//.orderBy('montant', descending: true);

class _HistoriquetransactionsState extends State<Historiquetransactions> {
  @override
  void dispose() {
    super.dispose();
  }

  // ignore: override_on_non_overriding_member
  List<Example_transaction> transactions = [];
  List<Widget> transactionswidget = [];
  Stream<QuerySnapshot<Map<String, dynamic>>> transactionStream =
      newcollection.snapshots();
  int? v = 1, critere = 1;
  void sort() {
    if (v == 1 && critere == 1) {
      transactionStream = newcollection
          //.where('receveur', isNotEqualTo: 'first')
          .orderBy('receveur', descending: false)
          .snapshots();
    } else if (v == 1 && critere == 2) {
      transactionStream = newcollection
          //.where('montant', isNotEqualTo: -99)
          .orderBy('montant', descending: false)
          .snapshots();
    } else if (v == 1 && critere == 3) {
      transactionStream = newcollection
          //.where('date', isNotEqualTo: '9999-11-12')
          .orderBy('date', descending: false)
          .snapshots();
    } else if (v == 2 && critere == 1) {
      transactionStream = newcollection
          // .where('receveur', isNotEqualTo: 'first')
          .orderBy('receveur', descending: true)
          .snapshots();
    } else if (v == 2 && critere == 2) {
      transactionStream = newcollection
          //.where('montant', isNotEqualTo: -99)
          .orderBy('montant', descending: true)
          .snapshots();
    } else if (v == 2 && critere == 3) {
      transactionStream = firestoreTransactions
          //  .where('date', isNotEqualTo: '9999-11-12')
          .orderBy('date', descending: true)
          .snapshots();
    }
    setState(() {});
  }

  Widget build(BuildContext context) {
    newcollection = firestoreTransactions;
    arthur();
    instance.currentUser?.reload();
    return StreamBuilder<QuerySnapshot>(
        stream: transactionStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return MaterialApp(
            theme: currenttheme,
            home: Scaffold(
                appBar: wappBarmodel(context),
                //backgroundColor: Colors.grey,
                body: Container(
                    child: Column(children: [
                  Text("Historique transactions \n\n", style: titlefonts),
                  Row(
                    children: [
                      DropdownButton(
                        value: v,
                        items: [
                          DropdownMenuItem(
                              onTap: () {
                                v = 1;
                                sort();
                              },
                              value: 1,
                              child: TextButton(
                                  child: Text(
                                    'Ordre Croissant',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  onPressed: () {
                                    v = 1;
                                    sort();
                                  })),
                          DropdownMenuItem(
                              onTap: () {
                                v = 2;
                                sort();
                              },
                              value: 2,
                              child: TextButton(
                                  child: Text('Ordre Décroissant',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  onPressed: () {
                                    v = 2;
                                    sort();
                                  }))
                        ],
                        onChanged: (int? x) {
                          setState(() {
                            v = x;
                          });
                        },
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      DropdownButton(
                        onTap: () {
                          critere = 1;
                        },
                        alignment: Alignment.centerRight,
                        value: critere,
                        items: [
                          DropdownMenuItem(
                              onTap: () {
                                critere = 1;
                                sort();
                              },
                              value: 1,
                              child: TextButton(
                                  child: Text('Nom',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  onPressed: () {
                                    critere = 1;
                                    sort();
                                  })),
                          DropdownMenuItem(
                              onTap: () {
                                critere = 2;

                                sort();
                              },
                              value: 2,
                              child: TextButton(
                                  child: Text('Montant',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  onPressed: () {
                                    critere = 2;

                                    sort();
                                  })),
                          DropdownMenuItem(
                              onTap: () {
                                critere = 3;
                                sort();
                              },
                              value: 3,
                              child: TextButton(
                                  child: Text('Date',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  onPressed: () {
                                    critere = 3;
                                    sort();
                                  }))
                        ],
                        onChanged: (int? x) {
                          setState(() {
                            critere = x;
                          });
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  /*Row(
                    children: [Text('Montant')]
                  )*/
                  Expanded(
                      child: ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;

                      return ListTile(
                          title: Container(
                        height: 70,
                        color: Colors.amber.shade50,
                        child: Wtransactions(Example_transaction(
                            data['destinataire'],
                            data['receveur'],
                            double.parse(data['montant'].toString()),
                            DateTime.parse(data['date']),
                            data['type'])),
                      ));
                    }).toList(),
                  ))
                ]))),
            debugShowCheckedModeBanner: false,
          );
        });
  }
}

int main() {
  return 0;
}
