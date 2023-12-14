import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lcash/theme.dart';

class Demander extends StatefulWidget {
  const Demander({Key? key}) : super(key: key);

  @override
  _DemanderState createState() => _DemanderState();
}

class _DemanderState extends State<Demander> {
  String destinateur = '';
  PhoneContact? _phoneContact;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: currenttheme,
      home: Scaffold(
          // backgroundColor: Colors.black,
          body: Column(
        children: [
          Text(
            "Demander de l'argent à quelqu'un \n\n",
            style: GoogleFonts.pacifico(
                // color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          IntlPhoneField(
            onCountryChanged: (value) {
              print(value.fullCountryCode);
            },
            initialCountryCode: "HT",
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                //prefixIcon: const Icon(Icons.phone_android_sharp,
                //    color: Colors.white),
                border: const UnderlineInputBorder(),
                labelText: 'Entrer le numero de tetelphone',
                labelStyle: GoogleFonts.pacifico(),
                suffixIcon: const Icon(
                  Icons.contacts_rounded,
                )),
            style: GoogleFonts.pacifico(),
            // initialValue: '+509 $destinateur ',
          ),
          TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.monetization_on, color: Colors.amber.shade400),
                  border: const UnderlineInputBorder(),
                  hintText: '',
                  labelText: 'Entrer le montant de votre requête',
                  labelStyle: GoogleFonts.pacifico()),
              style: GoogleFonts.pacifico())
        ],
      )),
      debugShowCheckedModeBanner: false,
    );
  }
}
