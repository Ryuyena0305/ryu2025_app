
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Detail extends StatefulWidget{
  @override
  _DetailState createState() {
    return _DetailState();
  }
} // class end

class _DetailState extends State<Detail>{

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    int bid = ModalRoute
        .of(context)!.settings.arguments as int;
    bookFindById(bid);
  }

  Dio dio = Dio();
  Map<String, dynamic> book = {};

  void bookFindById(bid) async {
    try {
      final response = await dio.get(
          "http://192.168.40.13:8080/task/books/view?bid=$bid");
      final data = response.data;
      setState(() {
        book = data;
      });
      print(book);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("상세 화면"),),
      body: Center(
        child: Column(
          children: [
            Text("책제목 : ${book['bname']}", style: TextStyle(fontSize: 25),),
            SizedBox(height: 8,), // 여백

            Text("책작가 : ${book['bwriter']}", style: TextStyle(fontSize: 20),),
            SizedBox(height: 8,), // 여백

            Text("책설명 : ${book['bcontent'] }", style: TextStyle(fontSize: 15),),
            SizedBox(height: 8,), // 여백

          ],
        ),
      ),
    ); // scaffold end
  }
}