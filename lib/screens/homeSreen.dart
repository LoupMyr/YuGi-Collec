import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  int _value = -1;
  var _card;
  Widget _widgetCard = Container();

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/routeId'),
                child: SizedBox(
                  height: 50,
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Card By Id', textAlign: TextAlign.center),
                    ],
                  ),
                )),
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/routeType'),
              child: SizedBox(
                height: 50,
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Card By Type', textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/routeLevel'),
              child: SizedBox(
                height: 50,
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Card By Level', textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/routeCollection'),
              child: SizedBox(
                height: 50,
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('My collection', textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/routeDecks'),
              child: SizedBox(
                height: 50,
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('My decks', textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
