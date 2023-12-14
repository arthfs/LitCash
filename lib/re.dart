import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

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
        // print(a.text.split('Clause de non-responsabilité'));
        temp.add(a.text);
    });
    var ratechange = temp[temp.length - 1].contains('=')
        ? double.parse(temp[temp.length - 1]
            .split('=')[1]
            .split(' ')[0]
            .replaceAll(',', '.'))
        : double.parse(
            temp[temp.length - 1].split(' ')[0].replaceAll(',', '.'));

    //.replaceRange(0, 1, '')

    //print(ratechange + ' ' + ratechange.contains('=').toString());
    return num * ratechange;
    //return num * 2;
  } else
    return -1;
  //return response.statusCode as double;
}

main() async {
  String devise1 = 'New zealand dollar', devise2 = 'Haitian Gourdes';
  devise1 = 'Japanese Yen';
  double montant = 120, result = 0.0;
  await convertcurrency(devise1, devise2, montant).then((value) {
    result = value;
    //print(result);
    return value;
  });
  print(result);
}
