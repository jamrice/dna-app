import 'dart:convert';
import 'package:flutter/material.dart';
import 'create_account_pw.dart';
import 'package:dna/color.dart';
import 'package:http/http.dart' as http;
import 'package:dna/api_address.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _emailController = TextEditingController();
  String? _emailHelperText;
  bool _isEmailValid = false;
  var _checkEmail = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void validateEmail(String value) {
    if (value.isEmpty) {
      setState(() {
        _emailHelperText = '이메일을 입력하세요.';
        _isEmailValid = false;
      });
    } else {
      String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
      RegExp regExp = RegExp(pattern);

      if (!regExp.hasMatch(value)) {
        setState(() {
          _emailHelperText = '잘못된 이메일 형식입니다.';
          _isEmailValid = false;
        });
      } else {
        setState(() {
          _emailHelperText = '사용 가능한 이메일입니다.';
          _isEmailValid = true;
        });
      }
    }
  }

  Widget _showDialog() {
    return AlertDialog(
      title: Text(
        "이메일 중복 확인",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Text("이미 존재하는 이메일입니다."),
      actions: [
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("확인"),
          ),
        )
      ],
      actionsPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    );
  }

  Future<void> checkEmail(String email) async {
    final url = Uri.parse(
        "${MainServer.baseUrl}:${MainServer.port}/api/auth/users/check-email?email=$email");

    final header = {'accept': 'application/json'};

    try {
      final response = await http.get(url, headers: header);

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        if (decodedResponse is Map<String, dynamic> &&
            decodedResponse.containsKey("is_available")) {
          debugPrint(decodedResponse["is_available"].toString());
          _checkEmail = decodedResponse['is_available'];
        }
      } else {
        _checkEmail = false;
      }
    } catch (e) {
      debugPrint("전송에러: $e");
    }
  }

  final Map<String, dynamic> _accountInfo = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("이메일 입력"),
      ),
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
                  "아이디(이메일) 입력",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // 이메일 입력
              Form(
                child: TextFormField(
                  controller: _emailController,
                  cursorColor: Colors.black,
                  // 상태 반영
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "이메일",
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: "이메일을 입력하세요",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    helperText: _emailHelperText,
                    helperStyle: TextStyle(
                      color: _emailHelperText == '사용 가능한 이메일입니다.'
                          ? Colors.green
                          : Colors.red, // 유효하면 초록색, 아니면 빨간색
                    ),
                  ),
                  onChanged: (value) => {
                    validateEmail(value),
                    checkEmail(value),
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "이메일을 입력하세요.";
                    }
                    // 이메일 정규식 체크
                    String pattern =
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                    RegExp regex = RegExp(pattern);
                    if (!regex.hasMatch(value)) {
                      return "올바른 이메일 형식을 입력하세요.";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
              OutlinedButton(
                onPressed: () {
                  print(_isEmailValid);
                  print(_accountInfo);
                  if (_isEmailValid) {
                    _accountInfo["email"] = _emailController.text;
                    debugPrint("accountInfo: $_accountInfo");
                    debugPrint("checkEmail: $_checkEmail");
                    if (_checkEmail) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateAccountPwPage(
                                  accountInfo: _accountInfo)));
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => _showDialog());
                    }
                  }
                },
                style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    side: BorderSide.none,
                    minimumSize: Size(double.infinity, 50)),
                child: Text("다음"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
