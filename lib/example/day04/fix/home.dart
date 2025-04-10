import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home>{
  Dio dio = Dio();
  List <dynamic> fixlist = [];
  void fixFindAll() async{
    try{
      final response  = await dio.get("http://192.168.40.13:8080/day04/fixs");
      final data = response.data;
      setState(() {
        fixlist = data;
      });
      print(fixlist);
    }catch(e) {print(e);}
  }

  @override
  void initState(){
    super.initState();
    fixFindAll();
  }
  
  void fixDelete(int fid) async{
    try{
      final response = await dio.delete("http://192.168.40.13:8080/day04/fixs?fid=$fid");
      final data = response.data;
      if(data==true){fixFindAll();}
    }catch(e){print(e);}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("메인페이지 : Fix")),
      body: Center(
        child: Column(
          children: [
            TextButton(onPressed: ()=>{Navigator.pushNamed(context, "/write")},
                child: Text("비품 추가")
            ),
            SizedBox(height: 30,),

            Expanded(
                child:ListView(
                  children: fixlist.map((fix){
                    return Card( child: ListTile(
                      title: Text(fix['fname']),
                      subtitle: Column(
                        children: [
                          Text("비품이름 : ${fix['fname']}"),
                          Text("비품설명 : ${fix['fdesc']}"),
                          Text("비품재고 : ${fix['fquent']}"),

                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(onPressed: ()=>{Navigator.pushNamed(context, "/update",arguments: fix['fid'])}, icon: Icon(Icons.edit)),
                          IconButton(onPressed: ()=>{Navigator.pushNamed(context, "/detail",arguments: fix['fid'])}, icon: Icon(Icons.info)),
                          IconButton( onPressed: () => { fixDelete( fix['fid'] ) } , icon: Icon( Icons.delete ) ),

                        ],
                      )
                    )
                      );
                  }).toList(),
                ) )
          ],
        ),
      ),
    );
  }

}