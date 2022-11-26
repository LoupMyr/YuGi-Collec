import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:yugioh_api/class/api_account.dart';
import 'package:yugioh_api/class/api_yugioh.dart';
import 'dart:convert' as convert;

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key, required this.title});

  final String title;

  @override
  CollectionPageState createState() => CollectionPageState();
}

class CollectionPageState extends State<CollectionPage> {
  var _cards;
  ApiAccount _apiAcc = ApiAccount();
  ApiYGO _apiYgo = ApiYGO();
  List<String> _tabUrl = [];

  Future<String> recupCardsOfCollec() async {
    _tabUrl.clear();
    String uriUser = await _apiAcc.getUriUser();
    int idCollec = await _apiAcc.getCollecIdByUriUser(uriUser);
    _cards = await _apiAcc.getListCardsFromCollec(idCollec);
    for (int i = 0; i < _cards.length; i++) {
      List<String> temp = _cards[i].split('/');
      int longeur = _cards[i].split('/').length;
      int idCardSrv = int.parse(temp[longeur - 1]);

      var cardSrv = await _apiAcc.getCardById(idCardSrv);
      var response = await _apiYgo.getCardById(cardSrv['numCarte']);
      var cardApi = convert.jsonDecode(response.body);
      _tabUrl.add(cardApi['data'][0]['card_images'][0]['image_url'].toString());
    }
    print(_tabUrl);
    await Future.delayed(const Duration(seconds: 2));
    return '';
  }

  Widget buildCards() {
    List<Widget> tabChildren = [];
    if (_cards.length == 0) {
      tabChildren.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text(
              "You haven't cards in your collection yet. Lets start adding some !")
        ],
      ));
    } else {
      for (int i = 0; i < _cards.length; i = i + 2) {
        try {
          tabChildren.add(Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: NetworkImage(_tabUrl[i]),
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.4,
              ),
              Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.1)),
              Image(
                image: NetworkImage(_tabUrl[i + 1]),
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.4,
              ),
            ],
          ));
        } catch (e) {
          tabChildren.add(Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: NetworkImage(_tabUrl[i]),
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.4,
              ),
            ],
          ));
        }
      }
    }

    return Column(
      children: tabChildren,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: recupCardsOfCollec(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Row(
                children: <Widget>[
                  buildCards(),
                ],
              ),
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const SpinKitWave(
                color: Colors.red,
              )
            ];
          } else {
            children = <Widget>[
              const SpinKitWave(
                color: Colors.orange,
                size: 100,
              )
            ];
          }
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(widget.title),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Column(children: children),
              ),
            ),
          );
        });
  }
}
