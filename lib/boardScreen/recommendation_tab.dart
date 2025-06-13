import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../boardScreen/complex_notice_board.dart';
import '../secure_storage/secure_storage_notifier.dart';
import 'package:dna/api_address.dart';

class RecommendationBoard extends ConsumerStatefulWidget {
  final String billId;
  final DateTime enterTime;

  const RecommendationBoard(
      {super.key, required this.billId, required this.enterTime});

  @override
  ConsumerState<RecommendationBoard> createState() =>
      _RecommendationBoardState();
}

class _RecommendationBoardState extends ConsumerState<RecommendationBoard> {
  String? token = '';
  List<dynamic> data = [];
  bool isLoading = true;
  late String _billId;

  @override
  void initState() {
    super.initState();
    _billId = widget.billId;
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await fetchRecommandationBillDataFromServer();
      final tokenState = ref.read(secureStorageProvider);
      final hasToken =
          tokenState != null && tokenState.containsKey('ACCESS_TOKEN');

      if (hasToken) {
        token = tokenState['ACCESS_TOKEN'];
      } else {
        debugPrint("토큰이 없음, 로그인 필요");
      }
    } catch (e) {
      debugPrint("초기화 중 오류 발생: $e");
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
        "${MainServer.baseUrl}:${MainServer.port}/content/content_id?content_id=$billId");
    final headers = {'accept': "application/json"};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        if (decodedResponse is Map<String, dynamic> &&
            decodedResponse.containsKey("views")) {
          return decodedResponse['views'];
        }
      } else {
        debugPrint("오류 상태 코드: ${response.statusCode}");
        debugPrint("body: ${response.body}");
      }
    } catch (e) {
      debugPrint("조회수 Error: $e");
    }
    return null;
  }

  Future<void> sendTimeDataToServer(String token) async {
    final exitTime = DateTime.now();
    final duration = exitTime.difference(widget.enterTime);
    final url = Uri.parse("${MainServer.baseUrl}:${MainServer.port}/page_visit/save");

    final headers = {
      'accept': 'application/json',
      'access-token': token,
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "visit_duration": duration.inSeconds,
      "page_id": _billId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        if (decodedResponse is Map<String, dynamic> &&
            decodedResponse.containsKey("recommendation_bills")) {
          if (mounted) {
            setState(() {
              data = decodedResponse['recommendation_bills'];
            });
          }
        }
      } else {
        debugPrint("오류 상태 코드: ${response.statusCode}");
        debugPrint("body: ${response.body}");
      }
    } catch (e) {
      debugPrint("전송에러: $e");
    }
  }

  Future<void> fetchRecommandationBillDataFromServer() async {
    final url = Uri.parse(
        "${MainServer.baseUrl}:${MainServer.port}/recommendation/bills?bill_id=$_billId");
    try {
      final response =
          await http.get(url, headers: {'accept': 'application/json'});

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        if (decodedResponse is Map<String, dynamic> &&
            decodedResponse.containsKey("recommendation_bills")) {
          if (mounted) {
            setState(() {
              data = decodedResponse['recommendation_bills'];
            });
          }
        }
      } else {
        debugPrint("오류 상태 코드: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("데이터 가져오기 오류: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator(color: Colors.white))
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
                        fetchRecommandationBillDataFromServer();
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(105, 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("다시 시도", style: TextStyle(color: Colors.grey[700]),),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                primary: false,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      sendTimeDataToServer(token!);
                      debugPrint("\n${data[index]['bill_id']}\n\n");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ComplexNoticeBoard(data: data[index]),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 180,
                          child: Image.asset(
                            'assets/Images/blue_house.webp',
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 3),
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
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              SizedBox(height: 2),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${data[index]['ppsr_name']}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
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
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
  }
}
