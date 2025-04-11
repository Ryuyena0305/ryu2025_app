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
  List<dynamic> booklist = [];
  void bookFindAll() async{
    try{
      final response = await dio.get("http://192.168.40.13:8080/task/books");
      final data = response.data;
      setState((){
        booklist = data;
      });
      print(booklist);
    }catch(e) {print(e);}
  }

  @override
  void initState(){
    super.initState();
    bookFindAll();
  }
  void bookDelete(int bid) async{
    try{
      final response = await dio.delete("http://192.168.40.13:8080/task/books?bid=$bid");
    final data = response.data;
    if(data==true){bookFindAll();}
    }catch(e){print(e);}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("메인페이지 : Book")),
      body: Center(
        child: Column(
          children: [
            TextButton(onPressed: ()=>{Navigator.pushNamed(context, "/write")},
                child: Text("책 추천")
            ),
            SizedBox(height: 30,),

            Expanded(
                child:ListView(
                  children: booklist.map((book){
                    return Card( child: ListTile(
                        title: Text(book['bname']),
                        subtitle: Column(
                          children: [
                            Text("책이름 : ${book['bname']}"),
                            Text("책작가 : ${book['bwriter']}"),
                            Text("책설명 : ${book['bcontent']}"),

                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(onPressed: ()=>{Navigator.pushNamed(context, "/update",arguments: book['bid'])}, icon: Icon(Icons.edit)),
                            IconButton(onPressed: ()=>{Navigator.pushNamed(context, "/detail",arguments: book['bid'])}, icon: Icon(Icons.info)),
                            IconButton( onPressed: () => { bookDelete( book['bid'] ) } , icon: Icon( Icons.delete ) ),

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