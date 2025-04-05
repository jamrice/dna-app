import 'package:flutter/material.dart';
import 'create_account_others.dart';
import 'package:dna/color.dart';
import 'package:bcrypt/bcrypt.dart';

class CreateAccountPwPage extends StatefulWidget {
  final Map<String, dynamic> accountInfo;

  const CreateAccountPwPage({super.key, required this.accountInfo});

  @override
  _CreateAccountPwPageState createState() => _CreateAccountPwPageState();
}

class _CreateAccountPwPageState extends State<CreateAccountPwPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isObscure = true;
  late Map<String, dynamic> _accountInfo;

  @override
  void initState() {
    super.initState();
    _accountInfo = widget.accountInfo; // 기존 데이터를 복사하여 상태 변수로 사용

    _confirmPasswordController.addListener(_updateState);
    _passwordController.addListener(_updateState);
  }

  void _updateState() {
    setState(() {
      // 상태 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("비밀번호 설정"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 5),
                child: Text(
                  "비밀번호 입력",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              // 비밀번호 입력 필드
              TextFormField(
                cursorColor: Colors.black,
                autovalidateMode: AutovalidateMode.always,
                controller: _passwordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  labelText: "비밀번호",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey.shade700, width: 2),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure; // 버튼 클릭 시 상태 변경
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  }
                  if (value.length < 8) {
                    return "비밀번호는 8자 이상이어야 합니다.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  "비밀번호 재입력",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              // 비밀번호 재입력 필드
              TextFormField(
                cursorColor: Colors.black,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "비밀번호 확인",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey.shade700, width: 2),
                  ),
                  helperText: _confirmPasswordController.text.isNotEmpty &&
                      _confirmPasswordController.text == _passwordController.text
                      ? "비밀번호가 일치합니다"
                      : null,
                  helperStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  }
                  if (value != _passwordController.text) {
                    return "비밀번호가 일치하지 않습니다.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 40),
              OutlinedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _confirmPasswordController.text.isNotEmpty) {
                      _accountInfo["password"] = _passwordController.text;
                      print("Updated accountInfo: $_accountInfo");
                      print("bcrypt1: ${BCrypt.hashpw(_passwordController.text, BCrypt.gensalt())}");
                      print("bcrypt2: ${BCrypt.hashpw(_passwordController.text, BCrypt.gensalt())}");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccountOthersPage(accountInfo: _accountInfo)));
                    }
                  },
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      side: BorderSide.none,
                      minimumSize: Size(double.infinity, 50)),
                  child: Text("다음")),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
        labelStyle: TextStyle(color: Colors.grey),
        hintText: "비밀번호 입력",
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2)),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
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

class InputPasswordCheck extends StatefulWidget {
  const InputPasswordCheck({super.key});

  @override
  _InputPasswordCheckState createState() => _InputPasswordCheckState();
}

class _InputPasswordCheckState extends State<InputPasswordCheck> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.black,
      obscureText: true, // 상태 반영
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.grey),
        hintText: "비밀번호 재입력",
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2)),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      ),
    );
  }
}
