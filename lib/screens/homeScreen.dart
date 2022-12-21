import 'package:flutter/material.dart';
import 'package:yugioh_api/class/local.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  void logout(){
    localLogin = '';
    localPassword = '';
    localToken = '';
    Navigator.pushReplacementNamed(context, '/routeConnexion');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: logout,
              child: const Icon(
                Icons.logout_outlined,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
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
                    children: const <Widget>[
                      Text('Card By Id', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
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
                    children: const <Widget>[
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
                    children: const <Widget>[
                      Text('Card By Level', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
              ),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/routeCollection'),
                child: SizedBox(
                  height: 50,
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text('My collection', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
              ),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/routeDecksList'),
                child: SizedBox(
                  height: 50,
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text('My decks', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
