import 'package:flutter/material.dart';
import 'package:yugioh_api/screens/collection.dart';
import 'package:yugioh_api/screens/connexion.dart';
import 'package:yugioh_api/screens/decks.dart';
import 'package:yugioh_api/screens/homeScreen.dart';
import 'package:yugioh_api/screens/inscription.dart';
import 'package:yugioh_api/screens/searchId.dart';
import 'package:yugioh_api/screens/searchLevel.dart';
import 'package:yugioh_api/screens/searchType.dart';
import 'package:yugioh_api/screens/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: const MyHomePage(title: 'Yu-Gi-Oh!'),
        routes: <String, WidgetBuilder>{
          '/routeHome': (BuildContext context) =>
              const HomeScreen(title: "Yu-Gi-Oh! - Welcome"),
          '/routeType': (BuildContext context) =>
              const TypePage(title: "Yu-Gi-Oh! - Find By Type"),
          '/routeId': (BuildContext context) =>
              const IdPage(title: "Yu-Gi-Oh! - Find By Id"),
          '/routeLevel': (BuildContext context) =>
              const LevelPage(title: "Yu-Gi-Oh! - Find By Level"),
          '/routeConnexion': (BuildContext context) =>
              const ConnexionPage(title: "Yu-Gi-Oh! - Connect"),
          '/routeInscription': (BuildContext context) =>
              const InscriptionPage(title: "Yu-Gi-Oh! - Sign up"),
          '/routeCollection': (BuildContext context) =>
              const CollectionPage(title: "Yu-Gi-Oh! - My Collection"),
          '/routeDecks': (BuildContext context) =>
              const DeckPage(title: "Yu-Gi-Oh! - My Decks"),
        });
  }
}
