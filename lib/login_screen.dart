import 'package:flutter/material.dart';

// import 'dart:developer';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'sign_up_screen.dart';

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
  String _response = '';

  // bool _canNavigate = false;

  //로그인 데이터 전송
  Future<void> sendLoginData(String username, String password) async {
    print("${username}, ${password}");
    final url = Uri.parse('http://10.0.2.2:8001/login'); // FastAPI 서버 주소
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': username, 'password': password}),
      );
      if (response.statusCode == 200) {
        setState(() {
          final data = jsonDecode(response.body);
          _response = 'Username: ${data['id']}, Password: ${data['password']}';
          print(_response);
          // navigateToNextPage(context);
        });
      } else {
        setState(() {
          _response = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _response = 'Failed to connect to server: $e';
      });
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
      appBar: AppBar(),
      body: Column(children: [
        Padding(
          padding: EdgeInsets.only(top: 55, bottom: 0),
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
              height: 55,
              child: MyCheckBox(),
            ),
          ]),
        ),
        Container(
          width: 58,
          height: 22,
          // color: Colors.cyanAccent,
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            color: Colors.black,
            width: 1.5,
          ))),
          child: GestureDetector(
            onTap: () {
              print("sign up");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => signUpPage()));
            },
            child: Text(
              "회원가입",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  decoration: TextDecoration.combine([TextDecoration.none]),
                  decorationColor: Colors.black),
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(bottom: 25)),
        ElevatedButton(
            onPressed: () {
              final id = _IdController.text;
              final pw = _PwController.text;
              sendLoginData(id, pw);
            },
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
          child: Text("----------- 간편 로그인 ------------"),
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
                  child: Container(
                    // margin: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
                    width: 82,
                    height: 22,
                    // color: Colors.cyanAccent,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: Colors.black54,
                      width: 1,
                    ))),
                    child: GestureDetector(
                      onTap: () {
                        print("find id/pw");
                      },
                      child: Text(
                        "ID/PW 찾기",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            decoration:
                                TextDecoration.combine([TextDecoration.none]),
                            decorationColor: Colors.black54),
                      ),
                    ),
                  )),
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
