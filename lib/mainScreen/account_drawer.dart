import 'package:flutter/material.dart';
import 'package:dna/secure_storage/secure_storage_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dna/mainScreen/account_drawer.dart';
import 'edit_profile.dart';

class AccountDrawer extends ConsumerWidget {
  const AccountDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      width: 240,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/Images/blue_house.webp'),
            ),
            accountName: Text("accountName"),
            accountEmail: Text("accountEmail"),
            decoration: BoxDecoration(color: Colors.grey[600]),
          ),
          ListTile(
            title: const Text(
              "개인정보 수정",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
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
