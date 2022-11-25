import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yugioh_api/class/api_account.dart';
import 'package:yugioh_api/class/api_yugioh.dart';
import 'package:http/http.dart' as http;
import 'package:yugioh_api/screens/searchLevel.dart';
import 'dart:convert' as convert;
import 'package:yugioh_api/screens/searchType.dart';

class IdPage extends StatefulWidget {
  const IdPage({super.key, required this.title});

  final String title;

  @override
  IdPageState createState() => IdPageState();
}

class IdPageState extends State<IdPage> {
  final _formKey = GlobalKey<FormState>();
  int _value = -1;
  ApiYGO _apiYGO = ApiYGO();
  ApiAccount _apiAcc = ApiAccount();
  var _card;
  Widget _widgetCard = Container();
  String _numCard = '';

  void recupCard() async {
    _card = await _apiYGO.getCardById(_value);
    _numCard = _card['data'][0]['id'].toString();
    buildCard();
  }

  void buildCard() {
    setState(() {
      _widgetCard = Column(
        children: [
          ElevatedButton(
            onPressed: () => null,
            onLongPress: saveMenu,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white)),
            child: Image(
              image:
                  NetworkImage(_card['data'][0]['card_images'][0]['image_url']),
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.6,
            ),
          ),
          Text(
            'Name: ' + _card['data'][0]['name'],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'Type: ' + _card['data'][0]['type'],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'Level: ' + _card['data'][0]['level'].toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      );
    });
  }

  Future<String?> saveMenu() {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text('Save card'),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: saveToCollection,
            child: Text('To your collection'),
          ),
          SimpleDialogOption(
            onPressed: buildDecksChoice,
            child: Text('To one of your decks'),
          ),
        ],
      ),
    );
  }

  void buildDecksChoice() {
    Navigator.pop(context);
  }

  void saveToDecks() {
    Navigator.pop(context);
  }

  void saveToCollection() async {
    await _apiAcc.postCard(_numCard);
    String uriCard = await _apiAcc.getUriCard(_numCard);
    String uriUser = await _apiAcc.getUriUser();
    if (await _apiAcc.checkCollecByUriUser(uriUser) == false) {
      var postCollec = await _apiAcc.postCollec(uriUser);
      print('Post Collec: ' + postCollec.statusCode.toString());
    }
    int idCollec = await _apiAcc.getCollecIdByUriUser(uriUser);
    List<dynamic> listCards = await _apiAcc.getListCardsFromCollec(idCollec);
    var patch = await _apiAcc.patchCollec(idCollec, listCards, uriCard);
    print('Patch Collec: ' + patch.statusCode.toString());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _widgetCard,
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        autofocus: true,
                        decoration: const InputDecoration(
                            hintText: '6983839...',
                            labelText: 'Search a card by ID:'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an ID';
                          } else {
                            _value = int.parse(value);
                          }
                        },
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10)),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            recupCard();
                          }
                        },
                        child: const Text("Search"),
                      ),
                      const Padding(padding: EdgeInsets.all(15)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.vertical,
                children: [
                  IconButton(
                      onPressed: () => null, icon: const Icon(Icons.filter_1)),
                  const Text(
                    "ById",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.vertical,
                children: [
                  IconButton(
                      onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TypePage(
                                title: 'Yu-Gi-Oh! - Find By Type'),
                          )),
                      icon: const Icon(Icons.filter_2)),
                  const Text(
                    "ByType",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.vertical,
                children: [
                  IconButton(
                      onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LevelPage(
                                title: 'Yu-Gi-Oh! - Find By Level'),
                          )),
                      icon: const Icon(Icons.filter_3)),
                  const Text(
                    "ByLevel",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
