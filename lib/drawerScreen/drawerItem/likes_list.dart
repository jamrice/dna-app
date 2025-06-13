import 'dart:convert';
import 'package:dna/api_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../boardScreen/complex_notice_board.dart';
import '../../color.dart';
import '../../secure_storage/secure_storage_notifier.dart';
import 'package:http/http.dart' as http;

class LikeList extends ConsumerStatefulWidget {
  const LikeList({super.key});

  @override
  LikeListState createState() => LikeListState();
}

class LikeListState extends ConsumerState<LikeList> {
  String? token;
  List<dynamic> likesList = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      // 토큰 상태를 Riverpod을 통해 직접 확인
      final tokenState = ref.read(secureStorageProvider);
      final hasToken =
          tokenState != null && tokenState.containsKey('ACCESS_TOKEN');

      if (hasToken) {
        token = tokenState['ACCESS_TOKEN'];
        _getLikeList(token!);
      } else {
        debugPrint("토큰이 없습니다. 로그인이 필요합니다.");
      }
    } catch (e) {
      debugPrint("초기화 중 오류 발생: $e");
    }
  }

  Future<void> _getLikeList(String token) async {
    final url = Uri.parse('${MainServer.baseUrl}:${MainServer.port}/like/like_contents');
    final headers = {
      'accept': 'aplication/json',
      'access-token': token,
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          likesList = data;
          debugPrint("좋아요 리스트 불러오기 성공 $likesList");
        });
      }
    }
    catch (e) {
      debugPrint("라이크 리스트 불러오기 실패 $e");
    }
  }
  Map<String, dynamic> itemData = {};
  //좋아요 목록 불러오는 로직구현
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[600],
        foregroundColor: Colors.white,
        title: Text("좋아요 표시한 목록", style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ComplexNoticeBoard(data: itemData)));
        },
        child: Padding(
          padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
          child: Container(
            height: 70,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.centerLeft,
                          color: boardColor,
                          child: Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            itemData['bill_title'] ?? "의안 제목 없음",
                            style: TextStyle(fontSize: 13, color: Colors.black),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white54,
                              border: Border(
                                left: BorderSide(color: boardColor!, width: 1),
                                right: BorderSide(color: boardColor!, width: 1),
                                bottom: BorderSide(color: boardColor!, width: 1),
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 220,
                                height: 30,
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  "제안자: ${itemData['ppsr_name']}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
  Widget _buildLikeList() {
    if (likesList.isEmpty) {
      return Center(
        child: Text("좋아요한 목록이 없습니다."),
      );
    } else {
      return Container();
    }
  }
}
