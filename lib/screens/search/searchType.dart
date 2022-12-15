import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yugioh_api/class/api_account.dart';
import 'package:yugioh_api/class/api_yugioh.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:yugioh_api/screens/search/searchId.dart';
import 'package:yugioh_api/screens/search/searchLevel.dart';

class TypePage extends StatefulWidget {
  const TypePage({super.key, required this.title});

  final String title;

  @override
  TypePageState createState() => TypePageState();
}

class TypePageState extends State<TypePage> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyDeck = GlobalKey<FormState>();
  String _value = '';
  final ApiYGO _apiYGO = ApiYGO();
  final ApiAccount _apiAcc = ApiAccount();
  var _cards;
  final List<Widget> _tabChildren = [];
  double _height = 0;
  Widget _widgetError = const Text('');
  String _nomDeck = '';

  void recupCards() async {
    var response = await _apiYGO.getCardsByType(_value);
    if (response.statusCode == 200) {
      _cards = convert.jsonDecode(response.body);
      _widgetError = const Text('');
      buildCards();
    } else {
      buildError();
    }
  }

  void buildError() {
    setState(() {
      _widgetError = Column(
        children: const <Widget>[
          Text('Please enter a valid type'),
        ],
      );
    });
  }

  void buildCards() {
    _tabChildren.clear();
    for (int i = 0; i < _cards['data'].length; i++) {
      String lvl = _cards['data'][i]['level'].toString();
      if (_cards['data'][i]['level'] == null) {
        lvl = 'none';
      }
      _tabChildren.add(SizedBox(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () => null,
              onLongPress: () => saveMenu(_cards['data'][i]['id'].toString()),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
              child: Image(
                image: NetworkImage(
                    _cards['data'][i]['card_images'][0]['image_url']),
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.6,
              ),
            ),
            Text(
              'Name: ${_cards['data'][i]['name']}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold, /*overflow: TextOverflow.ellipsis*/
              ),
            ),
            Text(
              'Type: ${_cards['data'][i]['type']}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Level: $lvl',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ));
    }
    setState(() {
      _tabChildren;
      _height = MediaQuery.of(context).size.height * 0.8;
    });
  }

  Future<String?> saveMenu(String numCard) {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text('Save card'),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () => saveToCollection(numCard),
            child: const Text('To your collection'),
          ),
          SimpleDialogOption(
            onPressed: () async {
              Navigator.pop(context);
              await buildDecksChoice(numCard);
            },
            child: const Text('To one of your decks'),
          ),
        ],
      ),
    );
  }

  Future<String?> buildDecksChoice(String numCard) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text('Choose a deck'),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: ()=>formCreateDeck(numCard),
            child: const Text('Create a new deck'),
          ),
          SimpleDialogOption(
            onPressed: () => getDecksList(numCard),
            child: const Text('To an existing deck'),
          ),
        ],
      ),
    );
  }

  void getDecksList(String numCard) async{
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
    buildListDecks(listDecks, numCard);
  }

  Future<String?> buildListDecks(List<dynamic> lesDecks, String numCard) {
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
              onPressed: () => saveToDeck(lesDecks[i]['id'], numCard),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
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
  
  Future<String?> formCreateDeck(String numCard) {
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
                      createDeck(numCard);
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

  void saveToDeck(int id, String numCard) async {
    await _apiAcc.postCard(numCard);
    String uriCard = await _apiAcc.getUriCard(numCard);
    var deck = await _apiAcc.getDeckById(id);
    List<dynamic> listCards = deck['cartes'];
    var patch = await _apiAcc.patchDeckAddCard(id, listCards, uriCard);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void createDeck(String numCard) async {
    String uriuser = await _apiAcc.getUriUser();
    var response = await _apiAcc.postDeck(_nomDeck, uriuser);
    var body = convert.json.decode(response.body);
    saveToDeck(body['id'], numCard);

    Navigator.pop(context);
  }

  void saveToCollection(String numCard) async {
    await _apiAcc.postCard(numCard);
    String uriCard = await _apiAcc.getUriCard(numCard);
    String uriUser = await _apiAcc.getUriUser();
    if (await _apiAcc.checkCollecByUriUser(uriUser) == false) {
      var postCollec = await _apiAcc.postCollec(uriUser);
    }
    int idCollec = await _apiAcc.getCollecIdByUriUser(uriUser);
    List<dynamic> listCards = await _apiAcc.getListCardsFromCollec(idCollec);
    await _apiAcc.patchCollecAddCard(idCollec, listCards, uriCard);
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
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _widgetError,
              CarouselSlider(
                items: _tabChildren,
                options: CarouselOptions(
                  enlargeCenterPage: false,
                  height: _height,
                  autoPlay: true,
                  autoPlayCurve: Curves.easeInOutCirc,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(seconds: 5),
                  viewportFraction: 0.8,
                ),
              ),
              SizedBox(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z ]')),
                        ],
                        autofocus: true,
                        decoration: const InputDecoration(
                            hintText: 'XYZ Monster...',
                            labelText: 'Search cards by Type:'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a type';
                          } else {
                            _value = value.toString();
                          }
                        },
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10)),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            recupCards();
                          }
                        },
                        child: const Text("Search"),
                      ),
                      const Padding(padding: EdgeInsets.all(15)),
                    ],
                  ),
                ),
              ),
              /*DropdownButton<String>(
                value: 'Predefined types',
                icon: const Icon(Icons.arrow_downward_rounded),
                onChanged: (String? value) {
                  setState(() {
                    _value = value.toString();
                  });
                  recupCards();
                },
                items: _list.map<DropdownMenuItem<String>>((String value) {
                  print(value);
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),*/
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
                      onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const IdPage(title: 'Yu-Gi-Oh! - Find By Id'),
                          )),
                      icon: const Icon(Icons.filter_1)),
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
                      onPressed: () => null, icon: const Icon(Icons.filter_2)),
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
