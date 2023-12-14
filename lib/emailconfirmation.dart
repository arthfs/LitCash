import 'package:flutter/material.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

import 'modelpage.dart';

String tempcode = '';

class Confirmemail extends StatefulWidget {
  Confirmemail({Key? key}) : super(key: key);

  @override
  _ConfirmemailState createState() => _ConfirmemailState();
}

class _ConfirmemailState extends State<Confirmemail> {
  final _codecontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  void dispose() {
    _codecontroller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: wappBarmodel(context),
          //backgroundColor: Colors.grey,
          body: Column(
            children: [
              Text(
                'Email Confirmation',
                textAlign: TextAlign.center,
                style: buttonsfonts,
              ),
              Form(
                key: _formkey,
                child: PinCodeTextField(
                    appContext: context,
                    length: 6,
                    onChanged: (x) {
                      tempcode = x;
                    }),
              ),
            ],
          )),
      debugShowCheckedModeBanner: false,
    );
  }
}
