import 'dart:convert';

import 'package:http/http.dart' as http;

import 'model.dart';

class ApiService {
  static Future<List<Shopping>?> apiData() async {
    http.Response response =
        await http.get(Uri.parse("https://fakestoreapi.com/products"));
    if (response.statusCode == 200) {
      print("Response==>>${jsonDecode(response.body)}");
      return shoppingFromJson(response.body);
    }
  }
}
