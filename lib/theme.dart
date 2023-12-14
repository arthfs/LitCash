import 'package:flutter/material.dart';

import 'modelpage.dart';

const color = const Color(0x39FF14);
const color11 = Colors.green;

ThemeData currenttheme = ThemeData(
    splashColor: color11,
    primaryColor: color11,
    primarySwatch: color11,
    appBarTheme: AppBarTheme(backgroundColor: Colors.white));

class Themes extends StatefulWidget {
  const Themes({Key? key}) : super(key: key);

  @override
  _ThemesState createState() => _ThemesState();
}

class _ThemesState extends State<Themes> {
  Color newcolor1 = Colors.white,
      newcolor2 = Colors.black,
      newcolor3 = Colors.amber;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: currenttheme,
      home: Scaffold(
          body: Column(children: [
        Container(
            alignment: Alignment.center,
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Changer Theme\n\n", style: titlefonts),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      padding: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                          color: newcolor1, shape: BoxShape.circle),
                      child: IconButton(
                          onPressed: () {
                            currenttheme = ThemeData(
                                splashColor: color11,
                                primaryColor: color11,
                                primarySwatch: color11,
                                appBarTheme:
                                    AppBarTheme(backgroundColor: Colors.white));
                            ;
                          },
                          icon: Icon(
                            Icons.ac_unit,
                            color: newcolor1,
                          ))),
                  Container(
                      padding: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                          color: newcolor2, shape: BoxShape.circle),
                      child: IconButton(
                          onPressed: () {
                            currenttheme = ThemeData.dark();
                          },
                          icon: Icon(Icons.ac_unit, color: newcolor2)))
                  /*   Container(
                      padding: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                          color: newcolor3, shape: BoxShape.circle),
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.ac_unit, color: newcolor3)))*/
                ]))
      ])),
      debugShowCheckedModeBanner: false,
    );
  }
}

int main() {
  return 0;
}
