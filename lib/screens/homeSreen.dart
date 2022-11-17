import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yugioh_api/class/api_calls.dart';
import 'package:yugioh_api/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  int _value = -1;
  Api _api = Api();
  var _card;
  Widget _widgetCard = Container();
  bool sameRoute = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/routeId'),
                child: Text('Card By Id')),
            ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/routeType'),
                child: Text('Card By Type')),
          ],
        ),
      ),
    );
  }
}
