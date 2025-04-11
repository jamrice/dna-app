import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../secure_storage/secure_storage_notifier.dart';
import 'package:http/http.dart' as http;
import 'recommendation_tab.dart';

class ComplexNoticeBoard extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const ComplexNoticeBoard({super.key, required this.data});

  @override
  _ComplexNoticeBoardState createState() => _ComplexNoticeBoardState();
}

class _ComplexNoticeBoardState extends ConsumerState<ComplexNoticeBoard> {
  final ScrollController _scrollController = ScrollController();
  double _expandedHeight = 260.0; // 기본 확장 높이
  late DateTime _enterTime;
  String? token = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
    // print(widget.data['bill_title']);
    _enterTime = DateTime.now();
    _scrollController.addListener(_updateExpandedHeight);
  }

  //토큰 초기화
  Future<void> _initializeData() async {
    try {
      // 토큰 상태를 Riverpod을 통해 직접 확인
      final tokenState = ref.read(secureStorageProvider);
      final hasToken =
          tokenState != null && tokenState.containsKey('ACCESS_TOKEN');

      if (hasToken) {
        token = tokenState['ACCESS_TOKEN'];
        // print('complex: $token');
        // print(widget.data['bill_id']);
      } else {
        print("토큰이 없습니다. 로그인이 필요합니다.");
      }
    } catch (e) {
      print("초기화 중 오류 발생: $e");
    }
  }

  Future<void> sendTimeDataToServer(String token) async {
    final exitTime = DateTime.now();
    final duration = exitTime.difference(_enterTime);

    final url = Uri.parse("http://20.39.187.232:8000/page_visit/save");
    print("token: $token");

    final headers = {
      'accept': 'application/json',
      'access-token': token,
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "visit_duration": duration.inSeconds,
      "page_id": widget.data['bill_id'],
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print("전송성공");
      } else {
        print("오류 상태 코드: ${response.statusCode}");
        print("body: ${response.body}");
        print(widget.data['bill_id']);
      }
    } catch (e) {
      print("전송에러: $e");
    }
  }

  void _updateExpandedHeight() {
    setState(() {
      _expandedHeight = (250 - _scrollController.offset).clamp(100.0, 250.0);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateExpandedHeight);
    _scrollController.dispose();
    sendTimeDataToServer(token!);
    super.dispose();
  }

  void _connectInternet(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw '다운로드 할 수 없거나 주소가 잘못되었습니다.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              pinned: true,
              expandedHeight: _expandedHeight,
              actions: [
                IconButton(
                  icon: const Icon(Icons.home),
                  tooltip: '메인으로',
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/main', // 메인 페이지 라우트 이름
                          (Route<dynamic> route) => false, // 이전 라우트 모두 제거
                    );
                  },
                ),
              ],
              // 동적 높이 적용
              flexibleSpace: FlexibleSpaceBar(
                background: LayoutBuilder(
                  builder: (context, constraints) {
                    // 동적 레이아웃을 위한 LayoutBuilder 사용
                    return SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(), // 중첩 스크롤 방지
                      child: Padding(
                        padding: EdgeInsets.only(top: 60, bottom: 50),
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // 내용에 맞게 크기 조정
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Center(
                                child: Text(
                                  "${widget.data["ppsl_date"].split('T')[0]}",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 80,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                "${widget.data["bill_title"]}",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.picture_as_pdf,
                                        color: Colors.red),
                                    GestureDetector(
                                      onTap: () => _connectInternet(
                                          widget.data['pdf_url']),
                                      child: Text(
                                        " PDF 다운로드",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/Icons/web.png',
                                      width: 25,
                                      height: 25,
                                    ),
                                    GestureDetector(
                                      onTap: () => _connectInternet(
                                          widget.data['bill_url']),
                                      child: Text(
                                        " 의안·회의록 주소",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              bottom: TabBar(
                tabs: [
                  Tab(text: "요약문"),
                  Tab(text: "전문"),
                  Tab(
                    text: "추천",
                  ),
                  Tab(text: "댓글"),
                ],
              ),
            ),
          ],
          body: TabBarView(
            children: [
              _summaryTab(),
              _fullTextTab(widget.data['bill_body']),
              Builder(
                builder: (context) => SafeArea(
                  child: RecommendationBoard(billId: widget.data['bill_id'], enterTime: _enterTime,),
                ),
              ),
              _commentTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryTab() {
    return Center(child: Text("요약문 내용"));
  }

  Widget _fullTextTab(String text) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Text(text),
    );
  }

  Widget _commentTab() {
    return Center(child: Text("댓글 목록"));
  }
}
