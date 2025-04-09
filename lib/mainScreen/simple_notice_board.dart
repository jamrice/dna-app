import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../boardScreen/complex_notice_board.dart';
import '../color.dart';

class SimpleNoticeBoard extends StatelessWidget {
  const SimpleNoticeBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SimpleNoticeBoardItem());
  }
}

class SimpleNoticeBoardItem extends StatefulWidget {
  const SimpleNoticeBoardItem({super.key});

  @override
  _SimpleNoticeBoardItemState createState() => _SimpleNoticeBoardItemState();
}

class _SimpleNoticeBoardItemState extends State<SimpleNoticeBoardItem> {
  late Future<List<dynamic>> _futureData;

  String errorMessage = '';
  List<dynamic> data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _futureData = fetchSimpleDataFromServer();
  }

  Future<List<dynamic>> fetchSimpleDataFromServer() async {
    final url = Uri.parse(
        "http://20.39.187.232:8000/bills/all?page=1&items_per_page=10");
    try {
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('데이터 로드 시간 초과');
        }
      );
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        if (decodedResponse is Map<String, dynamic> &&
            decodedResponse.containsKey(("bills"))) {
          return decodedResponse['bills'];
        }
      }
        return [];
    } catch (e) {
      print("데이터 가져오기 오류: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // 로딩 중
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text("데이터가 없습니다.", style: TextStyle(fontSize: 16)));
        }

        List<dynamic> data = snapshot.data!;
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: 5, // 항상 5개 표시
          itemBuilder: (context, index) {
            if (index < data.length) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ComplexNoticeBoard(data: data[index])),
                  );
                },
                child: Padding(
                  padding: index == 0 ? EdgeInsets.only(top: 3, bottom: 10) : EdgeInsets.only(bottom: 10),
                  child: Container(
                    height: 35,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: boardColor,
                      borderRadius: BorderRadius.circular(8),
                      // boxShadow: [ // ✅ 그림자 추가
                      //   BoxShadow(
                      //     color: Colors.black12, // 그림자 색상
                      //     blurRadius: 8, // 흐림 정도
                      //     spreadRadius: 0, // 퍼짐 정도
                      //     offset: Offset(0, 1), // 그림자의 위치 (x, y)
                      //   ),
                      // ],
                    ),
                    child: Row(
                      children: [
                        Text("${data[index]["bill_no"]}", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(" | "),
                        Expanded(
                          child: Text(
                            "${data[index]["bill_title"]}",
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [ // ✅ 그림자 추가
                    BoxShadow(
                      color: Colors.black, // 그림자 색상
                      blurRadius: 1, // 흐림 정도
                      spreadRadius: 2, // 퍼짐 정도
                      offset: Offset(0, 10), // 그림자의 위치 (x, y)
                    ),
                  ],
                ),
                child: Text("데이터 없음", style: TextStyle(color: Colors.grey[600]), textAlign: TextAlign.center),
              );
            }
          },
        );
      },
    );
  }
}
