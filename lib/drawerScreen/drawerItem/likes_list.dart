import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LikeList extends ConsumerStatefulWidget {
  const LikeList({super.key});

  @override
  LikeListState createState() => LikeListState();
}

class LikeListState extends ConsumerState<LikeList> {

  //좋아요 목록 불러오는 로직구현

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[600],
        foregroundColor: Colors.white,
        title: Text("좋아요 표시한 목록", style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Container(
        width: 200,
        height: 70,
        color: Colors.cyan,
        child: Text("아이템 리스트"),
      ),
    );
  }
}
