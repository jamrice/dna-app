import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        themeMode: ThemeMode.light,
        home: Scaffold(
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 150, bottom: 0),
                child: Icon(Icons.image, size: 120,),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text("데일리국회", style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -2,
                    decoration: TextDecoration.none
                ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: Container(
                    width: 400,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: Colors.grey,
                            width: 2
                        ),
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "아이디를 입력하세요",
                          border: InputBorder.none,
                        ),
                      ),
                    )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: Container(
                    width: 400,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: Colors.grey,
                            width: 2
                        ),
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "비밀번호를 입력하세요",
                          border: InputBorder.none,
                        ),
                      ),
                    )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: MyCheckBox(),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Text("--------- 간편 로그인 ----------"),
              ),
              Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(width: 1, color: Colors.grey)
                            ),
                            child: Center(
                              child: Icon(Icons.ac_unit, size: 40),
                            )
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(width: 1, color: Colors.grey)
                            ),
                            child: Center(
                              child: Icon(Icons.ac_unit, size: 40),
                            )
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(width: 1, color: Colors.grey)
                            ),
                            child: Center(
                              child: Icon(Icons.ac_unit, size: 40),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        )
    );
  }
}

class MyCheckBox extends StatefulWidget {
  const MyCheckBox({super.key});

  _MyCheckBoxState createState() => _MyCheckBoxState();
}

class _MyCheckBoxState extends State<MyCheckBox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        child: Row(
          children: [
            Checkbox(
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value ?? false;
                  });
                })
          ],
        ),
      ),
    );
  }
  
  
}