import 'package:flutter/material.dart';
import 'package:yugioh_api/class/api_calls.dart';
import 'package:yugioh_api/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

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
  var _card;
  Widget _widgetCard = Container();

  void recupCard() async {
    _card = await _api.getCard(_value);
    //buildCard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                      onPressed: () =>Navigator.pushNamed(context, '/routeId'),
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
                      onPressed: () => null,
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
