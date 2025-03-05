import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Categoryitem extends StatelessWidget {
  final PageController _pageController = PageController();

  // 📌 아이콘, 텍스트, 동작 포함된 리스트
  final List<Map<String, dynamic>> items = [
    {"icon": Icons.home, "text": "법률", "action": () => print("홈 클릭됨")},
    {"icon": Icons.star, "text": "즐겨찾기", "action": () => print("즐겨찾기 클릭됨")},
    {"icon": Icons.settings, "text": "설정", "action": () => print("설정 클릭됨")},
    {"icon": Icons.person, "text": "프로필", "action": () => print("프로필 클릭됨")},
    {"icon": Icons.shopping_cart, "text": "장바구니", "action": () => print("장바구니 클릭됨")},
    {"icon": Icons.favorite, "text": "좋아요", "action": () => print("좋아요 클릭됨")},
    {"icon": Icons.message, "text": "메시지", "action": () => print("메시지 클릭됨")},
    {"icon": Icons.notifications, "text": "알림", "action": () => print("알림 클릭됨")},
    {"icon": Icons.camera, "text": "카메라", "action": () => print("카메라 클릭됨")},
    {"icon": Icons.map, "text": "지도", "action": () => print("지도 클릭됨")},
    {"icon": Icons.phone, "text": "전화", "action": () => print("전화 클릭됨")},
    {"icon": Icons.music_note, "text": "음악", "action": () => print("음악 클릭됨")},
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
          height: 220,
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
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
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
