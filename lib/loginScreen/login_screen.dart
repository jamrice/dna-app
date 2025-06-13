import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'createAccount/create_account_email.dart';
import 'package:dna/color.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dna/secure_storage/secure_storage_notifier.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:naver_login_sdk/naver_login_sdk.dart';
import 'createAccount/create_account_oauth.dart';
import 'package:dna/api_address.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[600],
        title: const Text(
          "로그인",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: LoginScreen(),
    );
  }
}

class LoginScreen extends ConsumerStatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true; // 비밀번호 보이기/가리기
  bool _isLoading = false; // 로딩 상태 추가

  //for google login
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  final String clientId = 'rVZ2zxSCHW280r1VGNVi';
  final String clientSecret = '_lb16dgUH1';
  final String redirectUri = 'http://a.com';
  final String clientName = "오늘의 국회";

  Future<void> _signInWithNaverSDK() async {
    try {
      debugPrint("네이버 로그인 시도");
      await NaverLoginSDK.initialize(
          clientId: clientId, clientSecret: clientSecret);
      final result = await NaverLoginSDK.authenticate(
          callback: OAuthLoginCallback(onSuccess: () async {
        debugPrint("on Login Success..");
        final token = await NaverLoginSDK.getAccessToken();
        debugPrint("token: $token");
        _sendOauthToken("naver", token);
      }, onFailure: (httpStatus, message) {
        debugPrint(
            "on Login Failure.. httpStatus:$httpStatus, message:$message");
      }, onError: (errorCode, message) {
        debugPrint("on Login Error.. errorCode:$errorCode, message:$message");
      }));
    } catch (e) {
      debugPrint("네이버 로그인 오류: $e");
    }
  }

  GoogleSignInAccount? _currentUser;

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        final GoogleSignInAuthentication googleAuth =
            await account.authentication;
        print('Signed in as: ${account.displayName}');
        print('Email: ${account.email}');
        print('Profile Picture: ${account.photoUrl}');
        print("token: ${googleAuth.accessToken}");

        setState(() {
          _currentUser = account;
          print(_currentUser);
        });
      }
    } catch (error) {
      print('Sign-in failed: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 중 오류가 발생했습니다: $error')),
      );
    }
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.disconnect();
    print('User signed out');
  }

  Future<void> _printToken() async {
    final token = await NaverLoginSDK.getAccessToken();
    debugPrint("토큰 확인 ${token}");
  }

  Future<void> _naverLogout() async {
    debugPrint("네이버 로그아웃 시도");
    NaverLoginSDK.release(
        callback: OAuthLoginCallback(onSuccess: () {
      debugPrint("onSuccess..");
    }, onFailure: (httpStatus, message) {
      debugPrint("onFailure.. httpStatus:$httpStatus, message:$message");
    }, onError: (errorCode, message) {
      debugPrint("onError.. errorCode:$errorCode, message:$message");
    }));
  }

  Future<void> _naverProfile() async {
    debugPrint("네이버 프로필 시도");
    NaverLoginSDK.profile(
        callback: ProfileCallback(onSuccess: (resultCode, message, response) {
      debugPrint(
          "on Profile Success.. resultCode:$resultCode, message:$message, profile:$response");

      final profile = NaverLoginProfile.fromJson(response: response);
      debugPrint("profile:$profile");
    }, onFailure: (httpStatus, message) {
      debugPrint(
          "on Profile Failure.. httpsStatus:$httpStatus, message:$message");
    }, onError: (errorCode, message) {
      debugPrint("on Profile Error.. message:$message");
    }));
  }

  Future<void> _sendOauthToken(String platform, String token) async {
    debugPrint("platform: $platform, token: $token");
    debugPrint("Oauth token send start");
    final url =
        Uri.parse('${MainServer.baseUrl}:${MainServer.port}/api/auth/users/auth/oauth');
    final header = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({'provider': platform, 'oauth_token': token});
    try {
      final response = await http.post(url, headers: header, body: body);
      debugPrint("Oauth token send end, status code: ${response.statusCode}");
      if (response.statusCode == 200) {
        debugPrint("User Found");
      } else if (response.statusCode == 404) {
        debugPrint("404 NOT FOUOND, 회원가입 필요");
        if (mounted) {
          _userNotFoundPopup(context, platform);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _userNotFoundPopup(BuildContext context, String platform) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          title: Text(
            '회원가입 필요',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Text('등록되어 있지 않은 회원입니다\n회원가입을 진행해주세요'),
          actions: [
            SizedBox(
              width: double.infinity,
              height: 40,
              child: TextButton(
                // onPressed: () => Navigator.pop(context),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateAccountOauth(route: platform,))),
                child: Text('회원가입'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // 개발 편의를 위한 초기값 설정 (실제 배포 시 제거)
    _idController.text = "ththth6543@gmail.com";
    _passwordController.text = '11111111';
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _sendLoginDataGetToken() async {
    // 입력 검증
    if (_idController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorSnackBar("이메일과 비밀번호를 입력해주세요.");
      return;
    }

    setState(() {
      _isLoading = true; // 로딩 시작
    });

    final storage = ref.read(secureStorageProvider.notifier);

    // 로그인 데이터 준비
    final Map<String, String> loginData = {
      "grant_type": "password",
      "username": _idController.text,
      "password": _passwordController.text,
      "scope": "",
      "client_id": "string",
      "client_secret": "string"
    };

    final String url = '${MainServer.baseUrl}:${MainServer.port}/api/auth/users/login';

    try {
      // x-www-form-urlencoded 형식으로 변환
      final encodedBody = loginData.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');

      final response = await http
          .post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: encodedBody, // 올바른 형식으로 인코딩된 body
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException("요청시간이 초과 되었습니다 네트워크 상태를 확인해주세요");
        },
      );

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(utf8.decode(response.bodyBytes));
        final accessToken = decodedData['access_token'];

        if (accessToken != null) {
          // 토큰 저장
          await storage.save('ACCESS_TOKEN', accessToken);

          // 토큰 로드 확인 (디버깅용)
          //final tokenState = await storage.load("ACCESS_TOKEN");
          // print("✅ 저장된 토큰 확인: $tokenState");

          // UI 업데이트 및 성공 메시지 표시
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("로그인 성공!"), backgroundColor: Colors.green));

            // 이전 화면으로 돌아가기
            Navigator.pop(context);
          }
        } else {
          _showErrorSnackBar("토큰을 받지 못했습니다.");
        }
      } else {
        // 오류 응답 처리
        String errorMessage = "로그인 실패: ${response.statusCode}";
        try {
          final errorBody = jsonDecode(utf8.decode(response.bodyBytes));
          errorMessage = errorBody['detail'] ?? errorMessage;
        } catch (_) {}

        _showErrorSnackBar(errorMessage);
        print("❌ 로그인 실패: ${response.statusCode}");
        print("❌ 응답 내용: ${response.body}");
      }
    } catch (e) {
      _showErrorSnackBar("연결 오류: 네트워크를 확인해주세요");
      print("❌ 오류 발생: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // 로딩 종료
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 0, bottom: 50, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.ac_unit,
                  size: 50,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 30),
                  child: Text(
                    "오늘의 국회",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                TextField(
                  controller: _idController,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "이메일",
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  cursorColor: Colors.black,
                  controller: _passwordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    labelText: "비밀번호",
                    labelStyle: const TextStyle(color: Colors.grey),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.grey,
                      ) // 로딩 인디케이터
                    : OutlinedButton(
                        onPressed: _sendLoginDataGetToken, // 직접 토큰 요청 함수 호출
                        style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: buttonColor,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            side: BorderSide.none,
                            minimumSize: const Size(double.infinity, 50)),
                        child: const Text("로그인")),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateAccountPage()));
                        },
                        child: Text(
                          "회원가입",
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      const Text("  |  "),
                      GestureDetector(
                        child: Text(
                          "아이디 찾기",
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      const Text("  |  "),
                      GestureDetector(
                        child: Text(
                          "비밀번호 찾기",
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "또는",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 15),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _handleSignIn,
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(
                              side: BorderSide(color: Colors.transparent)),
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.grey[300],
                          elevation: 2),
                      child: Image.asset(
                        'assets/Icons/google_logo.png',
                        width: 45, // 원하는 너비
                        height: 45, // 원하는 높이
                        fit: BoxFit.contain, // 이미지 비율 유지하면서 맞춤
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _signInWithNaverSDK,
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(
                              side: BorderSide(color: Colors.transparent)),
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.grey[300],
                          elevation: 2),
                      child: SizedBox(
                        width: 45,
                        height: 45,
                        child: Image.asset(
                          'assets/Icons/naver_login_button.png',
                          width: 50, // 원하는 너비
                          height: 50, // 원하는 높이
                          fit: BoxFit.contain, // 이미지 비율 유지하면서 맞춤
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(onTap: _handleSignOut, child: Text("구글 로그아웃")),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(onTap: _naverLogout, child: Text("네이버 로그아웃")),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(onTap: _printToken, child: Text("네이버 토큰")),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(onTap: _naverProfile, child: Text("네이버 프로파일")),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccountOauth(route: "google",)));
                }, child: Text("oauth 회원가입 페이지")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
