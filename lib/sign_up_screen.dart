import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_screen.dart';

//
// class signUpScreen extends StatelessWidget {
//   signUpScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: signUpPage(),);
//   }
// }

class signUpPage extends StatefulWidget {
  const signUpPage({super.key});

  @override
  _signUpPageState createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Text(
                "회원가입",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            )));
  }
}
