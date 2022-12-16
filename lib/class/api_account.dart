import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:yugioh_api/class/local.dart';

class ApiAccount {
  final String _login = localLogin;
  final String _mdp = localPassword;
  final String _token = localToken;

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

  Future<void> UpdateToken() async {
    var connexion = await getToken(_login, _mdp);
    if (connexion.statusCode == 200) {
      var data = convert.jsonDecode(connexion.body);
      localToken = data['token'].toString();
    }
  }

  Future<dynamic> getUsers() async {
    String url = 'https://s3-4428.nuage-peda.fr/yugiohApi/public/api/users';
    var response = await http.get(Uri.parse(url));
    return convert.jsonDecode(response.body);
  }

  Future<dynamic> getUserById(int id) async {
    String url =
        'http://s3-4428.nuage-peda.fr/yugiohApi/public/api/users/${id.toString()}';
    var response = await http.get(Uri.parse(url));
    var result = convert.jsonDecode(response.body);
    return result;
  }

  Future<String> getUriUser() async {
    var users = await getUsers();
    String uri = '';
    for (var elt in users['hydra:member']) {
      if (elt['username'] == _login) {
        uri = elt['@id'];
      }
    }
    return uri;
  }

  // Actions sur Cartes
  Future<http.Response> postCard(String numCard) async {
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

  Future<dynamic> getCardById(int id) async {
    String url = 'https://s3-4428.nuage-peda.fr/yugiohApi/public/api/cartes/' +
        id.toString();
    var response = await http.get(Uri.parse(url));
    return convert.jsonDecode(response.body);
  }

  Future<String> getUriCard(String numCard) async {
    var cards = await getCards();
    String uri = '';
    for (var elt in cards['hydra:member']) {
      if (elt['numCarte'] == numCard) {
        uri = elt['@id'];
      }
    }
    return uri;
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

  // Actions sur Collections
  Future<http.Response> postCollec(String userUri) async {
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
    int id = -1;
    var collecs = await getCollecs();
    for (var elt in collecs['hydra:member']) {
      if (elt['user'] == uriUser) {
        id = elt['id'];
      }
    }
    return id;
  }

  Future<http.Response> patchCollecAddCard(
      int id, List<dynamic> listCards, String cardUri) async {
    listCards.add(cardUri);
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

  Future<http.Response> patchCollecRemoveCard(
      int id, List<dynamic> listCards) async {
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

  // Actions sur Decks
  Future<http.Response> postDeck(String nom, String uriuser) {
    var response = http.post(
      Uri.parse('https://s3-4428.nuage-peda.fr/yugiohApi/public/api/decks'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode(<String, dynamic>{'nom': nom, 'user': uriuser}),
    );
    return response;
  }

  Future<dynamic> getDecks() async {
    String url = 'https://s3-4428.nuage-peda.fr/yugiohApi/public/api/decks';
    var response = await http.get(Uri.parse(url));
    var data = convert.jsonDecode(response.body);
    return data;
  }

  Future<http.Response> patchDeckAddCard(
      int id, List<dynamic> listCards, String cardUri) async {
    listCards.add(cardUri);
    var json = convert.jsonEncode(<String, dynamic>{"cartes": listCards});
    return await http.patch(
        Uri.parse('https://s3-4428.nuage-peda.fr/yugiohApi/public/api/decks/' +
            id.toString()),
        headers: <String, String>{
          'Accept': 'application/ld+json',
          'Content-Type': 'application/merge-patch+json',
        },
        body: json);
  }

  Future<http.Response> patchDeckEditName(
      int id, String name) async {
    var json = convert.jsonEncode(<String, dynamic>{"nom": name});
    return await http.patch(
        Uri.parse('https://s3-4428.nuage-peda.fr/yugiohApi/public/api/decks/' +
            id.toString()),
        headers: <String, String>{
          'Accept': 'application/ld+json',
          'Content-Type': 'application/merge-patch+json',
        },
        body: json);
  }

  Future<http.Response> patchDeckRemoveCard(
      int id, List<dynamic> listCards) async {
    var json = convert.jsonEncode(<String, dynamic>{"cartes": listCards});
    return await http.patch(
        Uri.parse(
            'https://s3-4428.nuage-peda.fr/yugiohApi/public/api/decks/' +
                id.toString()),
        headers: <String, String>{
          'Accept': 'application/ld+json',
          'Content-Type': 'application/merge-patch+json',
        },
        body: json);
  }

  Future<dynamic> getDeckById(int id) async {
    String url = 'https://s3-4428.nuage-peda.fr/yugiohApi/public/api/decks/' +
        id.toString();
    var response = await http.get(Uri.parse(url));
    return convert.jsonDecode(response.body);
  }

  Future<http.Response> deleteDeck(int id) async{
    String url = 'https://s3-4428.nuage-peda.fr/yugiohApi/public/api/decks/' +
        id.toString();
    return await http.delete(Uri.parse(url));
  }
}
