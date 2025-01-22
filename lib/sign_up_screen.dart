import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_screen.dart';

//
// class signUpScreen extends StatelessWidget {
//   signUpScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: signUpPage(),);
//   }
// }

class signUpPage extends StatefulWidget {
  const signUpPage({super.key});

  @override
  _signUpPageState createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 40, left: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
          "회원가입",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Text("오늘의 국회 회원이 되어보세요!"),
        //아이디 입력
        Padding(padding: EdgeInsets.only(top: 20, bottom: 5),
          child: Text("아이디",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        ),
        Container(
          width: 320,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: TextField(
              //controller: ,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "아이디 입력 (5~15자)",
                hintStyle: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ),
        // 비밀번호 입력
        Padding(padding: EdgeInsets.only(top: 20, bottom: 5),
          child: Text("비밀번호",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        ),
        Container(
          width: 320,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: TextField(
              //controller: ,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "비밀번호 입력 (문자, 숫자, 특수문자 포함 8~20자)",
                hintStyle: TextStyle(fontSize: 13),
              ),
            ),
          ),
        ),
        //비밀번호 확인
        Padding(padding: EdgeInsets.only(top: 20, bottom: 5),
          child: Text("비밀번호 확인",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        ),
        Container(
          width: 320,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: TextField(
              //controller: ,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "비밀번호 재입력",
                hintStyle: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ),
        // 이름
        Padding(padding: EdgeInsets.only(top: 20, bottom: 5),
          child: Text(
            "이름", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        ),
        Container(
            width: 320,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(5)),
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: TextField(
                //controller: ,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "이름을 입력해 주세요",
                  hintStyle: TextStyle(fontSize: 15),
                ),
              ),
            )
        ),
        //전화번호
        Padding(padding: EdgeInsets.only(top: 20, bottom: 5),
          child: Text("전화번호",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        ),
        Container(
          width: 320,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: TextField(
              //controller: ,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "휴대폰 번호 입력 (' - ' 제외)",
                hintStyle: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ),
      ],
    ),)
    ,
    );
  }
}
