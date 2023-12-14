import 'package:flutter/material.dart';
import 'package:lcash/theme.dart';
import 'package:lcash/modelpage.dart';

int jour = DateTime.now().day,
    mois = DateTime.now().month,
    annee = DateTime.now().year - 18;
DateTime? tempdate = DateTime.utc(annee, jour, annee);

class Datenaissance extends StatefulWidget {
  Datenaissance({Key? key}) : super(key: key);

  @override
  _DatenaissanceState createState() => _DatenaissanceState();
}

class _DatenaissanceState extends State<Datenaissance> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: currenttheme,
      home: Scaffold(
          appBar: wappBarmodel(context),
          //backgroundColor: Colors.grey,
          body: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  "Date naissance\n",
                  style: titlefonts,
                ),
                Text(
                    "Année/Mois/Jour \n\n${tempdate?.year}  / ${tempdate?.month.toString().padLeft(2, '0')} / ${tempdate?.day.toString().padLeft(2, '0')}"),
                SizedBox(
                  height: 100,
                ),
                TextButton.icon(
                    autofocus: true,
                    onPressed: () async {
                      await showDatePicker(
                              context: context,
                              initialDate: DateTime.utc(2004),
                              firstDate:
                                  DateTime.fromMicrosecondsSinceEpoch(123),
                              lastDate: DateTime.now())
                          .then((value) {
                        tempdate = value;
                        setState(() {});
                        /*
                    firestoreInstance
                        .doc(instance.currentUser?.photoURL)
                        .update({
                      'datenaissance':
                          '${value?.day} - ${value?.month} - ${value?.year}' 
                    });*/
                        updateuserinfofirebase('datenaissance',
                            '${value?.day} - ${value?.month} - ${value?.year}');
                      });
                    },
                    icon: Icon(Icons.calendar_today),
                    label: Text("Choisir ma date de naissance"))
              ],
            ),
          )),
      debugShowCheckedModeBanner: false,
    );
  }
}
