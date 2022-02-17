import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class HttpMethods {
  static Map<String, String> headers = {"Content-type": "application/json", "Authorization":"patildarshan66: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"};

  static Future<dynamic> getRequest(String url) async {
    try {
      print("================= Request URL ==============");
      print("================= $url ==============");

      final res = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      print("================= Status code ==============");
      print("================= ${res.statusCode} ==============");
      print("================= Response Body Start ==============");
      log(res.body);
      if (res.statusCode != 200) {
        final resp =json.decode(res.body);
        throw resp['message'];
      }
      return json.decode(res.body);
    } catch (e) {
      rethrow;
    }
  }
}
