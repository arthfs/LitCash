import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:lcash/theme.dart';
import 'package:lcash/modelpage.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:currency_picker/currency_picker.dart';

Future<double> convertcurrency(String first, String second, double num) async {
  String url =
      "https://www.google.com/search?q=1+$first+to+$second&rlz=1C1CHWL_enHT896HT896&oq=1&aqs=chrome.1.69i60j69i59l3j69i60l4.1682j0j7&sourceid=chrome&ie=UTF-8";
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var responseData = response.body;
    var document = parse(responseData);

    var liste = document.getElementsByTagName('div');
    List<String> temp = [];

    liste.forEach((a) {
      if (a.text.contains('1') &&
          a.text.contains('Clause de non-responsabilité'))
        //print(a.text.split('Clause de non-responsabilité'));

        temp.add(a.text);
    });
    var ratechange = temp[temp.length - 1].contains('=')
        ? double.parse(temp[temp.length - 1]
            .split('=')[1]
            .split(' ')[0]
            .replaceAll(',', '.'))
        : double.parse(
            temp[temp.length - 1].split(' ')[0].replaceAll(',', '.'));

    /*double.parse(
        temp[temp.length - 1].split('=')[1].split(' ')[0].replaceAll(',', '.'));
     (temp[temp.length - 1]).split(' ')[0].replaceAll(',', '.'));
    //.replaceRange(0, 1, '')
  */
    //print(ratechange);
    return num * ratechange;
  } else
    return response.statusCode as double;
}

class Conversion extends StatefulWidget {
  const Conversion({Key? key}) : super(key: key);

  @override
  _ConversionState createState() => _ConversionState();
}

class _ConversionState extends State<Conversion> {
  String symbol1 = '',
      symbol2 = '\$',
      currency1_value = '',
      currency2_value = 'a',
      currency1_name = '',
      currency2_name = '';
  String flag1 = "devise1";
  String test1 = 'choix1', test2 = 'choix2';
  double result = 0, resultingourdes = 0;
  conv() async {
    /*  if (currency2_name.compareTo('Haitian gourde') == 0) {
      await convertcurrency(
              currency1_name, "Japanese Yen", double.parse(currency1_value))
          .then((value) {
        return convertcurrency('Japanese Yen', 'Haitian gourde', value);
      });
    }
    ;*/
    await convertcurrency(
            currency1_name, currency2_name, double.parse(currency1_value))
        .then((value) {
      result = value;
      resultingourdes;
      print(result);
      return value;
    }).whenComplete(() {
      setState(() {});
    });

    /* await convertcurrency(
            currency1_name, 'Haitian gourdes', double.parse(currency1_value))
        .then((value) {
      resultingourdes = value;
      //print(result);
      return value;
    }).whenComplete(() {
      setState(() {});
    });
    */
  }

  final _myController = TextEditingController(text: ' ');

  @override
  Widget build(BuildContext context) {
    // conv();
    /*() async {
      double temp;
      try {
        temp = double.parse(currency1_value);
      } catch (e) {
        temp = 0.0;
      }
      await convertcurrency(currency1_name, currency2_name, temp).then((value) {
        setState(() {
          result = value;
        });
        print(value);
        return value;
      }).whenComplete(() {
        setState(() {});
      });
    };
    */
    return MaterialApp(
      theme: currenttheme,
      home: Scaffold(
        appBar: wappBarmodel(context),
        primary: true,

        //backgroundColor: Colors.grey,
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Conversion Devises \n\n",
                style: titlefonts,
              ),
              Row(
                children: [
                  TextButton(
                    autofocus: true,
                    onPressed: () {
                      showCurrencyPicker(
                          favorite: ['HTG'],
                          context: context,
                          onSelect: (Currency c) {
                            flag1 = c.flag!;
                            test1 = CurrencyUtils.currencyToEmoji(c);
                            //print(c.code);
                            //print(test1);
                            //print(flag1);
                            symbol1 = c.symbol;
                            currency1_name = c.name;
                            conv();
                            setState(() {
                              test1 = CurrencyUtils.currencyToEmoji(c);

                              //print(c.name);
                            });
                          });
                    },
                    child: Text('$test1',
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 60),
                    alignment: Alignment.centerLeft,
                    width: 300,
                    height: 100,
                    child: TextFormField(
                      onEditingComplete: () {
                        if (currency1_value == '') {
                          setState(() {
                            resultingourdes = 0;
                            result = 0;
                          });
                        }
                        setState(() {});
                      },
                      onChanged: (text) {
                        currency1_value = text;
                        if (text.length == 0) {
                          setState(() {
                            currency1_value = '';
                            resultingourdes = 0;
                            result = 0;
                          });
                        } else {
                          setState(() {
                            conv();
                          });
                        }
                      },
                      //controller: myController,
                      keyboardType: TextInputType.number,

                      decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: 'Entrer un montant',
                          //labelStyle: const TextStyle(
                          //  color: Colors.black, fontSize: 12),
                          suffixText: symbol1),
                      initialValue: '',
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      //style: GoogleFonts.pacifico(color: Colors.black),
                    ),
                  ),
                ],
              ),
              Row(children: [
                Container(
                    padding: const EdgeInsets.only(bottom: 40, left: 10),
                    child: Icon(
                      Icons.arrow_downward_sharp,
                      //color: Colors.black,
                      size: 34,
                    ))
              ]),
              Row(
                  mainAxisSize: MainAxisSize.max,
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                      //padding: EdgeInsets.only(right: 80, left: 10),
                      onPressed: () {
                        showCurrencyPicker(
                            context: context,
                            onSelect: (Currency c) {
                              symbol2 = c.symbol;
                              currency2_name = c.name;
                              print(currency2_name);
                              conv();
                              setState(() {
                                test2 = CurrencyUtils.currencyToEmoji(c);

                                //print(test2);
                              });
                            });
                      },
                      child: Text('$test2',
                          style: TextStyle(fontSize: 20, color: Colors.black)),
                    ),
                    Container(
                      //constraints:
                      // BoxConstraints.expand(width: 300, height: 50),
                      decoration: BoxDecoration(
                          border: BorderDirectional(
                              bottom: BorderSide(
                        width: 1.3,
                      ))),
                      padding: const EdgeInsets.only(left: 60),
                      width: 300,
                      //color: Colors.blue,
                      height: 50,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${result}     $symbol2',
                        textAlign: TextAlign.start,
                        //style: GoogleFonts.pacifico(color: Colors.black
                      ),
                    ),
                  ]),
            ]),
        resizeToAvoidBottomInset: false,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
