import 'package:flutter/material.dart';
import 'string.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class noticeBoard extends StatelessWidget {
  const noticeBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  final int _numPages = 5;

  final List<String> category = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('요즘 국회'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Container(
                height: 35,
                color: Colors.black26,
                child: Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: Text(
                          "의안번호",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text("|"),
                      Expanded(
                        flex: 8,
                        child: Text(
                          "제목",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text("|"),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "조회수",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text("|"),
                      SizedBox(
                        width: 50,
                        child: Text(
                          "추천",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text("1234"),
                    ],
                  ),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Container(
              height: 600,
              color: Colors.deepPurpleAccent,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _numPages,
                itemBuilder: (context, pageIndex) {
                  return ListView.builder(
                    itemCount: 10, // 각 페이지의 아이템 수
                    itemBuilder: (context, itemIndex) {
                      return ListTile(
                        title:
                        Text('Page ${pageIndex + 1}, Item ${itemIndex + 1}'),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_numPages, (index) {
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

final board1 = boardInfo(
    title: "산업집적활성화 및 공장설립에 관한 법률 일부개정법률안(이언주의원 등 11인)",
    billNum: 2207862,
    body: """제안이유

현행법에 따르면 지식산업센터에 대한 규제가 부재하여 분양 후 전매를 통한 투기행위가 발생하고 있어 실제 입주가 필요한 기업들의 입주비용이 증가하는 등 문제가 지속적으로 발생하고 있음. 더불어 분양승인 전에 홍보관을 설치하고 총사업비에 과도한 분양홍보관 비용을 포함시켜 분양가가 상승한다는 지적도 제기됨.
이에 지식산업센터를 분양받은 자가 전매를 하거나 전매를 알선할 수 없도록 하고, 지식산업센터를 설립한 자는 모집공고안 승인 전에 분양홍보관을 설치할 수 없도록 하여 지속적인 산업발전을 도모하려는 것임.


주요내용

가. 지식산업센터를 분양받은 자가 분양받은 자의 지위 또는 건축물을 전매하거나 전매를 알선하여서는 아니 되도록 함(안 제28조의4제5항 신설).
나. 지식산업센터를 임대받은 자는 이를 다른 사람에게 전대(轉貸)하여서는 아니 되도록 함(안 제28조의4제6항 신설).
다. 지식산업센터를 설립한 자는 모집공고안 승인을 받지 아니하고 분양홍보관을 설치할 수 없도록 함(안 제28조의4제7항 신설).
라. 시장ㆍ군수ㆍ구청장 또는 관리기관은 지식산업센터 입주업체에 대한 입주적합업종 해당 여부를 주기적으로 확인ㆍ점검하도록 함(안 제28조의6제5항 신설).""",
    summary: "",
    url:
        "https://likms.assembly.go.kr/bill/billDetail.do?billId=PRC_X2V4W1U1V2D9D1C3A5B3Z5A3I3I4G8",
    pdfUrl: "",
    date: DateTime(2025, 1, 31));
