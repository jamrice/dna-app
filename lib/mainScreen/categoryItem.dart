import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Categoryitem extends StatelessWidget {
  final PageController _pageController = PageController();

  // 📌 아이콘, 텍스트, 동작 포함된 리스트
  final List<Map<String, dynamic>> items = [
    {"icon": Icons.balance_outlined, "text": "법률", "action": () => print("홈 클릭됨")},
    {"icon": Icons.currency_bitcoin, "text": "예산 및 재정", "action": () => print("즐겨찾기 클릭됨")},
    {"icon": Icons.fort, "text": "외교, 국방", "action": () => print("설정 클릭됨")},
    {"icon": Icons.money, "text": "경제, 산업", "action": () => print("프로필 클릭됨")},
    {"icon": Icons.shopping_cart, "text": "사회복지", "action": () => print("장바구니 클릭됨")},
    {"icon": Icons.eco, "text": "환경, 에너지", "action": () => print("좋아요 클릭됨")},
    {"icon": Icons.account_balance, "text": "행정, 정부 운영", "action": () => print("메시지 클릭됨")},
    {"icon": Icons.balance_outlined, "text": "사법, 법치", "action": () => print("알림 클릭됨")},
    {"icon": Icons.biotech, "text": "과학기술, 정보", "action": () => print("카메라 클릭됨")},
    {"icon": Icons.sports_soccer, "text": "문화, 체육", "action": () => print("지도 클릭됨")},
    {"icon": Icons.account_balance_outlined, "text": "국회 운영", "action": () => print("전화 클릭됨")},
    {"icon": Icons.more_horiz, "text": "기타", "action": () => print("음악 클릭됨")},
  ];

  @override
  Widget build(BuildContext context) {
    // 📌 한 페이지에 6개씩 나누기 (총 2페이지)
    List<List<Map<String, dynamic>>> pages = [
      items.sublist(0, 6),
      items.sublist(6, 12),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 400,
          height: 210,
          child: PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            itemBuilder: (context, pageIndex) {
              return Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(0),
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true, // GridView 높이를 자동으로 조정
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 0,
                  ),
                  itemCount: pages[pageIndex].length,
                  itemBuilder: (context, itemIndex) {
                    final item = pages[pageIndex][itemIndex];
                    return GestureDetector(
                      onTap: item["action"],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item["icon"], size: 40),
                          SizedBox(height: 5),
                          Text(
                            item["text"],
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        SizedBox(height: 5),
        SmoothPageIndicator(
          controller: _pageController,
          count: pages.length,
          effect: WormEffect(
            dotColor: Colors.black12,
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: Colors.black,
          ),
        ),
      ],
    );
  }
}
