import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../secure_storage/secure_storage_notifier.dart';
import 'dart:math' as math;
import '../boardScreen/complex_notice_board.dart';
import '../loginScreen/login_screen.dart';

class SummaryBoard extends ConsumerStatefulWidget {
  const SummaryBoard({super.key});

  @override
  ConsumerState<SummaryBoard> createState() => _SummaryBoardState();
}

class _SummaryBoardState extends ConsumerState<SummaryBoard> {
  List<dynamic> data = [];
  String? token = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      // 토큰 상태를 Riverpod을 통해 직접 확인
      final tokenState = ref.read(secureStorageProvider);
      final hasToken = tokenState != null && tokenState.containsKey('ACCESS_TOKEN');

      if (hasToken) {
        final token = tokenState['ACCESS_TOKEN'];
        await fetchRecommandationDataFromServer(token!);
      } else {
        print("토큰이 없습니다. 로그인이 필요합니다.");
      }
    } catch (e) {
      print("초기화 중 오류 발생: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> fetchRecommandationDataFromServer(String token) async {
    final url = Uri.parse("http://20.39.187.232:8000/recommendation/user_id");
    try {
      final response = await http.get(url,
          headers: {'accept': 'application/json', 'access-token': token});

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        if (decodedResponse is Map<String, dynamic> &&
            decodedResponse.containsKey("bills")) {
          if (mounted) {
            setState(() {
              data = decodedResponse['bills'];
            });
          }
        }
      } else {
        print("오류 상태 코드: ${response.statusCode}");
      }
    } catch (e) {
      print("데이터 가져오기 오류: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokenState = ref.watch(secureStorageProvider);
    final hasToken = tokenState != null && tokenState.containsKey('ACCESS_TOKEN');

    return Container(
      color: Colors.transparent,
      child: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : !hasToken
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "로그인이 필요한 서비스입니다",
              style: TextStyle(color: Colors.black87, fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage())
                );
              },
              child: Text("로그인하기"),
            ),
          ],
        ),
      )
          : data.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "데이터를 불러올 수 없습니다",
              style: TextStyle(color: Colors.black87, fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final token = tokenState['ACCESS_TOKEN'];
                fetchRecommandationDataFromServer(token!);
              },
              child: Text("다시 시도"),
            ),
          ],
        ),
      )
          : Column(  // ListView 대신 Column 사용
        children: List.generate(
          math.min(6, data.length),  // data 길이와 6 중 작은 값 사용
              (index) => GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ComplexNoticeBoard(data: data[index])));
              },
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 180,
                    child: Image.asset(
                      'assets/Images/blue_house.webp',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 3)
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            data[index]['bill_title'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(
                                  '${data[index]['ppsr_name']}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Container(
                              child: Text("조회수: 124141회", maxLines: 1),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }
}
