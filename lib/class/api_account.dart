import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ApiAccount {
  Future<http.Response> createAccount(String login, String mdp) {
    return http.post(
      Uri.parse('https://s3-4428.nuage-peda.fr/yugiohApi/public/api/users'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode(<String, dynamic>{
        "username": login,
        "roles": ["ROLE_USER"],
        "password": mdp,
      }),
    );
  }
}
