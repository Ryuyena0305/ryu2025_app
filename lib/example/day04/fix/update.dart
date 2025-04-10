// update.dart : 수정 화면 파일
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// 상태 있는 위젯 만들기
class Update extends StatefulWidget{
  @override
  _UpdateSate createState() {
    return _UpdateSate();
  }
}
class _UpdateSate extends State<Update> { // 클래스명 앞에 _ 언더바는 dart에서 private 키워드

  // 1.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // (1)  이전 위젯으로 부터 전달받은 인수(arguments)를 가져오기.
    int fid = ModalRoute.of( context )!.settings.arguments as int;
    print( fid );
    // (2) 전달받은 인수(id)를 자바에게 보내고 응답객체 받기
    fixFindById( fid );
  }
  // 2.
  Dio dio = Dio();
  Map< String, dynamic > fix = {}; // JSON 타입은 key은 무조건 문자열 그래서 String , value은 다양한 자료타입 이므로 dynamic(동적타입)
  void fixFindById( int fid ) async {
    try{
      final response = await dio.get("http://192.168.40.13:8080/day04/fixs/view?fid=$fid");
      final data = response.data;
      setState(() {
        fix = data;
        // 입력컨트롤러에 초기값 대입하기.
        titleController.text = data['fname'];
        contentController.text = data['fdesc'];
        frequentController.text = data['fquent'].toString();
      });
      print( fix );
    }catch(e){ print( e ); }
  }

  // 3. 입력컨트롤러 상태 변수
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController  frequentController = TextEditingController();


  void todoUpdate(  ) async{
    try{
      final sendData = {
        "fid" : fix['fid'],
        "fname" : titleController.text,
        "fdesc" : contentController.text,
        "fquent" : frequentController.text ,
      };// 수정에 필요한 데이터
      final response =  await dio.put("http://192.168.40.13:8080/day04/fixs" , data : sendData );
      final data = response.data;
      if( data != null ){  // 만약에 응답결과가 null 아니면 수정 성공
        Navigator.pushNamed(context, "/" ); // home 위젯으로 이동
      }
    }catch(e){ print(e); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text("수정 화면 "),),
      body: Center(
        child: Column(
          children: [
            SizedBox( height: 20,) ,
            TextField(
              controller: titleController,
              decoration: InputDecoration( labelText: "비품이름"),
              maxLength: 30,
            ),

            SizedBox( height: 20,) ,
            TextField(
              controller: contentController,
              decoration: InputDecoration( labelText: "비품설명"),
              maxLines: 3,
            ),

            SizedBox( height: 20,) ,
            TextField(
              controller: frequentController,
              decoration: InputDecoration( labelText: "비품재고"),
              maxLines: 3,
            ),

            SizedBox( height: 20,) ,
            OutlinedButton( onPressed: todoUpdate, child: Text("수정하기") ),
          ],
        ),
      ),
    ); // scaffold end
  }
}