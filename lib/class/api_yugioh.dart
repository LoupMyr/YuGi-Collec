import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ApiYGO {
  Future<dynamic> getCardById(value) async {
    String url = 'https://db.ygoprodeck.com/api/v7/cardinfo.php?id=$value';
    var response = await http.get(Uri.parse(url));
    return convert.jsonDecode(response.body);
  }

  Future<dynamic> getCardsByType(value) async {
    String url = 'https://db.ygoprodeck.com/api/v7/cardinfo.php?type=$value';
    var response = await http.get(Uri.parse(url));
    return convert.jsonDecode(response.body);
  }

  Future<dynamic> getCardsByLevel(value) async {
    String url = 'https://db.ygoprodeck.com/api/v7/cardinfo.php?level=$value';
    var response = await http.get(Uri.parse(url));
    return convert.jsonDecode(response.body);
  }
}
