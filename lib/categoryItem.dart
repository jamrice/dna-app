import 'package:flutter/material.dart';



// 카테고리에 있는 아이템을 생성

class CategoryGridItem extends StatelessWidget {
  final int index;

  CategoryGridItem({required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          switch (index) {
            case 0:
              print("$index");
              break;
            case 1:
              print("$index");
              break;
            case 2:
              print("$index");
              break;
            case 3:
              print("$index");
              break;
            case 4:
              print("$index");
              break;
            case 5:
              print("$index");
              break;
            case 6:
              print("$index");
              break;
          }
        },
        child: _buildGridItem(index));
  }

  Widget _buildGridItem(int index) {
    switch (index) {
      case 0:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.ac_unit_rounded),
            Text("$index"),
          ],
        );
      case 1:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.ac_unit_rounded),
            Text("$index"),
          ],
        );
      case 2:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.ac_unit_rounded),
            Text("$index"),
          ],
        );
      case 3:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.ac_unit_rounded),
            Text("$index"),
          ],
        );
      case 4:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.ac_unit_rounded),
            Text("$index"),
          ],
        );
      case 5:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.ac_unit_rounded),
            Text("$index"),
          ],
        );
      case 6:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.ac_unit_rounded),
            Text("$index"),
          ],
        );
      default:
        return Container();
    }
  }
}
