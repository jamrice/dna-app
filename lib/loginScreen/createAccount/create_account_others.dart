import 'package:flutter/material.dart';
import 'package:dna/color.dart';
import 'package:kpostal/kpostal.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dna/api_address.dart';

class CreateAccountOthersPage extends StatefulWidget {
  final Map<String, dynamic> accountInfo;

  const CreateAccountOthersPage({super.key, required this.accountInfo});

  @override
  _CreateAccountOthersPageState createState() =>
      _CreateAccountOthersPageState();
}

class _CreateAccountOthersPageState extends State<CreateAccountOthersPage> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalcodeController = TextEditingController();
  final TextEditingController _detailAdressController = TextEditingController();

  String postCode = '-';
  String roadAddress = '-';
  String jibunAddress = '-';

  final _gender = ['비공개', '남성', '여성', '기타'];
  String _selectedGender = '';

  late Map<String, dynamic> _accountInfo;

  @override
  void initState() {
    super.initState();
    setState(() {
      _accountInfo = widget.accountInfo;
      _selectedGender = _gender[0];
    });
  }

  //yyyymmdd String을 datetime으로 전환
  DateTime createDateTimeobject(String yyyymmdd) {
    int yyyy = int.parse(yyyymmdd.substring(0, 4));
    int mm = int.parse(yyyymmdd.substring(4, 6));
    int dd = int.parse(yyyymmdd.substring(6, 8));

    DateTime dateTimeObject = DateTime(yyyy, mm, dd);
    return dateTimeObject;
  }

  Future<void> _sendUserData() async {
    // ✅ FastAPI 서버 URL
    final String url =
        '${MainServer.baseUrl}:${MainServer.port}/api/auth/users'; // 실제 API 주소 입력

    try {
      // ✅ HTTP POST 요청 보내기
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json", // JSON 요청임을 명시
        },
        body: jsonEncode(_accountInfo), // JSON 데이터 변환
      );

      // ✅ 응답 확인
      if (response.statusCode == 200) {
        var decodeData = utf8.decode(response.bodyBytes);
        print("✅ 데이터 전송 성공: ${decodeData}");
      } else {
        print("❌ 데이터 전송 실패: ${response.statusCode}");
        print("❌ 응답 내용: ${response.body}");
      }
    } catch (e) {
      print("❌ 오류 발생: $e}");
    }
  }

  void _showPopup(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.grey[200]!.withAlpha(1000),
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: const Text("확인해주세요!"),
            actions: [
              TextButton(onPressed: () {
                Navigator.pop(context);
              },
                  child: const Text("확인"))],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("정보 입력"),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "닉네임",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              InputSpace(
                controller: _nicknameController,
                labelText: "닉네임",
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 10),
                height: 120,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "성별",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 85,
                          color: Colors.grey[300],
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: DropdownButton(
                              alignment: AlignmentDirectional(0, 20),
                              value: _selectedGender,
                              dropdownColor: Colors.grey[200],
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              items: _gender
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value!;
                                });
                              }),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "생년월일",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 210,
                          height: 50,
                          child: TextField(
                            controller: _birthController,
                            style: TextStyle(fontSize: 15),
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              label: Text("생년월일"),
                              hintText: "8자리를 입력(ex 19950101)",
                              labelStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 2)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "주소",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => KpostalView(
                              kakaoKey: "8c6351a88d92bd609341952ffad531de",
                              callback: (Kpostal result) {
                                print(result);
                                setState(() {
                                  _addressController.text = result.roadAddress;
                                  _postalcodeController.text = result.postCode;
                                  roadAddress = result.address;
                                  jibunAddress = result.jibunAddress;
                                });
                              },
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          side: BorderSide.none,
                          minimumSize: Size(70, 35)),
                      child: Text("주소 찾기")),
                ],
              ),
              SizedBox(
                width: 120,
                height: 50,
                child: TextField(
                  readOnly: true,
                  controller: _postalcodeController,
                  style: TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    label: Text("우편주소"),
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 320,
                height: 50,
                child: TextField(
                  readOnly: true,
                  controller: _addressController,
                  style: TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    label: Text("도로명 주소"),
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 320,
                height: 50,
                child: TextField(
                  readOnly: false,
                  controller: _detailAdressController,
                  style: TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    label: Text("상세 주소"),
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              OutlinedButton(
                  onPressed: () {
                    _accountInfo["name"] = _nicknameController.text;
                    // _accountInfo["nickname"] = _nicknameController.text;
                    _accountInfo["gender"] = _selectedGender;
                    _accountInfo["birthday"] =
                        DateTime.parse(_birthController.text).toIso8601String();
                    _accountInfo['postal_code'] = _postalcodeController.text;
                    _accountInfo['address'] = _addressController.text;
                    _accountInfo['address_detail'] =
                        _detailAdressController.text;
                    _accountInfo['age'] = DateTime.now().year -
                        DateTime.parse(_birthController.text).year +
                        1;
                    print("${_accountInfo}");
                    _showPopup(context);
                    _sendUserData();
                  },
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      side: BorderSide.none,
                      minimumSize: Size(double.infinity, 50)),
                  child: Text("회원가입")),
            ],
          ),
        ),
      ),
    );
  }
}

class InputSpace extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;

  const InputSpace(
      {super.key, required this.controller, required this.labelText});

  @override
  _InputSpaceState createState() => _InputSpaceState();
}

class _InputSpaceState extends State<InputSpace> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.black,
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(color: Colors.grey),
        hintText: "${widget.labelText} 입력",
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2)),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      ),
    );
  }
}
