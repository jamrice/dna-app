import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import '../boardScreen/complex_notice_board.dart';

class RecommendationBoard extends ConsumerStatefulWidget {
  final String billId;

  const RecommendationBoard({super.key, required this.billId});

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

  Future<void> fetchRecommandationBillDataFromServer() async {
    final url = Uri.parse(
        "http://20.39.187.232:8000/recommendation/bills?bill_id=$_billId");
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
        print("오류 상태 코드: ${response.statusCode}");
      }
    } catch (e) {
      print("데이터 가져오기 오류: $e");
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
            child: Text("다시 시도"),
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
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => ComplexNoticeBoard(data: data[index]),),);
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
                          Text("조회수: 124141회", maxLines: 1),
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
