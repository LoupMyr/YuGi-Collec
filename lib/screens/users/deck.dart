import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:yugioh_api/class/api_account.dart';
import 'package:yugioh_api/class/api_yugioh.dart';
import 'dart:convert' as convert;

class DeckPage extends StatefulWidget {
  const DeckPage({super.key, required this.title});

  final String title;
  @override
  State<DeckPage> createState() => DeckPageState();
}

class DeckPageState extends State<DeckPage> {
  final ApiAccount _apiAcc = ApiAccount();
  final ApiYGO _apiYgo = ApiYGO();
  List<dynamic> _cardsUri = [];
  bool recupDataBool = false;
  final List<String> _tabUrl = [];
  var _idDeck = -1;

  void recupCards() async {
    var deck = await _apiAcc.getDeckById(_idDeck);
    _cardsUri = deck['cartes'];
    for(int i = 0; i < _cardsUri.length; i++){
      List<String> temp = _cardsUri[i].split('/');
      int idCardSrv = int.parse(temp[temp.length - 1]);
      var cardSrv = await _apiAcc.getCardById(idCardSrv);
      var response = await _apiYgo.getCardById(cardSrv['numCarte']);
      var cardApi = convert.jsonDecode(response.body);
      _tabUrl.add(cardApi['data'][0]['card_images'][0]['image_url'].toString());

    }
    setState(() {
      recupDataBool = true;
    });
  }

  Widget buildCards() {
    List<Widget> tabChildren = [];
    if (_cardsUri.isEmpty) {
      tabChildren.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text("You haven't cards in this deck yet."),
          Text(' Lets start adding some !'),
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
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.08)),
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
                  'Are you sure you want to delete this card from your deck ?'),
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

  Future<void> deleteCard(int id) async {
    _cardsUri.removeAt(id);
    await _apiAcc.patchDeckRemoveCard(_idDeck, _cardsUri);
    setState(() {
      buildCards();
      _cardsUri;
    });
    Navigator.of(context).pop();
  }

  Future<void> printCard(int id) async{
    List<String> temp = _cardsUri[id].split('/');
    int length = temp.length;
    int idCardSrv = int.parse(temp[length - 1]);
    var cardYGO = await _apiAcc.getCardById(idCardSrv);
    Navigator.pushNamed(context, "/routeCardInfo",
        arguments: cardYGO['numCarte']);
  }

  @override
  Widget build(BuildContext context) {
    _idDeck = ModalRoute.of(context)?.settings.arguments as int;
    if (recupDataBool) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Row(
                children: <Widget>[
                  buildCards(),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      recupCards();
      return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SpinKitCubeGrid(
                        color: Colors.orange,
                        size: 100,
                      )
                    ])
              ]));
    }
  }
}
