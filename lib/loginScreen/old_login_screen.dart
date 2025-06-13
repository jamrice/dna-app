import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final String clientId = 'qLfMqHGvchFgbsmr8Uz7';
  final String clientSecret = '69NS7jhduj';
  final String redirectUri = 'http://localhost:8080';

  void signInWithNaver() async {
    final NaverLoginResult result = await FlutterNaverLogin.logIn();
    print("naver");

    if (result.status == NaverLoginStatus.loggedIn) {
      print('accessToken = ${result.accessToken}');
      print('id = ${result.account.id}');
      print('email = ${result.account.email}');
      print('name = ${result.account.name}');
    }
  }

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        print('Signed in as: ${account.displayName}');
        print('Email: ${account.email}');
        print('Profile Picture: ${account.photoUrl}');
      }
    } catch (error) {
      print('Sign-in failed: $error');
    }
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.signOut();
    print('User signed out');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("로그인")
      ),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
            width: 280,
            height: 40,
            child: ElevatedButton(
                onPressed: GoogleSignIn().signIn,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(
                        color: Colors.black26,
                        width: 1,
                      )),
                  elevation: 0,
                  backgroundColor: Colors.white,
                  overlayColor: Colors.black26,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 25,
                      height: 25,
                      child: Image.asset(
                        'assets/icons/google_logo.png',
                        width: 10,
                        height: 10,
                      ),
                    ),
                    Expanded(
                        child: Center(
                      child: Text(
                        'Google 로그인',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ))
                  ],
                ))),
        ElevatedButton(
          onPressed: _handleSignOut,
          child: Text('Sign Out'),
        ),
        Padding(padding: EdgeInsets.only(top: 5)),
        ElevatedButton(
          onPressed: signInWithNaver,
          child: Text('네이버 로그인'),
        ),
      ])),
    );
  }
}
