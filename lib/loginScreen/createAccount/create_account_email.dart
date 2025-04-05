import 'package:flutter/material.dart';
import 'create_account_pw.dart';
import 'package:dna/color.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  String? _emailHelperText;
  bool _isEmailValid = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void validateEmail(String value) {
    if (value.isEmpty) {
      setState(() {
        _emailHelperText = '이메일을 입력하세요.';
        _isEmailValid = false;
      });
    } else {
      String pattern =
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
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

  final Map<String, dynamic>_accountInfo = {};

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
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2)),
                    enabledBorder:
                    OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    helperText: _emailHelperText,
                    helperStyle: TextStyle(
                      color: _emailHelperText == '사용 가능한 이메일입니다.'
                          ? Colors.green
                          : Colors.red, // 유효하면 초록색, 아니면 빨간색
                    ),
                  ),
                  onChanged: (value) => validateEmail(value),
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
              SizedBox(height: 40,),
              OutlinedButton(
                onPressed: () {
                  print(_isEmailValid);
                  print(_accountInfo);
                  if (_isEmailValid) {
                    _accountInfo["email"] = _emailController.text;
                    print("accountInfo: ${_accountInfo}");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CreateAccountPwPage(accountInfo: _accountInfo)));
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