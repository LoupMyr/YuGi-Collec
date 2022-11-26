import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ApiYGO {
  Future<http.Response> getCardById(value) async {
    String url = 'https://db.ygoprodeck.com/api/v7/cardinfo.php?id=$value';
    return await http.get(Uri.parse(url));
  }

  Future<http.Response> getCardsByType(value) async {
    String url = 'https://db.ygoprodeck.com/api/v7/cardinfo.php?type=$value';
    return await http.get(Uri.parse(url));

  }

  Future<http.Response> getCardsByLevel(value) async {
    String url = 'https://db.ygoprodeck.com/api/v7/cardinfo.php?level=$value';
    return await http.get(Uri.parse(url));
  }
}
