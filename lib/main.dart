import 'dart:developer';

import 'package:flutter/material.dart';
import 'main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LoginScreen());
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _IdController = TextEditingController();
  final TextEditingController _PwController = TextEditingController();

  bool _canNavigate = false;

  void _tryLogin() {
    String id = _IdController.text;
    String pw = _PwController.text;

    print('ID: $id');
    print('Password: $pw');
    if (id == "ththth6543@gmail.com" && pw == "7330") {
      setState(() {
        _canNavigate = true;
      });
    } else {
      setState(() {
        _canNavigate = false;
      });
    }

    if (_canNavigate) {
      navigateToNextPage(context);
    }
    else {
      log("login fail");
    }
  }

  @override
  void dispose() {
    _IdController.dispose();
    _PwController.dispose();
    super.dispose();
  }

  void navigateToNextPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => mainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(children: [
        Padding(
          padding: EdgeInsets.only(top: 150, bottom: 0),
          child: Icon(
            Icons.image,
            size: 120,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 40),
          child: Text(
            "데일리국회",
            style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                letterSpacing: -2,
                decoration: TextDecoration.none),
          ),
        ),
        Center(
          child: Column(children: [
            loginBox(
              hintText: "아이디를 입력하세요",
              hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
              controller: _IdController,
            ),
            Padding(padding: EdgeInsets.only(bottom: 15)),
            loginBox(
              hintText: "비밀번호를 입력하세요!!",
              hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
              controller: _PwController,
            ),
            Container(
              width: 350,
              child: MyCheckBox(),
            )
          ]),
        ),
        ElevatedButton(
            onPressed: _tryLogin,
            style: ElevatedButton.styleFrom(
              fixedSize: Size(350, 45),
              backgroundColor: Colors.black,
            ),
            child: Text(
              "로그인",
              style: TextStyle(fontSize: 15, color: Colors.white),
            )),
        Padding(
          padding: EdgeInsets.only(top: 60, bottom: 50),
          child: Text("--------- 간편 로그인 ----------"),
        ),
        Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1, color: Colors.grey)),
                child: Center(
                  child: Icon(Icons.ac_unit, size: 40),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1, color: Colors.grey)),
                child: Center(
                  child: Icon(Icons.ac_unit, size: 40),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1, color: Colors.grey)),
                child: Center(
                  child: Icon(Icons.ac_unit, size: 40),
                )),
          ),
        ])),
      ]),
    );
  }
}

class MyCheckBox extends StatefulWidget {
  const MyCheckBox({super.key});

  _MyCheckBoxState createState() => _MyCheckBoxState();
}

class _MyCheckBoxState extends State<MyCheckBox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Padding(
          padding: EdgeInsets.only(bottom: 25, top: 5),
          child: Row(
            children: [
              Checkbox(
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value ?? false;
                  });
                },
                visualDensity: VisualDensity.compact,
              ),
              Text("자동 로그인",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    decoration: TextDecoration.none,
                  )),
              Spacer(),
              Padding(
                padding: EdgeInsets.zero,
                child: Text(
                  "ID/PW 찾기",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    decorationStyle: TextDecorationStyle.solid,
                    decorationColor: Colors.black54,
                  ),
                ),
              )
            ],
          )),
    );
  }
}

class loginBox extends StatefulWidget {
  final String hintText;
  final TextStyle? hintStyle;
  final TextEditingController controller;

  const loginBox(
      {super.key,
      required this.hintText,
      this.hintStyle,
      required this.controller});

  @override
  _loginBoxState createState() => _loginBoxState();
}

class _loginBoxState extends State<loginBox> {

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Container(
      width: 350,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: EdgeInsets.only(left: 15),
        child: TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintText,
            hintStyle: widget.hintStyle,
          ),
        ),
      ),
    ));
  }
}
