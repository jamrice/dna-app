import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ComplexNoticeBoard extends StatelessWidget {
  final Map<String, dynamic> data;

  const ComplexNoticeBoard({super.key, required this.data});

  void _pdfDownload(String url) async {
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
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              // 스크롤 시 AppBar가 나타남
              pinned: true,
              // AppBar가 화면에 고정됨
              expandedHeight: 170,
              // AppBar 확장 높이 설정
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 0, bottom: 5),
                      child: Center(
                        child: Text(
                          "${data["date"].split('T')[0]}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "${data["title"]}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.picture_as_pdf, color: Colors.red),
                        GestureDetector(
                          onTap: () => _pdfDownload(data['pdf_url']),
                          child: Text(
                            " PDF 다운로드",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
              bottom: TabBar(
                tabs: [
                  Tab(text: "요약문"),
                  Tab(text: "전문"),
                  Tab(text: "댓글"),
                ],
              ),
            ),
          ],
          body: TabBarView(
            children: [
              _summaryTab(),
              _fullTextTab(data['body']),
              _commentTab(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _summaryTab() {
  return SingleChildScrollView(
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Wrap(
        spacing: -10.0,
        runSpacing: -10,
        children: [
          _makeTag(1),
          _makeTag(2),
          _makeTag(3),
          _makeTag(4),
          _makeTag(5),
          _makeTag(6),
        ],
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text("요약문 넣을 곳"),
      ),
    ],
  ));
}

Widget _fullTextTab(String body) {
  return SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.all(10),
      child: Text(body),
    ),
  );
}

Widget _commentTab() {
  return SingleChildScrollView(
    child: Text("댓글 창 넣을 곳"),
  );
}

Widget _makeTag(int index) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10),
    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        minimumSize: Size(0, 25),
        padding: EdgeInsets.symmetric(horizontal: 7), // 패딩 추가
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // 내부 콘텐츠 크기에 맞춤
        children: [
          Image.asset(
            'assets/Icons/Tag.png',
            width: 20,
            height: 20,
            color: Colors.black,
          ),
          SizedBox(width: 5), // 아이콘과 텍스트 사이 여백 추가
          Text("태그 ${index}"),
        ],
      ),
    ),
  );
}
