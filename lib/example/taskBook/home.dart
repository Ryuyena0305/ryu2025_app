import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  Dio dio = Dio();
  List<dynamic> booklist = [];

  void bookFindAll() async {
    try {
      final response = await dio.get("http://192.168.40.13:8080/task/books");
      final data = response.data;
      setState(() {
        booklist = data;
      });
      print(booklist);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    bookFindAll();
  }

  void showDeleteDialog(int bid) {
    TextEditingController pwController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('비밀번호 확인'),
          content: TextField(
            controller: pwController,
            obscureText: true,
            decoration: InputDecoration(hintText: "비밀번호 입력"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("취소"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                bookDelete(bid, pwController.text);
              },
              child: Text("삭제"),
            ),
          ],
        );
      },
    );
  }

  void bookDelete(int bid, String rpwd) async {
    try {
      final response = await dio.delete(
        "http://192.168.40.13:8080/task/books",
        queryParameters: {
          "bid": bid,
          "rpwd": rpwd,
        },
      );
      final data = response.data;
      if (data == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("삭제 완료")));
        bookFindAll();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("비밀번호가 일치하지 않습니다")));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("에러 발생")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("메인페이지 : Book")),
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () => Navigator.pushNamed(context, "/write"),
              child: Text("책 추천"),
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: booklist.map((book) {
                  return Card(
                    child: ListTile(
                      title: Text(book['bname']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("책이름 : ${book['bname']}"),
                          Text("책작가 : ${book['bwriter']}"),
                          Text("책설명 : ${book['bcontent']}"),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pushNamed(context, "/update", arguments: book['bid']),
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pushNamed(context, "/detail", arguments: book['bid']),
                            icon: Icon(Icons.info),
                          ),
                          IconButton(
                            onPressed: () => showDeleteDialog(book['bid']),
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
