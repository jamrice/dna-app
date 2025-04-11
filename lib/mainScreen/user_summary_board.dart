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
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      // 토큰 상태를 Riverpod을 통해 직접 확인
      var tokenState = ref.read(secureStorageProvider);
      var hasToken =
          tokenState != null && tokenState.containsKey('ACCESS_TOKEN');

      if (!hasToken) {
        print("token is null reload");
        await ref.read(secureStorageProvider.notifier).load('ACCESS_TOKEN');
        tokenState = ref.read(secureStorageProvider);
        hasToken = tokenState != null && tokenState.containsKey('ACCESS_TOKEN');
      }
      if (hasToken) {
        final token = tokenState?['ACCESS_TOKEN'];
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

  Future<int?> getViews(String billId) async {
    final url = Uri.parse(
        "http://20.39.187.232:8000/content/content_id?content_id=$billId");
    final headers = {'accept': "application/json"};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));

        if (decoded["views"] != null) {
          return decoded["views"];
        } else {
          print("조회수 필드가 응답에 없음");
        }
      } else {
        print("오류 상태 코드: ${response.statusCode}");
        print("응답 body: ${response.body}");
      }
    } catch (e) {
      print("조회수 요청 중 오류 발생: $e");
    }
    return null;
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
        } else {
          print("bills 키가 없거나 데이터 형식이 잘못됨: $decodedResponse");
        }
      } else {
        print("오류 상태 코드: ${response.statusCode}");
        print("응답 내용: ${response.body}");
      }
    } catch (e) {
      print("데이터 가져오기 오류: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokenState = ref.watch(secureStorageProvider);
    final hasToken =
        tokenState != null && tokenState.containsKey('ACCESS_TOKEN');

    return Container(
      color: Colors.transparent,
      child: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.grey))
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
                        onPressed: () async {
                          final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));

                          if (result == true) {
                            // 로그인 성공 후 토큰 상태 다시 확인
                            setState(() {});
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(85, 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        // child: hasToken ? IconButton(onPressed: () {}, icon: Icon(Icons.account_circle)),
                        child: Text("로그인",
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black)),
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
                            style:
                                TextStyle(color: Colors.black87, fontSize: 16),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                              });
                              final token = tokenState['ACCESS_TOKEN'];
                              fetchRecommandationDataFromServer(token!)
                                  .then((_) {
                                if (mounted) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              });
                            },
                            child: Text("다시 시도"),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      // ListView 대신 Column 사용
                      children: List.generate(
                        data.length,
                        (index) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ComplexNoticeBoard(
                                          data: data[index])));
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
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 6,
                                          offset: Offset(0, 3)),
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
                                              fontSize: 15),
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
                                          FutureBuilder<int?>(
                                            future: getViews(data[index]['bill_id']),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return Text("조회수: ..."); // 로딩 중
                                              } else if (snapshot.hasError) {
                                                return Text("조회수: 오류");
                                              } else if (snapshot.hasData) {
                                                return Text("조회수: ${snapshot.data}회");
                                              } else {
                                                return Text("조회수: 없음");
                                              }
                                            },
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
    );
  }
}
