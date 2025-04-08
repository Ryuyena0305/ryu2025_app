import 'package:flutter/material.dart';

//1.
void main(){
  print("콘솔에 출력하기");
  runApp(MyApp2());
}//f e

//2.클래스 생성
class MyApp1 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
  return MaterialApp(
    home:Scaffold(
    appBar:AppBar(title : Text("상단메뉴")),
    body : Text("본문"),
    bottomNavigationBar : BottomAppBar(
      child:Text("하단메뉴"),
    ),
    )
  );
  }
}

class MyApp2 extends StatelessWidget{
  int count =0;
  void increment(){count++;
  print(count);}
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home:Scaffold(
        appBar: AppBar(title:Text("상단텍스트")),
        body: Center(
          child: Column(
            children: [
              Text("본문 텍스트 : $count"),
              TextButton(
                  onPressed: increment,
                  child: Text("버튼클릭하세요"),
              )
            ],
          )
        ),
      )
    );
  }
}