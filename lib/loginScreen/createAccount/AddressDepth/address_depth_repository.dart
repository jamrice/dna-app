import 'dart:convert';
import 'address_depth_server_model.dart';
import 'package:http/http.dart' as http;

class AppAddressRepository {
  static final AppAddressRepository instance = AppAddressRepository._internal();

  factory AppAddressRepository() => instance;

  AppAddressRepository._internal();

  Future<String?> getSgisApiAccessToken() async {
    try {
      const String _key = '991ae11366954e35960a';
      const String _secret = '11be058f67b54defa2de';
      http.Response _response = await http.get(
        Uri.parse(
            "https://sgisapi.kostat.go.kr/OpenAPI3/auth/authentication.json?consumer_key=$_key&consumer_secret=$_secret"),
      );
      if (_response.statusCode == 200) {
        Map<String, dynamic> _body =
            json.decode(_response.body) as Map<String, dynamic>;
        String _accessToken = _body["result"]["accessToken"];
        return _accessToken;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  Future<List<AddressDepthServerModel>> depthAddressInformation({
    required String token,
    String? code,
  }) async {
    try {
      String? _code = code == null ? "" : "&cd=$code";
      http.Response _response = await http.get(Uri.parse(
          "https://sgisapi.kostat.go.kr/OpenAPI3/addr/stage.json?accessToken=$token$_code"));
      if (_response.statusCode == 200) {
        Map<String, dynamic> _body =
        json.decode(_response.body) as Map<String, dynamic>;
        List<dynamic> _result = _body["result"];
        List<AddressDepthServerModel> _model =
        _result.map((e) => AddressDepthServerModel.fromJson(e)).toList();
        return _model;
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }
}
