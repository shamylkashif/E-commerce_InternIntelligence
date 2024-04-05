import 'package:http/http.dart' as http;

class NetworkServices {

  static Future<http.Response?> postRequest({
    required String url,
    var body,
    var headers,
  }) async {
    try {
      var response =await http.post(
          Uri.parse(url),
          body: body, headers: headers);
      return response;
    } catch (e) {
      print("Exception: $e");

    }
  }
}
