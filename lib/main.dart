import 'package:flutter/material.dart';
import 'package:mygps/MapView.dart';
import 'package:mygps/login.dart';

void main() => runApp(new MyApp());


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'My-Gps',
      theme: new ThemeData(
        //brightness: Brightness.dark,
        primaryColor: new Color(0xffF4F4F4),
        accentColor: new Color(0xffA1A9A9),
      ),
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: new Login(),
    );
  }
}