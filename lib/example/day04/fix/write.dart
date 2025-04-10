 import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Write extends StatefulWidget{
  @override
   _WriteState createState(){return _WriteState();}
  }
  class _WriteState extends State<Write>{
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController  frequentController = TextEditingController();

  Dio dio = Dio();
  void fixSave() async{
    try{
      final sendData = {
        "fname" : titleController.text,
        "fdesc" : contentController.text,
        "fquent" : int.tryParse(frequentController.text) ?? 0,
      };
      final response = await dio.post("http://192.168.40.13:8080/day04/fixs",data : sendData);
      final data= response.data;
      if(data != null){
        Navigator.pushNamed(context, "/");
      }
    }catch(e) {print(e);}
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text("비품 등록 화면 "),),
      body: Center(
        child: Column(
          children: [
            Text("비품을 등록 해보세요.") ,
            SizedBox( height: 30,) ,
            TextField(
              controller: titleController ,
              decoration: InputDecoration( labelText: "비품 이름"), // 입력 가이드 제목
              maxLength: 30, // 입력 글자 제한 수
            ) ,
            SizedBox( height: 30 , ),
            TextField(
              controller: contentController ,
              decoration: InputDecoration( labelText: "비품 설명"),
              maxLines: 3,
            ),
            SizedBox( height:  30 ,) ,
            TextField(
              controller: frequentController ,
              decoration: InputDecoration( labelText: "비품 수량"),
              maxLines: 3,
            ),
            SizedBox( height:  30 ,) ,
            OutlinedButton( onPressed: fixSave , child: Text("등록하기") )
          ], // 위젯들 end
        ), // column end
      ), // center end
    ); // scaffold end
  } // build end

 }