import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yugioh_api/class/api_account.dart';
import 'package:yugioh_api/class/api_yugioh.dart';
import 'package:yugioh_api/screens/search/searchId.dart';
import 'package:yugioh_api/screens/search/searchType.dart';
import 'dart:convert' as convert;

class LevelPage extends StatefulWidget {
  const LevelPage({super.key, required this.title});

  final String title;

  @override
  LevelPageState createState() => LevelPageState();
}

class LevelPageState extends State<LevelPage> {
  final _formKey = GlobalKey<FormState>();
  String _value = '';
  final ApiYGO _apiYGO = ApiYGO();
  final ApiAccount _apiAcc = ApiAccount();
  var _cards;
  final List<Widget> _tabChildren = [];
  double _height = 0;
  Widget _widgetError = const Text('');

  void recupCards() async {
    var response = await _apiYGO.getCardsByLevel(_value);
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
          Text('Please enter a valid level'),
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
              'Type:  ${_cards['data'][i]['type']}',
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
      _height = MediaQuery.of(context).size.height * 0.9;
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
            onPressed: buildDecksChoice,
            child: const Text('To one of your decks'),
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

  void saveToCollection(numCard) async {
    await _apiAcc.postCard(numCard);
    String uriCard = await _apiAcc.getUriCard(numCard);
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
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        autofocus: true,
                        decoration: const InputDecoration(
                            hintText: '6...',
                            labelText: 'Search cards by Level:'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a level';
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
                      onPressed: () => null, icon: const Icon(Icons.filter_3)),
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
