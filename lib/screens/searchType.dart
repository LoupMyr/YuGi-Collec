import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yugioh_api/class/api_calls.dart';
import 'package:yugioh_api/main.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:yugioh_api/screens/searchId.dart';

class TypePage extends StatefulWidget {
  const TypePage({super.key, required this.title});

  final String title;

  @override
  TypePageState createState() => TypePageState();
}

class TypePageState extends State<TypePage> {
  final _formKey = GlobalKey<FormState>();
  String _value = '';
  Api _api = Api();
  var _cards;
  List<Widget> _tabChildren = [];
  double _height = 0;

  void recupCards() async {
    _cards = await _api.getCardsByType(_value);
    buildCard();
  }

  void buildCard() {
    for (int i = 0; i < _cards['data'].length; i++) {
      _tabChildren.add(Container(
        child: Column(
          children: <Widget>[
            Image(
              image: NetworkImage(
                  _cards['data'][i]['card_images'][0]['image_url']),
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.6,
            ),
            Text(
              'Name: ' + _cards['data'][i]['name'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold, /*overflow: TextOverflow.ellipsis*/
              ),
            ),
            Text(
              'Type: ' + _cards['data'][i]['type'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Level: ' + _cards['data'][i]['level'].toString(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CarouselSlider(
                items: _tabChildren,
                options: CarouselOptions(
                  enlargeCenterPage: false,
                  height: _height,
                  autoPlay: true,
                  autoPlayCurve: Curves.easeInOutCirc,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(seconds: 5),
                  viewportFraction: 0.8,
                ),
              ),
              Container(
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
                            hintText: 'Type', labelText: 'Search cards:'),
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
                      onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const IdPage(title: 'Yu-Gi-Oh! - Find By Id'),)),
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
