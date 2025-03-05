import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class simpleNoticeBoard extends StatelessWidget {
  const simpleNoticeBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SimpleNoticeBoardItem());
  }
}

class SimpleNoticeBoardItem extends StatefulWidget {
  @override
  _SimpleNoticeBoardItemState createState() => _SimpleNoticeBoardItemState();
}

class _SimpleNoticeBoardItemState extends State<SimpleNoticeBoardItem> {
  String errorMessage = '';
  List<dynamic> data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSimpleDataFromServer();
    print(data);
  }

  Future<void> fetchSimpleDataFromServer() async {
    final url = Uri.parse("http://20.39.187.232:8000/bills/all/?page=0");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        if (decodedResponse is Map<String, dynamic> &&
            decodedResponse.containsKey(("bills"))) {
          setState(() {
            data = decodedResponse["bills"];
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = '서버 오류: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = '요청 실패: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double itemHeight = 35; // 각 아이템의 높이 (설정 가능)
    int itemCount = data.length > 5 ? 5 : data.length; // 최대 5개까지만 표시
    double containerHeight =
        itemHeight * (itemCount == 0 ? 1 : itemCount) + 45; // 위아래 여백 포함

    return Center(
      child: Container(
        width: double.infinity,
        height: 225,
        // 리스트뷰의 높이를 데이터 개수에 맞게 조절
        color: Colors.black12,
        padding: EdgeInsets.zero,
        child: isLoading
            ? Center(child: CircularProgressIndicator()) // 로딩 화면
            : data.isEmpty
                ? Center(
                    child: Text("데이터가 없습니다.", style: TextStyle(fontSize: 16)))
                : ListView.builder(
                    shrinkWrap: true,
                    // 리스트뷰 크기를 컨텐츠 크기에 맞춤
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    // 리스트뷰 자체 스크롤 비활성화
                    itemCount: itemCount,
                    // 항상 5개 아이템 유지
                    itemBuilder: (context, index) {
                      if (index < data.length) {
                        // 데이터가 있는 경우 표시
                        return Container(
                          height: itemHeight,
                          margin: EdgeInsets.only(top: index == 0 ? 0 : 10),
                          // 각 컨테이너 사이 간격
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(8), // 모서리 둥글게
                          ),
                          child: Row(
                            children: [
                              Text("${data[index]["num"]}",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(" | "),
                              Expanded(
                                child: Text(
                                  "${data[index]["title"]}",
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // 데이터가 부족할 경우 빈 컨테이너 추가
                        return Container(
                          margin: EdgeInsets.only(bottom: 8),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[300], // 빈 자리 색상 변경
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "데이터 없음",
                            style: TextStyle(color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                    },
                  ),
      ),
    );
  }
}
