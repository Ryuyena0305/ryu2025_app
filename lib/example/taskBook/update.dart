import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// 상태 있는 위젯 만들기
class Update extends StatefulWidget {
  @override
  _UpdateState createState() {
    return _UpdateState();
  }
}

class _UpdateState extends State<Update> {
  // 1. 위젯 시작 시 데이터 불러오기
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    int bid = ModalRoute.of(context)!.settings.arguments as int;
    print(bid);
    bookFindById(bid);
  }

  // 2. Dio 및 상태 변수
  Dio dio = Dio();
  Map<String, dynamic> book = {};

  void bookFindById(int bid) async {
    try {
      final response = await dio.get("http://192.168.40.13:8080/task/books/view?bid=$bid");
      final data = response.data;
      setState(() {
        book = data;
        bnameController.text = data['bname'];
        bwriterController.text = data['bwriter'];
        bcontentController.text = data['bcontent'].toString();
      });
      print(book);
    } catch (e) {
      print(e);
    }
  }

  // 3. 입력 컨트롤러
  final TextEditingController bnameController = TextEditingController();
  final TextEditingController bwriterController = TextEditingController();
  final TextEditingController bcontentController = TextEditingController();
  final TextEditingController bpwdController = TextEditingController();

  // 4. 책 수정 요청
  void bookUpdate() async {
    try {
      final sendData = {
        "bid": book['bid'],
        "bname": bnameController.text,
        "bwriter": bwriterController.text,
        "bcontent": bcontentController.text,
        "bpwd": bpwdController.text,
      };

      print("🔍 전송 데이터: $sendData");

      final response = await dio.put("http://192.168.40.13:8080/task/books", data: sendData);
      final data = response.data;

      print("📥 서버 응답: $data");

      if (data != null && data["bid"] != null) {
        Navigator.pushNamed(context, "/");
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("오류"),
            content: Text("비밀번호가 일치하지 않습니다."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("확인"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print("❌ 예외 발생: $e");
    }
  }


  // 5. UI 빌드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("수정 화면")),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 20),
              TextField(
                controller: bnameController,
                decoration: InputDecoration(labelText: "책 이름"),
                maxLength: 30,
              ),
              SizedBox(height: 20),
              TextField(
                controller: bwriterController,
                decoration: InputDecoration(labelText: "책 작가"),
                maxLines: 2,
              ),
              SizedBox(height: 20),
              TextField(
                controller: bcontentController,
                decoration: InputDecoration(labelText: "책 설명"),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              TextField(
                controller: bpwdController,
                decoration: InputDecoration(labelText: "비밀번호"),
                obscureText: true,
              ),
              SizedBox(height: 30),
              OutlinedButton(
                onPressed: bookUpdate,
                child: Text("수정하기"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
