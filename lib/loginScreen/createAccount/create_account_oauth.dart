import 'package:flutter/material.dart';
import 'AddressDepth/address_depth_screen.dart';
import 'birthyear_dropdownbutton.dart';

class CreateAccountOauth extends StatefulWidget {
  final String route;

  const CreateAccountOauth({super.key, required this.route});

  @override
  State<CreateAccountOauth> createState() => _CreateAccountOauthState();
}

class _CreateAccountOauthState extends State<CreateAccountOauth> {
  late String _route;
  String token = '';
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();

  Future<void> _selectAddress() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddressDepthScreen(),
      ),
    );

    if (result != null && result is String) {
      _addressController.text = result;
    }
  }

  @override
  void initState() {
    super.initState();
    _route = widget.route;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "회원가입",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Row(
                children: [
                  Text(
                    "가입경로: ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  routeIcon(_route),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "별명",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: _nicknameController,
                readOnly: false,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black45)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black45, width: 2)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black45)),
                  labelText: "별명",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "주소 입력",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: _addressController,
                readOnly: true,
                onTap: _selectAddress,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black45)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black45, width: 2)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black45)),
                  labelText: "주소 선택",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "태어난 날",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              BirthYearDropdown(),
              SizedBox(
                height: 60,
              ),
              Center(
                child: TextButton(
                    style: TextButton.styleFrom(
                      fixedSize: Size(200, 50),
                      backgroundColor: Colors.grey[600],
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      //회원가입 로직
                    },
                    child: Text("회원가입")),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget routeIcon(String route) {
    return SizedBox(
      height: 25,
      width: 25,
      child: Image.asset(
        _getRouteAsset(route),
        fit: BoxFit.contain,
      ),
    );
  }

  String _getRouteAsset(String route) {
    switch (route) {
      case 'naver':
        return 'assets/Icons/naver_login_button.png';
      case 'google':
        return 'assets/Icons/google_logo.png';
      case 'kakao':
        return 'assets/icons/car.png';
      default:
        return '';
    }
  }
}
