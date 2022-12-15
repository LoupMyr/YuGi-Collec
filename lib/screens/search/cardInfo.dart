import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:yugioh_api/class/api_account.dart';
import 'package:yugioh_api/class/api_yugioh.dart';
import 'package:http/http.dart' as http;
import 'package:yugioh_api/screens/search/searchLevel.dart';
import 'dart:convert' as convert;
import 'package:yugioh_api/screens/search/searchType.dart';

class cardInfoPage extends StatefulWidget {
  const cardInfoPage({super.key, required this.title});

  final String title;

  @override
  cardInfoPageState createState() => cardInfoPageState();
}

class cardInfoPageState extends State<cardInfoPage> {
  final ApiYGO _apiYGO = ApiYGO();
  final ApiAccount _apiAcc = ApiAccount();
  var _card;
  Widget _widgetCard = Container();
  String _numCard = '';
  bool recupDataBool = false;

  void recupCard() async {
    var response = await _apiYGO.getCardById(_numCard);
    if (response.statusCode == 200) {
      recupDataBool = true;
      _card = convert.jsonDecode(response.body);
      _numCard = _card['data'][0]['id'].toString();
      buildCard();
    }
  }

  void buildCard() {
    setState(() {
      _widgetCard = Column(
        children: [
          ElevatedButton(
            onPressed: null,
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

  @override
  Widget build(BuildContext context) {
    _numCard = ModalRoute.of(context)?.settings.arguments as String;
    if (recupDataBool) {
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
              ],
            ),
          ),
        ),
      );
    } else {
      recupCard();
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
          ],
        ),
      );
    }
  }
}
