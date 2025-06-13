import 'package:flutter/material.dart';

class BirthYearDropdown extends StatefulWidget {
  const BirthYearDropdown({super.key});

  @override
  State<BirthYearDropdown> createState() => _BirthYearDropdownState();
}

class _BirthYearDropdownState extends State<BirthYearDropdown> {
  String? selectedYear;

  // 최근 100년치 리스트 생성
  final List<String> years = List.generate(
    100,
        (index) => (DateTime.now().year - index).toString(),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150, // SizedBox로 가로 너비 제한
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: '출생 연도',
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black45, width: 2)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black45)),
        ),
        value: selectedYear,
        items: years.map((year) {
          return DropdownMenuItem(
            value: year,
            child: Container(
              width: 80, // 드롭다운 항목 가로 너비 제한
              alignment: Alignment.centerLeft,
              child: Text('$year년', overflow: TextOverflow.ellipsis),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedYear = value;
          });
        },
      ),
    );
  }
}
