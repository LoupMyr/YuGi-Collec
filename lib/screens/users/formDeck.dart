import 'package:flutter/material.dart';
import 'package:yugioh_api/class/api_account.dart';
import 'dart:convert' as convert;

class FormDeckPage extends StatefulWidget {
  FormDeckPage({super.key, required this.title});

  final String title;
  @override
  State<FormDeckPage> createState() => FormDeckPageState();
}

class FormDeckPageState extends State<FormDeckPage> {
  ApiAccount _apiAcc = ApiAccount();
  final _formKeyDeckName = GlobalKey<FormState>();
  String _nomDeck = '';

  void createDeck() async{
    String uriuser = await _apiAcc.getUriUser();
    await _apiAcc.postDeck(_nomDeck, uriuser);
    Navigator.popAndPushNamed(context, '/routeDecksList');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child:
          Form(
            key: _formKeyDeckName,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: "Name"),
                    validator: (valeur) {
                      if (valeur == null || valeur.isEmpty) {
                        return 'Please enter a name';
                      } else {
                        _nomDeck = valeur.toString();
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKeyDeckName.currentState!.validate()) {
                        createDeck();
                      }
                    },
                    child: const Text("Valid"),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}
