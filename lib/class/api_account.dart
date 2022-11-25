import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:yugioh_api/class/local.dart';

class ApiAccount {
  String _login = localLogin;
  String _mdp = localPassword;
  String _token = localToken;

  // Actions sur User / token
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

  Future<http.Response> getToken(String login, String mdp) async {
    var response = await http.post(
      Uri.parse(
          'https://s3-4428.nuage-peda.fr/yugiohApi/public/api/authentication_token'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode(<String, dynamic>{
        "username": login,
        "password": mdp,
      }),
    );

    return response;
  }

  Future<dynamic> getUsers() async {
    String url = 'https://s3-4428.nuage-peda.fr/yugiohApi/public/api/users';
    var response = await http.get(Uri.parse(url));
    // print('getUsers: ' + response.statusCode.toString());

    return convert.jsonDecode(response.body);
  }

  Future<String> getUriUser() async {
    // print('getUriUser');
    var users = await getUsers();
    String uri = '';
    for (var elt in users['hydra:member']) {
      if (elt['username'] == _login) {
        uri = elt['@id'];
      }
    }
    print('uriUser: ' + uri);
    return uri;
  }

  // Actions sur Cartes
  Future<http.Response> postCard(String numCard) async {
    // print('postCard');
    return await http.post(
      Uri.parse('https://s3-4428.nuage-peda.fr/yugiohApi/public/api/cartes'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode(<String, dynamic>{
        "numCarte": numCard,
      }),
    );
  }

  Future<dynamic> getCards() async {
    String url = 'https://s3-4428.nuage-peda.fr/yugiohApi/public/api/cartes';
    var response = await http.get(Uri.parse(url));
    return convert.jsonDecode(response.body);
  }

  Future<String> getUriCard(String numCard) async {
    // print('getUriCard');
    var cards = await getCards();
    String uri = '';
    for (var elt in cards['hydra:member']) {
      if (elt['numCarte'] == numCard) {
        uri = elt['@id'];
      }
    }
    print('uriCard: ' + uri);
    return uri;
  }

  // Actions sur Collections
  Future<http.Response> postCollec(String userUri) async {
    // print('postCollec');
    // print(userUri);
    return await http.post(
      Uri.parse('https://s3-4428.nuage-peda.fr/yugiohApi/public/api/collecs'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode(<String, dynamic>{
        "user": userUri,
      }),
    );
  }

  Future<dynamic> getCollecs() async {
    String url = 'https://s3-4428.nuage-peda.fr/yugiohApi/public/api/collecs';
    var response = await http.get(Uri.parse(url));
    var data = convert.jsonDecode(response.body);
    return data;
  }

  Future<bool> checkCollecByUriUser(String uriUser) async {
    // print('checkCollec');
    bool alreadyExist = false;
    var collecs = await getCollecs();
    for (var elt in collecs['hydra:member']) {
      if (elt['user'] == uriUser) {
        alreadyExist = true;
      }
    }
    return alreadyExist;
  }

  Future<int> getCollecIdByUriUser(String uriUser) async {
    // print('getCollectByUriUser');
    int id = -1;
    var collecs = await getCollecs();
    for (var elt in collecs['hydra:member']) {
      if (elt['user'] == uriUser) {
        id = elt['id'];
      }
    }
    print('idCollec: ' + id.toString());
    return id;
  }

  Future<http.Response> patchCollec(
      int id, List<dynamic> listCards, String cardUri) async {
    print('cardUri Patch: ' + cardUri);
    print('id Collec: ' + id.toString());
    listCards.add(cardUri);
    print(listCards.toString());
    var json = convert.jsonEncode(<String, dynamic>{"cartes": listCards});
    return await http.patch(
        Uri.parse(
            'https://s3-4428.nuage-peda.fr/yugiohApi/public/api/collecs/' +
                id.toString()),
        headers: <String, String>{
          'Accept': 'application/ld+json',
          'Content-Type': 'application/merge-patch+json',
        },
        body: json);
  }

  Future<List<dynamic>> getListCardsFromCollec(idCollec) async {
    String url = 'https://s3-4428.nuage-peda.fr/yugiohApi/public/api/collecs/' +
        idCollec.toString();
    var response = await http.get(Uri.parse(url));
    List<dynamic> tab = [];
    if (response.statusCode == 200) {
      var data = convert.jsonDecode(response.body);
      tab = data['cartes'];
    }
    return tab;
  }
}
