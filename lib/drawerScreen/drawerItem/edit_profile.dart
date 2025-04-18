import 'dart:convert';
import 'package:dna/color.dart';
import 'package:flutter/material.dart';
import 'package:dna/secure_storage/secure_storage_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool editable = false;
  String? token = '';

  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressDetailController =
      TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  //토큰 초기화
  Future<void> _initializeData() async {
    try {
      // 토큰 상태를 Riverpod을 통해 직접 확인
      final tokenState = ref.read(secureStorageProvider);
      final hasToken =
          tokenState != null && tokenState.containsKey('ACCESS_TOKEN');

      if (hasToken) {
        token = tokenState['ACCESS_TOKEN'];
        _getProfile(token!);
      } else {
        debugPrint("토큰이 없습니다. 로그인이 필요합니다.");
      }
    } catch (e) {
      debugPrint("초기화 중 오류 발생: $e");
    }
  }

  //profile 업데이트
  Future<void> _updateProfile(String token) async {

  }

  Future<void> _getProfile(String token) async {
    final url =
        Uri.parse("http://20.39.187.232:8000/api/auth/users/auth/profile-get");
    final headers = {
      'accept': 'application/json',
      'access-token': token,
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        if (decodedResponse is Map<String, dynamic> &&
            decodedResponse.containsKey("user")) {
          debugPrint("프로필 가져오기 성공");
          debugPrint(decodedResponse['user'].toString());
          setState(() {
            _nicknameController.text = decodedResponse['user']['name'];
            _emailController.text = decodedResponse['user']['id'];
            _addressController.text = decodedResponse['user']['address'];
            // _addressDetailController.text = decodedResponse['user']['address_detail'];
          });
        }
      } else {
        debugPrint("오류 상태 코드: ${response.statusCode}");
        debugPrint("body: ${response.body}");
      }
    } catch (e) {
      debugPrint("프로필 가져오기 오류: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[600],
        foregroundColor: Colors.white,
        automaticallyImplyLeading: true,
        title: Text(
          '개인정보 수정',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "이메일",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 50,
                width: 250,
                child: _inputField(_emailController, "이메일", editable),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "닉네임",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 50,
                width: 200,
                child: _inputField(_nicknameController, "닉네임", editable),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "생년월일",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 50,
                width: 200,
                child: _inputField(_birthdayController, "생년월일", editable),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "주소",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 50,
                width: 200,
                child: _inputField(_addressController, "주소", editable),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                width: 200,
                child: _inputField(_addressDetailController, "상세주소", editable),
              ),
              SizedBox(
                height: 60,
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    editable = !editable;
                  });
                  // 수정된 정보를 서버에 전송하는 로직 추가
                },
                style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    side: BorderSide.none,
                    minimumSize: Size(double.infinity, 50)),
                child: editable ? Text("저장하기") : Text("수정하기"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(
      TextEditingController controller, String labelText, bool editable) {
    return TextField(
      cursorColor: Colors.black,
      enabled: editable,
      controller: controller,
      style: TextStyle(color: editable ? Colors.black : Colors.grey[600]),
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.grey),
        hintText: "$labelText 입력",
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2)),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      ),
    );
  }
}
