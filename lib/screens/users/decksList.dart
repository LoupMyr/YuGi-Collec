import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:yugioh_api/class/api_account.dart';

class DecksListPage extends StatefulWidget {
  const DecksListPage({super.key, required this.title});

  final String title;

  @override
  DecksListPageState createState() => DecksListPageState();
}

class DecksListPageState extends State<DecksListPage> {
  final ApiAccount _apiAcc = ApiAccount();
  List<dynamic> _listDecks = [];
  final _formKeyDeckName = GlobalKey<FormState>();
  String _nomDeck = '';

  Future<String> recupDecks() async {
    _listDecks = [];
    String uriUser = await _apiAcc.getUriUser();
    List<String> temp = uriUser.split('/');
    int longeur = temp.length;
    int idUser = int.parse(temp[longeur - 1]);
    var user = await _apiAcc.getUserById(idUser);
    List<dynamic> decks = user['decks'];
    for (int i = 0; i < decks.length; i++) {
      List<String> temp = decks[i].split('/');
      int longeur = temp.length;
      int idDeck = int.parse(temp[longeur - 1]);
      _listDecks.add(await _apiAcc.getDeckById(idDeck));
    }
    return '';
  }

  Widget buildDecks() {
    List<Widget> tabChildren = [];
    if (_listDecks.isEmpty) {
      tabChildren.add(
        const SizedBox(
          child: Text('You have no deck yet, let\s create some !', overflow: TextOverflow.ellipsis),
        ),
      );
    }
    for (int i = 0; i < _listDecks.length; i++) {
      tabChildren.add(Row(
        children: [
          Card(
            elevation: 0,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "/routeDeck",
                  arguments: _listDecks[i]['id']),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.width * 0.12,
                child: Center(
                  child: Text(_listDecks[i]['nom']),
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsetsDirectional.all(5)),
          IconButton(
              onPressed: () => deleteDeckMenu(_listDecks[i]['id']),
              icon: Icon(Icons.delete)),
          const Padding(padding: EdgeInsetsDirectional.all(5)),
          IconButton(
              onPressed: () => editNameDeckMenu(_listDecks[i]['id'], _listDecks[i]['nom']),
              icon: Icon(Icons.edit))
        ],
      ));
    }
    return Column(
      children: tabChildren,
    );
  }

  Future<String?> deleteDeckMenu(int id) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete deck'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Are you sure you want to delete this deck ?'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => deleteDeck(id),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<void> deleteDeck(int idDeck) async {
    await _apiAcc.deleteDeck(idDeck);
    await recupDecks();
    setState(() {
      _listDecks;
      buildDecks();
    });
    Navigator.of(context).pop();
  }

  Future<void> editDeckName(int idDeck) async {
    await _apiAcc.patchDeckEditName(idDeck, _nomDeck);
    await recupDecks();
    setState(() {
      _listDecks;
      buildDecks();
    });
    Navigator.of(context).pop();
  }

  Future<String?> editNameDeckMenu(int idDeck, String nom) {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Edit name'),
        content: Form(
          key: _formKeyDeckName,
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  initialValue: nom,
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
                    if (_formKeyDeckName.currentState!.validate()) {
                      editDeckName(idDeck);
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: recupDecks(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              Row(
                children: <Widget>[
                  const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  buildDecks(),
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
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Card(
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, "/routeFormDeck"),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        height: MediaQuery.of(context).size.width * 0.12,
                        child: const Center(
                          child: Text('Create a new Deck'),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: children),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
