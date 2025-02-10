import 'dart:developer';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'sign_up_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'notice_board.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'categoryItem.dart';

// sha-1 : C5:80:75:66:C1:14:83:34:F9:EE:24:38:B1:B7:D5:FF:1E:9A:C4:91

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  )); //나중에 MyApp()으로 바꾸기
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: 250,
          height: 40,
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.ac_unit_rounded,
                size: 40,
              ),
              Padding(padding: EdgeInsets.only(left: 5)),
              Text("데일리국회"),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              print('Search button pressed');
            },
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(90, 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                // padding: EdgeInsets.only(bottom: 10)
              ),
              child: Text("로그인",
                  style: TextStyle(fontSize: 15, color: Colors.black)),
            ),
          ),
        ],
      ),
      body: ListView(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      padding: EdgeInsets.only(),
                      width: 320,
                      height: 45,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          border: Border.all(color: Colors.black26, width: 1),
                          borderRadius: BorderRadius.circular(30)),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextField(
                            //controller: ,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "",
                              hintStyle: TextStyle(fontSize: 15),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15),
                            ),
                          )),
                          IconButton(
                              onPressed: () {
                                print("search");
                              },
                              icon: Icon(
                                Icons.search,
                                color: Colors.black54,
                              )),
                        ],
                      ))),
            ),
            //본문
            // ai 요약 파트
            Text(
              "~를 위한 요약",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 20),
              child: Container(
                  width: 400,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 5),
                          child: Text(
                            "1124513513",
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 5),
                          child: Text(
                            "1124513513",
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 5),
                          child: Text(
                            "1124513513",
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            //최근 국회 파트
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "최근 국회 회의록, 쉽게 읽어보세요",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => HomePage()));
                    print("자세히보기 pressed");
                  },
                  child: Text(
                    "자세히 보기",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                child: Container(
                    width: 400,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 5, top: 10),
                            child: Text(
                              "[2207596] 제421회국회(임시회) 회기결정의 건(의장)",
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5, top: 10),
                            child: Text(
                              """1. 서울서부지방법원 불법적 폭동사태 관련 긴급현안질문 실시의 건(의장 제의)(의안번호 2207752) \n\n2. 서울서부지방법원 불법적 폭동사태 관련 긴급현안질문""",
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ))),
            // 요즘 국회
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "요즘 국회",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  child: Text(
                    "더보기",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                child: Container(
                    width: 400,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                        padding:
                            EdgeInsets.only(bottom: 10, left: 10, right: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 5, top: 10),
                                child: Text(
                                  "[2207596] 제421회국회(임시회) 회기결정의 건(의장)",
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5, top: 10),
                                child: Text(
                                  """1. 서울서부지방법원 불법적 폭동사태 관련 긴급현안질문 실시의 건(의장 제의)(의안번호 2207752) \n\n2. 서울서부지방법원 불법적 폭동사태 관련 긴급현안질문""",
                                  style: TextStyle(fontSize: 11),
                                ),
                              )
                            ])))),
            Text(
              "카테고리 별로 모아봤어요",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            MyPageView(),
          ]),
    );
  }
}
