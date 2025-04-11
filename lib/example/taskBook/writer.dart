import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Write extends StatefulWidget{
  @override
  _WriteState createState(){return _WriteState();}
}

class _WriteState extends State<Write>{
  final TextEditingController bnameController = TextEditingController();
  final TextEditingController bwriterController = TextEditingController();
  final TextEditingController  bcontentController = TextEditingController();
  final TextEditingController  bpwdController = TextEditingController();

  Dio dio = Dio();
  void bookSave() async{
    try{
      final sendData = {
        "bname" : bnameController.text,
        "bwriter" : bwriterController.text,
        "bcontent" : bcontentController.text,
        "bpwd" : bpwdController.text
      };
      final response = await dio.post("http://192.168.40.13:8080/task/books",data:sendData);
      final data = response.data;
      if(data != null){
        Navigator.pushNamed(context, "/");
      }
    }catch(e){print(e);}
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text("책 추천 등록 화면 "),),
      body: Center(
        child: Column(
          children: [
            Text("책 추천 해보세요.") ,
            SizedBox( height: 30,) ,
            TextField(
              controller: bnameController ,
              decoration: InputDecoration( labelText: "책 이름"), // 입력 가이드 제목
              maxLength: 30, // 입력 글자 제한 수
            ) ,
            SizedBox( height: 20 , ),
            TextField(
              controller: bwriterController ,
              decoration: InputDecoration( labelText: "책 작가"),
              maxLength: 30,
            ),
            SizedBox( height:  20 ,) ,
            TextField(
              controller: bcontentController ,
              decoration: InputDecoration( labelText: "책 내용"),
              maxLines: 2,
            ),
            SizedBox( height:  20 ,) ,
            TextField(
              controller: bpwdController,
              decoration: InputDecoration(labelText: "비밀번호"),
              maxLength: 20,
              obscureText: true, // <-- 이 부분 추가
            ),
            SizedBox( height:  20 ,) ,
            OutlinedButton( onPressed: bookSave , child: Text("등록하기") )
          ], // 위젯들 end
        ), // column end
      ), // center end
    ); // scaffold end
  } // build end
}