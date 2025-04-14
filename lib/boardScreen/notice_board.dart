import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'complex_notice_board.dart';
import 'package:dna/color.dart';

class NoticeBoard extends StatelessWidget {
  const NoticeBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: NoticeBoardItem());
  }
}

class NoticeBoardItem extends StatefulWidget {
  const NoticeBoardItem({super.key});

  @override
  _NoticeBoardItemState createState() => _NoticeBoardItemState();
}

class _NoticeBoardItemState extends State<NoticeBoardItem> {
  final PageController _pageController = PageController();
  static const int itemsPerPage = 10; // 한 페이지당 아이템 개수
  int currentPage = 0;
  int totalCount = 0;
  int itemCount = 0;

  List<dynamic> bills = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchDataFromServer(currentPage);
  }

  Future<void> fetchDataFromServer(int page) async {
    final url = Uri.parse(
        "http://20.39.187.232:8000/bills/all/?page=${page + 1}&items_per_page=10");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

        if (decodedResponse is Map<String, dynamic> &&
            decodedResponse.containsKey(("bills"))) {
          setState(() {
            bills = decodedResponse["bills"];
            totalCount = decodedResponse["total_count"];
            itemCount = decodedResponse["bills"].length;
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
    int _numPages = (totalCount / itemsPerPage).ceil();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '요즘 국회',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.grey[600],
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.grey,
            )) // 로딩 표시
          : errorMessage.isNotEmpty
              ? Center(
                  child:
                      Text(errorMessage, style: TextStyle(color: Colors.red)))
              : Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _numPages,
                        onPageChanged: (pageIndex) {
                          setState(() {
                            currentPage = pageIndex;
                            fetchDataFromServer(currentPage);
                          });
                        },
                        itemBuilder: (context, pageIndex) {
                          return RefreshIndicator(
                            color: Colors.grey[600],
                            onRefresh: () => fetchDataFromServer(pageIndex),
                            child: bills.isEmpty
                                ? Center(child: Text("표시할 데이터가 없습니다."))
                                : ListView.builder(
                                    itemCount: itemCount,
                                    itemBuilder: (context, itemIndex) {
                                      return noticeBoardItem(
                                          bills[itemIndex]); // 데이터 전달
                                    },
                                  ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _numPages > 5 ? 5 : _numPages,
                        (index) {
                          int visibleIndex;

                          if (_numPages <= 5) {
                            // 전체 페이지가 5 이하일 경우 그냥 출력
                            visibleIndex = index;
                          } else {
                            // 페이지가 5개 이상일 경우 중앙 정렬을 위해 계산
                            if (currentPage <= 2) {
                              // 초반 페이지(0,1,2)에서는 처음 5개를 고정
                              visibleIndex = index;
                            } else if (currentPage >= _numPages - 3) {
                              // 마지막 페이지 근처에서는 마지막 5개를 고정
                              visibleIndex = _numPages - 5 + index;
                            } else {
                              // 그 외의 경우, currentPage를 중앙에 배치
                              visibleIndex = currentPage - 2 + index;
                            }

                            // 마지막 페이지가 전체 페이지 수보다 넘지 않도록 처리
                            visibleIndex = visibleIndex.clamp(0, _numPages - 1);
                          }

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                currentPage = index;
                              });
                              _pageController.jumpToPage(visibleIndex);
                              fetchDataFromServer(currentPage);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              width: 35,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: (visibleIndex == currentPage)
                                    ? Colors.grey[600]
                                    : Colors.grey[350],
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: Center(
                                child: Text(
                                  '${visibleIndex + 1}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}

class noticeBoardItem extends StatelessWidget {
  final dynamic itemData;

  noticeBoardItem(this.itemData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ComplexNoticeBoard(data: itemData)));
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 5, left: 10, right: 10),
        child: Container(
          height: 70,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.centerLeft,
                        color: boardColor,
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          itemData['bill_title'] ?? "의안 제목 없음",
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white54,
                            border: Border(
                              left: BorderSide(color: boardColor!, width: 1),
                              right: BorderSide(color: boardColor!, width: 1),
                              bottom: BorderSide(color: boardColor!, width: 1),
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 220,
                              height: 30,
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                "제안자: ${itemData['ppsr_name']}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.black),
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.favorite, size: 16),
                                SizedBox(width: 5),
                                Text("${itemData['likes']}",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.black)),
                                SizedBox(width: 5),
                                Icon(Icons.remove_red_eye, size: 16),
                                SizedBox(width: 5),
                                Text("${itemData['views']}",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.black)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
