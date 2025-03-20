import 'package:flutter/material.dart';

class MakeTag extends StatelessWidget {
  MakeTag({super.key, required this.data});

  final Map<String, dynamic> data;
  int tagNum = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(),
    );
  }
}
