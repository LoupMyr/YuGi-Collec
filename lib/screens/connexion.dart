import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConnexionPage extends StatefulWidget {
  const ConnexionPage({super.key, required this.title});

  final String title;

  @override
  ConnexionPageState createState() => ConnexionPageState();
}

class ConnexionPageState extends State<ConnexionPage> {
  final _formKey = GlobalKey<FormState>();
  String _login = '';
  String _mdp = '';

  void connect() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/routeInscription');
              },
              child: const Icon(
                Icons.account_circle_outlined,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "Login"),
                  validator: (valeur) {
                    if (valeur == null || valeur.isEmpty) {
                      return 'Please enter your login';
                    } else {
                      _login = valeur.toString();
                    }
                  },
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "Password"),
                  validator: (valeur) {
                    if (valeur == null || valeur.isEmpty) {
                      return 'Please enter your password';
                    } else {
                      _mdp = valeur.toString();
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      connect();
                    }
                  },
                  child: const Text("Sign in"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
