import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yugioh_api/class/api_account.dart';
import 'package:yugioh_api/class/api_yugioh.dart';
import 'package:http/http.dart' as http;
import 'package:yugioh_api/screens/search/searchLevel.dart';
import 'dart:convert' as convert;
import 'package:yugioh_api/screens/search/searchType.dart';

class IdPage extends StatefulWidget {
  const IdPage({super.key, required this.title});

  final String title;

  @override
  IdPageState createState() => IdPageState();
}

class IdPageState extends State<IdPage> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyDeck = GlobalKey<FormState>();
  int _value = -1;
  final ApiYGO _apiYGO = ApiYGO();
  final ApiAccount _apiAcc = ApiAccount();
  var _card;
  Widget _widgetCard = Container();
  String _numCard = '';
  String _nomDeck = '';

  void recupCard() async {
    var response = await _apiYGO.getCardById(_value);
    if (response.statusCode == 200) {
      _card = convert.jsonDecode(response.body);
      _numCard = _card['data'][0]['id'].toString();
      buildCard();
    } else {
      buildError();
    }
  }

  void buildError() {
    setState(() {
      _widgetCard = Column(
        children: const <Widget>[
          Text('Please enter a valid ID'),
        ],
      );
    });
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
            'Name: ${_card['data'][0]['name']}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'Type: ${_card['data'][0]['type']}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'Level: ${_card['data'][0]['level']}',
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
            child: const Text('To your collection'),
          ),
          SimpleDialogOption(
            onPressed: () async {
              Navigator.pop(context);
              await buildDecksChoice();
            },
            child: const Text('To one of your decks'),
          ),
        ],
      ),
    );
  }


  Future<String?> buildDecksChoice() async {
    var decks = await _apiAcc.getDecks();
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text('Choose a deck'),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: formCreateDeck,
            child: const Text('Create a new deck'),
          ),
          SimpleDialogOption(
            onPressed: getDecksList,
            child: const Text('To an existing deck'),
          ),
        ],
      ),
    );
  }

  void getDecksList() async{
    String uriUser = await _apiAcc.getUriUser();
    List<String> temp = uriUser.split('/');
    int longeur = temp.length;
    int idUser = int.parse(temp[longeur - 1]);
    var user = await _apiAcc.getUserById(idUser);
    List<dynamic> decks = user['decks'];
    List<dynamic> listDecks = [];
    for (int i = 0; i < decks.length; i++) {
      List<String> temp = decks[i].split('/');
      int longeur = temp.length;
      int idDeck = int.parse(temp[longeur - 1]);
      listDecks.add(await _apiAcc.getDeckById(idDeck));
    }
    buildListDecks(listDecks);
  }

  Future<String?> buildListDecks(List<dynamic> lesDecks) {
    List<Widget> tabChildren = [];
    if (lesDecks.isEmpty) {
      tabChildren.add(
        const SizedBox(
          child: Text('You have no deck yet, let\s create some !'),
        ),
      );
    }
    for (int i = 0; i < lesDecks.length; i++) {
      tabChildren.add(Row(
        children: [
          Card(
            elevation: 0,
            child: ElevatedButton(
              onPressed: () => saveToDeck(lesDecks[i]['id']),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.51,
                height: MediaQuery.of(context).size.width * 0.05,
                child: Center(
                  child: Text(lesDecks[i]['nom']),
                ),
              ),
            ),
          ),
        ],
      ));
    }
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Select a deck'),
        content: Column(
          children: tabChildren,
        ),
      ),
    );
  }

  Future<String?> formCreateDeck() {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Enter a name'),
        content: Form(
          key: _formKeyDeck,
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "Name"),
                  validator: (valeur) {
                    if (valeur == null || valeur.isEmpty) {
                      return 'Please enter a name';
                    } else {
                      _nomDeck = valeur.toString();
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKeyDeck.currentState!.validate()) {
                      createDeck();
                    }
                  },
                  child: const Text("Valid"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveToDeck(int id) async {
    await _apiAcc.postCard(_numCard);
    String uriCard = await _apiAcc.getUriCard(_numCard);
    var deck = await _apiAcc.getDeckById(id);
    List<dynamic> listCards = deck['cartes'];
    var patch = await _apiAcc.patchDeckAddCard(id, listCards, uriCard);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void createDeck() async {
    String uriuser = await _apiAcc.getUriUser();
    var response = await _apiAcc.postDeck(_nomDeck, uriuser);
    var body = convert.json.decode(response.body);
    saveToDeck(body['id']);

    Navigator.pop(context);
  }

  void saveToCollection() async {
    await _apiAcc.postCard(_numCard);
    String uriCard = await _apiAcc.getUriCard(_numCard);
    String uriUser = await _apiAcc.getUriUser();
    if (await _apiAcc.checkCollecByUriUser(uriUser) == false) {
      await _apiAcc.postCollec(uriUser);
    }
    int idCollec = await _apiAcc.getCollecIdByUriUser(uriUser);
    List<dynamic> listCards = await _apiAcc.getListCardsFromCollec(idCollec);
    var patch = await _apiAcc.patchCollecAddCard(idCollec, listCards, uriCard);
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
              SizedBox(
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
        child: SizedBox(
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
