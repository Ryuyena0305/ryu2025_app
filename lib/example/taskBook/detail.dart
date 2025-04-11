import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Dio dio = Dio();
  Map<String, dynamic> book = {};  // 책 정보
  List<dynamic> comments = [];     // 리뷰 리스트

  TextEditingController reviewController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    int bid = ModalRoute.of(context)!.settings.arguments as int;
    bookFindById(bid);
    bookFindCommentsById(bid);
  }

  // 책 정보 불러오기
  void bookFindById(int bid) async {
    try {
      final response = await dio.get("http://192.168.40.13:8080/task/books/view?bid=$bid");
      setState(() {
        book = response.data;
      });
    } catch (e) {
      print(e);
    }
  }

  // 댓글 리스트 불러오기
  void bookFindCommentsById(int bid) async {
    try {
      final response = await dio.get("http://192.168.40.13:8080/task/reviews?bid=$bid");
      setState(() {
        comments = response.data;
      });
    } catch (e) {
      print(e);
    }
  }

  // 댓글 작성
  void postReview(int bid) async {
    String content = reviewController.text;
    String password = passwordController.text;

    if (content.isEmpty || password.isEmpty) {
      _showErrorDialog("내용과 비밀번호를 모두 입력해주세요.");
      return;
    }

    try {
      final response = await dio.post(
        "http://192.168.40.13:8080/task/reviews",
        data: {
          "bid": bid,
          "rcontent": content,
          "rpwd": password,
        },
      );

      if (response.statusCode == 200) {
        reviewController.clear();
        passwordController.clear();
        bookFindCommentsById(bid); // 댓글 다시 불러오기
      } else {
        _showErrorDialog("리뷰 작성 실패");
      }
    } catch (e) {
      print(e);
      _showErrorDialog("리뷰 작성 중 오류 발생");
    }
  }

  // 댓글 삭제
  void deleteComment(int rid, int bid) async {
    String password = await _showPasswordDialog();

    if (password.isEmpty) return;

    try {
      final response = await dio.delete(
        "http://192.168.40.13:8080/task/reviews?rid=$rid",
        queryParameters: {"password": password},
      );

      if (response.statusCode == 200) {
        setState(() {
          comments.removeWhere((comment) => comment['rid'] == rid);
        });
      } else {
        _showErrorDialog("비밀번호가 일치하지 않습니다.");
      }
    } catch (e) {
      print(e);
      _showErrorDialog("댓글 삭제 실패");
    }
  }

  // 비밀번호 입력 다이얼로그
  Future<String> _showPasswordDialog() async {
    TextEditingController pwdController = TextEditingController();
    String password = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('비밀번호 입력'),
          content: TextField(
            controller: pwdController,
            obscureText: true,
            decoration: InputDecoration(hintText: '비밀번호'),
          ),
          actions: [
            TextButton(
              child: Text('취소'),
              onPressed: () => Navigator.of(context).pop(''),
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () {
                password = pwdController.text;
                Navigator.of(context).pop(password);
              },
            ),
          ],
        );
      },
    );

    return password;
  }

  // 에러 다이얼로그
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('오류'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int? bid = book['bid'];

    return Scaffold(
      appBar: AppBar(title: Text("책 상세 정보")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("책제목 : ${book['bname'] ?? ''}", style: TextStyle(fontSize: 25)),
            SizedBox(height: 8),
            Text("책작가 : ${book['bwriter'] ?? ''}", style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text("책설명 : ${book['bcontent'] ?? ''}", style: TextStyle(fontSize: 15)),
            SizedBox(height: 16),

            Text("리뷰", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(comments[index]['rcontent']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteComment(comments[index]['rid'], bid!);
                      },
                    ),
                  );
                },
              ),
            ),

            Divider(height: 30),
            TextField(
              controller: reviewController,
              decoration: InputDecoration(
                labelText: '리뷰 내용',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: Text("리뷰 작성"),
                onPressed: () => postReview(bid!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
