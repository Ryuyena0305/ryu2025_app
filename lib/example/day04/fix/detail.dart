
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
    int fid = ModalRoute
        .of(context)!.settings.arguments as int;
    fixFindById(fid);
  }

  Dio dio = Dio();
  Map<String, dynamic> fix = {};

  void fixFindById(fid) async {
    try {
      final response = await dio.get(
          "http://192.168.40.13:8080/day04/fixs/view?fid=$fid");
      final data = response.data;
      setState(() {
        fix = data;
      });
      print(fix);
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
              Text("비품이름 : ${fix['fname']}", style: TextStyle(fontSize: 25),),
              SizedBox(height: 8,), // 여백

              Text("비품설명 : ${fix['fdesc']}", style: TextStyle(fontSize: 20),),
              SizedBox(height: 8,), // 여백

              Text("비품재고 : ${fix['fquent'] }", style: TextStyle(fontSize: 15),),
              SizedBox(height: 8,), // 여백

              Text(
                "비품 등록일 : ${fix['createTime']}", style: TextStyle(fontSize: 15),),
              SizedBox(height: 8,), // 여백
            ],
          ),
        ),
      ); // scaffold end
    }
}