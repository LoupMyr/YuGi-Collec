import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeckPage extends StatefulWidget {
  const DeckPage({super.key, required this.title});

  final String title;

  @override
  DeckPageState createState() => DeckPageState();
}

class DeckPageState extends State<DeckPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text('Decks')],
        ),
      ),
    );
  }
}
