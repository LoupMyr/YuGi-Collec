import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yugioh_api/class/api_calls.dart';
import 'package:yugioh_api/main.dart';
import 'package:http/http.dart' as http;
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
  Api _api = Api();
  var _card;
  Widget _widgetCard = Container();

  void recupCard() async {
    _card = await _api.getCardById(_value);
    buildCard();
  }

  void buildCard() {
    setState(() {
      _widgetCard = Column(
        children: [
          Image(
            image:
                NetworkImage(_card['data'][0]['card_images'][0]['image_url']),
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.6,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                            hintText: 'Id..', labelText: 'Search a card:'),
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
                            builder: (context) =>
                                const TypePage(title: 'Yu-Gi-Oh! - Find By Type'),
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
