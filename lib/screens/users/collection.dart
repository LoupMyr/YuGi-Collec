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
  var _cardsUri;
  final ApiAccount _apiAcc = ApiAccount();
  final ApiYGO _apiYgo = ApiYGO();
  final List<String> _tabUrl = [];
  int _idCollec = -1;
  bool _recupCardsBool = false;

  Future<String> recupCardsOfCollec() async {
    _tabUrl.clear();
    String uriUser = await _apiAcc.getUriUser();
    _idCollec = await _apiAcc.getCollecIdByUriUser(uriUser);
    _cardsUri = await _apiAcc.getListCardsFromCollec(_idCollec);

    for (int i = 0; i < _cardsUri.length; i++) {
      List<String> temp = _cardsUri[i].split('/');
      int longeur = temp.length;
      int idCardSrv = int.parse(temp[longeur - 1]);

      var cardSrv = await _apiAcc.getCardById(idCardSrv);
      var response = await _apiYgo.getCardById(cardSrv['numCarte']);
      var cardApi = convert.jsonDecode(response.body);
      _tabUrl.add(cardApi['data'][0]['card_images'][0]['image_url'].toString());
    }
    _recupCardsBool = true;
    return '';
  }

  Widget buildCards() {
    List<Widget> tabChildren = [];
    if (_cardsUri.length == 0) {
      tabChildren.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "You haven't cards in your collection yet.\nLets start adding some !",
          ),
        ],
      ));
    } else {
      for (int i = 0; i < _cardsUri.length; i = i + 2) {
        try {
          tabChildren.add(Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildImg(i),
              Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.1)),
              buildImg(i + 1),
            ],
          ));
        } catch (e) {
          tabChildren.add(Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildImg(i),
            ],
          ));
        }
      }
    }
    return Column(
      children: tabChildren,
    );
  }

  Widget buildImg(int id) {
    return ElevatedButton(
      onPressed: () => printCard(id),
      onLongPress: () => deleteMenu(id),
      style:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
      child: Image(
        image: NetworkImage(_tabUrl[id]),
        height: MediaQuery.of(context).size.height * 0.30,
        width: MediaQuery.of(context).size.width * 0.30,
      ),
    );
  }

  Future<String?> deleteMenu(int id) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete card'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text(
                  'Are you sure you want to delete this card from your collection ?'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => deleteCard(id),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<void> printCard(int id) async {
    List<String> temp = _cardsUri[id].split('/');
    int length = temp.length;
    int idCardSrv = int.parse(temp[length - 1]);
    var cardYGO = await _apiAcc.getCardById(idCardSrv);
    Navigator.pushNamed(context, "/routeCardInfo",
        arguments: cardYGO['numCarte']);
  }

  Future<void> deleteCard(int id) async {
    _cardsUri.removeAt(id);
    await _apiAcc.patchCollecRemoveCard(_idCollec, _cardsUri);
    setState(() {
      _cardsUri;
      buildCards();
      _recupCardsBool = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Card successfully deleted'),
    ));
    Duration(seconds: 2);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: recupCardsOfCollec(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            if (_recupCardsBool) {
              children = <Widget>[
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Row(
                  children: <Widget>[
                    buildCards(),
                  ],
                ),
              ];
            } else {
              recupCardsOfCollec();
              children = <Widget>[
                const SpinKitWave(
                  color: Colors.orange,
                  size: 100,
                )
              ];
            }
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
