import 'package:flutter/material.dart';
import 'package:ryu2025_app/example/day04/fix/home.dart';
import 'package:ryu2025_app/example/day04/fix/write.dart';
import 'package:ryu2025_app/example/day04/fix/detail.dart';
import 'package:ryu2025_app/example/day04/fix/update.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
        routes: {
        "/" : (context) => Home(),
    "/write" : (context) => Write(),
    "/detail" : (context) =>Detail(),
    "/update" : (context) => Update(),
    },
    );
  }
}