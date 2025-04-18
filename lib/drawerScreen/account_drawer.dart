import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:dna/secure_storage/secure_storage_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'drawerItem/edit_profile.dart';
import 'drawerItem/likes_list.dart';

class AccountDrawer extends ConsumerStatefulWidget {
  const AccountDrawer({super.key});

  @override
  AccountDrawerState createState() => AccountDrawerState();
}

class AccountDrawerState extends ConsumerState<AccountDrawer> {
  String? token = '';
  String email = '';
  String nickname = '';

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
        _getProfile(token!);
      } else {
        debugPrint("토큰이 없습니다. 로그인이 필요합니다.");
      }
    } catch (e) {
      debugPrint("초기화 중 오류 발생: $e");
    }
  }

  Future<void> _getProfile(String token) async {
    final url =
    Uri.parse("http://20.39.187.232:8000/api/auth/users/auth/profile-get");
    final headers = {
      'accept': 'application/json',
      'access-token': token,
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        if (decodedResponse is Map<String, dynamic> &&
            decodedResponse.containsKey("user")) {
          debugPrint("프로필 가져오기 성공");
          debugPrint(decodedResponse['user'].toString());
          setState(() {
            nickname = decodedResponse['user']['name'];
            email = decodedResponse['user']['id'];
          });
        }
      } else {
        debugPrint("오류 상태 코드: ${response.statusCode}");
        debugPrint("body: ${response.body}");
      }
    } catch (e) {
      debugPrint("프로필 가져오기 오류: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 240,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/Images/blue_house.webp'),
            ),
            accountName: Text(nickname),
            accountEmail: Text(email),
            decoration: BoxDecoration(color: Colors.grey[600]),
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.person_outline, color: Colors.grey,),
                SizedBox(width: 15),
                Text("개인정보 수정", style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ),
            onTap: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.favorite, color: Colors.red,),
                SizedBox(width: 15),
                Text("좋아요 표시한 목록", style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ),
            onTap: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LikeList()));
            },
          ),
          ListTile(
            title: const Text(
              "로그아웃",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.redAccent),
            ),
            onTap: () async {
              await ref
                  .read(secureStorageProvider.notifier)
                  .delete('ACCESS_TOKEN');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('로그아웃 되었습니다'),
                ));
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
