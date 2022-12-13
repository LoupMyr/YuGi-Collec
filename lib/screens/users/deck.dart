import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:yugioh_api/class/api_account.dart';
import 'package:yugioh_api/class/api_yugioh.dart';

class DeckPage extends StatefulWidget {
  DeckPage({super.key, required this.title});

  final String title;
  @override
  State<DeckPage> createState() => DeckPageState();
}

class DeckPageState extends State<DeckPage> {
  ApiAccount _apiAcc = ApiAccount();
  ApiYGO _apiYgo = ApiYGO();
  List<dynamic> _cards = [];
  bool recupDataBool = false;

  void recupData(int id) async {
    var deck = await _apiAcc.getDeckById(id);
    _cards = deck['cartes'];
    setState(() {
      recupDataBool = true;
    });
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
      onPressed: () => null,
      onLongPress: () => null,
      style:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
      child: Image(
        image: NetworkImage(_tabUrl[id]),
        height: MediaQuery.of(context).size.height * 0.28,
        width: MediaQuery.of(context).size.width * 0.28,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var id = ModalRoute.of(context)?.settings.arguments as int;
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
      recupData(id);
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
