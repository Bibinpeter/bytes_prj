import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseurl = 'https://my-store.in/v2/products/api/';
  static const String getProductEndPoint = 'getProductsList';

  Future<List<dynamic>> getProducts(int page) async {
    final url = Uri.parse(baseurl + getProductEndPoint);
    final headers = {'appid': '2IPbyrCUM7s5JZhnB9fxFAD6'};
    final body = {'page': page.toString()};

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['list'] != null && data['list'] is List) {
        print(data['list']);
        return data['list'] as List;
      } else {
        print(data['list']);
        throw Exception('Products data is null or not a list');
      }
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }
}
