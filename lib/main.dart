import 'dart:developer';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'sign_up_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  )); //나중에 MyApp()으로 바꾸기
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
            icon: Icon(Icons.notifications),
            onPressed: () {
              print('Search button pressed');
            },
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                    padding: EdgeInsets.only(),
                    width: 320,
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        border: Border.all(color: Colors.black26, width: 1),
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                          //controller: ,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "",
                            hintStyle: TextStyle(fontSize: 15),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15),
                          ),
                        )),
                        IconButton(
                            onPressed: () {
                              print("search");
                            },
                            icon: Icon(
                              Icons.search,
                              color: Colors.black54,
                            )),
                      ],
                    ))),
          ),
          Text(
            "국회는 지금",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text("data")
        ],
      ),
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
