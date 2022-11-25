import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:yugioh_api/class/api_account.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key, required this.title});

  final String title;

  @override
  CollectionPageState createState() => CollectionPageState();
}

class CollectionPageState extends State<CollectionPage> {
  var _cards;
  ApiAccount _apiAcc = ApiAccount();

  Future<String> recupCardsOfCollec() async {
    String uriUser = await _apiAcc.getUriUser();
    int idCollec = await _apiAcc.getCollecIdByUriUser(uriUser);
    _cards = await _apiAcc.getListCardsFromCollec(idCollec);
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
      for (int i = 0; i < _cards.length; i++) {
        tabChildren.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Image(image: NetworkImage(_cards))],
        ));
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
