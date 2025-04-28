
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ryu2025_app/app/product/productView.dart';

class ProductList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ProductListState();
  }
}


class _ProductListState extends State<ProductList>{
  //1. 
  int cno =0; //카테고리 번호 갖는 상태변수
  int page = 1;//현재 조회 중인 페이지 번호 갖는 상태변수
  List<dynamic> productList = []; //조회한 제품(DTO) 목록 상태변수
  final dio = Dio(); //자바서버와 통신 객체
  String baseUrl = "http://192.168.40.13:8080";
  // + 현재 스크롤의 상태를 감지하는 컨트롤러
  // 무한스크롤(스크롤이 거의 바닥에 존재했을 때 자료 요청해서 추가)
  final ScrollController scrollSController = ScrollController();

  //2. 현재 위젯 생명주기 : 위젯이 처음으로 열렸을 때 1번 실행
  @override//(1) 자바서버에게 자료 요청 (2) 스크롤의 리스너(이벤트) 추가
  void initState() {
    onProductAll(page);
    scrollSController.addListener(onScroll);//addListener 스크롤의 이벤트 리스너 추가
    //다음 페이지 요청
  }
    //3. 자바서버에게 자료 요청 메소드
    void onProductAll(int currentPage) async{
    try{
      final response = await dio.get("${baseUrl}/product/all?page=${currentPage}");//현제페이지 매개변수로 보낸다.
      setState(() {
        page = currentPage;//증가된 현재페이지를 상태변수에 반영
        if(page==1){
          productList = response.data['content'];
        }else if(page>=response.data['totalPages']){
          page = response.data['tatalPages'];
        }else{
          productList.addAll(response.data['content']);
        }
        print(productList);//[확인용]
        print(response.data);
        
        
      });
    }catch (e){print(e);}

    }
    //4. 스크롤의 리스너(이벤트) 추가 메소드
  void onScroll(){
    //-만약에 현재 스크롤의 위치가 거의 끝에 도달 했을 때
    if(scrollSController.position.pixels>=scrollSController.position.maxScrollExtent - 150){
      onProductAll(page+1); // 스크롤이 거의 바닥에 도달했을때 page를 1 증가 하여 다음페이지 자료 요청
    }
  }
  //5. 위젯이 반환하는 화면들
  @override
  Widget build(BuildContext context){
    if(productList.isEmpty){
      return Center(child: Text("조회된 제품이 없습니다."),);
    }
    // - ListView.builder : 여러개 아이템/항목/위젯 들을 리스트 형식으로 출력하는 위젯
    return ListView.builder( // 여러개 아이템/항목/위젯들을 리스트 형식으로 출력하는 위젯
      controller: scrollSController,
      itemCount: productList.length,//목록의 항목 갯수 <---> 제품목록의 개수 ,page 1일때 5, page 2일때 10
        itemBuilder: (context,index){ // 목록의 항목 갯수만큼 반복문
        //(1) 각 index번째 제품 꺼내기
          final product = productList[index];

          //(2) 이미지 리스트  추출
          final List<dynamic> images = product['images'];
          //(3)만약에 이미지가 존재하면 대표이미지 1개 추출 없으면 기본이미지 추출
          String? imageUrl;
          if(images.isEmpty){//리스트가 비어있으면
            imageUrl ="$baseUrl/upload/default.jpg";

          }else{
            imageUrl="$baseUrl/upload/${images[0] }";
          }
          //(4) 위젯
          return InkWell(
            onTap: ()=>{
              Navigator.push(context, //위젯명 (인수1, 인수2);
              MaterialPageRoute(builder: (context)=> ProductView(pno: product['pno']) )
              )
            },//만약에 하위 위젯을 클릭했을 때 이벤트 발생
            child: Card(
              margin: EdgeInsets.all(15),
              child:Padding(
                padding: EdgeInsets.all( 10 ),
              child: Row( //가로배치
                children: [ //가로배치할 위젯들
                  Container(width: 100,height: 100,
                  child: Image.network(imageUrl,
                  fit:BoxFit.cover),//만약에 이미지가 구역보다 크면 비율유지
                  ),
                  SizedBox(width: 20,),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product['pname'],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      SizedBox(height: 8,),
                      Text("가격 :${ product['pprice']}",style: TextStyle(fontSize: 16,color: Colors.pinkAccent),),
                      SizedBox(height: 4,),
                      Text("카테고리 : ${product['cname']}"),
                      SizedBox(height: 4,),
                      Text("조회수 : ${product['pview']}"),
                    ],
                  )),

                ],
              ),

            ),
          )
          );
        },
    );
  }

}