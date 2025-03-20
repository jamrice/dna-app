import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  _createAccountPageState createState() => _createAccountPageState();
}

class _createAccountPageState extends State<CreateAccountPage> {
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "회원가입",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text("오늘의 국회 회원이 되어보세요!"),
                //아이디 입력
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 5),
                  child: Text(
                    "아이디(이메일)",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                // 이메일 입력
                InputPassword(controller: _passwordController),
                //비밀번호 확인

              ],
            ),
          )),
    );
  }
}

class InputPassword extends StatefulWidget {
  final TextEditingController controller;

  const InputPassword({super.key, required this.controller});

  @override
  _InputPasswordState createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  bool _isObscure = true; // 비밀번호 가리기 상태

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.black,
      controller: widget.controller,
      obscureText: _isObscure, // 상태 반영
      decoration: InputDecoration(
        labelText: "이메일",
        labelStyle: TextStyle(color: Colors.grey),
        hintText: "이메일을 입력하세요",
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        suffixIcon: IconButton(
          icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure; // 버튼 클릭 시 상태 변경
            });
          },
        ),
      ),
    );
  }
}