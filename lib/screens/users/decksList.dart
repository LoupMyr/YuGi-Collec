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
  final List<dynamic> _listDecks = [];

  Future<String> recupDecks() async {
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
          child: Text('You have no deck yet, let\s create some !'),
        ),
      );
    }
    for (int i = 0; i < _listDecks.length; i++) {
      tabChildren.add(Row(
        children: [
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "/routeDeck",
                  arguments: _listDecks[i]['id']),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.87,
                height: MediaQuery.of(context).size.width * 0.18,
                child: Center(
                  child: Text(_listDecks[i]['nom']),
                ),
              ),
            ),
          ),
        ],
      ));
    }
    return Column(
      children: tabChildren,
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
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Row(
                children: <Widget>[
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
            body: Center(
              child: SingleChildScrollView(
                child: Column(children: children),
              ),
            ),
          );
        });
  }
}
