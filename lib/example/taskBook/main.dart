import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ryu2025_app/example/taskBook/home.dart';
import 'package:ryu2025_app/example/taskBook/update.dart';
import 'package:ryu2025_app/example/taskBook/writer.dart';
import 'package:ryu2025_app/example/taskBook/detail.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/":(context)=>Home(),
         "/write" : (context) => Write(),
         "/detail" : (context) => Detail(),
         "/update" : (context) => Update(),
      },
    );
  }
}