import 'dart:developer';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: mainScreen());
  }
}

class mainScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: 250,
          height: 40,
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.ac_unit_rounded,
                size: 40,
              ),
              Padding(padding: EdgeInsets.only(left: 5)),
              Text("데일리국회"),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              print('Search button pressed');
            },
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(90, 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                // padding: EdgeInsets.only(bottom: 10)
              ),
              child: Text("로그인",
                  style: TextStyle(fontSize: 15, color: Colors.black)),
            ),
          ),
        ],
      ),
      body: Text("Main Page"),
    );
  }
}

class mainAppBar extends StatefulWidget {
  const mainAppBar({super.key});

  _mainAppBarState createState() => _mainAppBarState();
}

class _mainAppBarState extends State<mainAppBar> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Text("1234"),
    );
  }
}
