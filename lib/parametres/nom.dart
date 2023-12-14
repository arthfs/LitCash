import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lcash/main.dart';
import 'package:lcash/theme.dart';
import 'package:lcash/modelpage.dart';

String tempnom = '', nom = '';

class Nom extends StatefulWidget {
  Nom({Key? key}) : super(key: key);

  @override
  _NomState createState() => _NomState();
}

class _NomState extends State<Nom> {
  final _formkey = GlobalKey<FormState>();
  final _nomcontroller = TextEditingController();

  Stream collectionStream = firestoreInstance.snapshots();
  final Stream<DocumentSnapshot> documentStream =
      firestoreInstance.doc(instance.currentUser?.uid).snapshots();

  @override
  void dispose() {
    _nomcontroller.dispose();
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
        nom = snapshot.data?.get('nom');
        return MaterialApp(
          theme: currenttheme,
          home: Scaffold(
            appBar: wappBarmodel(context),
            body: Column(children: [
              Text(
                "Nom\n",
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
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                    width: 3, style: BorderStyle.solid)),
                                    */
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Nom : ',
                                  style: buttonsfonts,
                                ),
                                Text(
                                  "$nom",
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
                            controller: _nomcontroller,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textDirection: TextDirection.ltr,
                            onChanged: (x) {
                              tempnom = x.trimLeft();
                            },
                            validator: (x) {
                              if (x!.length < 3) return "Entrer un nom valide";
                              return null;
                            },
                          ),
                        ),
                      ])),
              ElevatedButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      /*setState(() {
                              nom = tempnom;
                              firestoreInstance
                                  .doc(instance.currentUser?.photoURL)
                                  .update({'nom': tempnom});
                            });*/
                      updateuserinfofirebase('nom', tempnom);
                      setState(() {
                        nom = tempnom;
                      });
                    }
                  },
                  child: Text('Enregistrer')),
            ]),
            resizeToAvoidBottomInset: false,
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
