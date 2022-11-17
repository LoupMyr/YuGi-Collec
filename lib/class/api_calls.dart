import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Api {
  Future<dynamic> getCard(value) async {
    String url =
        'https://db.ygoprodeck.com/api/v7/cardinfo.php?id=$value';
    var response = await http.get(Uri.parse(url));
    return convert.jsonDecode(response.body);
  }
}
