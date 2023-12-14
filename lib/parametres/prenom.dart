import 'package:lcash/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lcash/modelpage.dart';
import 'package:lcash/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String tempprenom = '', prenom = '';

class Prenom extends StatefulWidget {
  Prenom({Key? key}) : super(key: key);

  @override
  _PrenomState createState() => _PrenomState();
}

class _PrenomState extends State<Prenom> {
  final _formkey = GlobalKey<FormState>();
  final _prenomcontroller = TextEditingController();
  final Stream<DocumentSnapshot> documentStream =
      firestoreInstance.doc(instance.currentUser?.uid).snapshots();
  @override
  void dispose() {
    _prenomcontroller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: documentStream,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          prenom = snapshot.data?.get('prenom');
          return MaterialApp(
            theme: currenttheme,
            home: Scaffold(
              appBar: wappBarmodel(context),
              //backgroundColor: Colors.grey,
              body: Column(children: [
                Text(
                  "Prenom\n",
                  style: titlefonts,
                ),
                Form(
                  key: _formkey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 50,
                          /*  decoration: BoxDecoration(
                                border: Border.all(
                                    width: 3, style: BorderStyle.solid)),
                                    */
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Prénom : ',
                                  style: buttonsfonts,
                                ),
                                Text(
                                  "$prenom",
                                  style: buttonsfonts,
                                  textAlign: TextAlign.start,
                                )
                              ]),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 500,
                          child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  new RegExp(r'[a-zA-Z]')),
                            ],
                            controller: _prenomcontroller,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textDirection: TextDirection.ltr,
                            onChanged: (x) {
                              tempprenom = x.trimLeft();
                            },
                            validator: (x) {
                              if (x!.length < 3)
                                return "Entrer un prénom valide";
                              return null;
                            },
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                /*setState(() {
                              prenom = tempprenom;
                              firestoreInstance
                                  .doc(instance.currentUser?.photoURL)
                                  .update({'prenom': prenom});
                            }); */
                                updateuserinfofirebase('prenom', tempprenom);
                                setState(() {
                                  prenom = tempprenom;
                                });
                              }
                            },
                            child: Text('Enregistrer'))
                      ]),
                ),
              ]),
              resizeToAvoidBottomInset: false,
            ),
            debugShowCheckedModeBanner: false,
          );
        });
  }
}
