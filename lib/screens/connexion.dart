import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yugioh_api/class/api_account.dart';
import 'package:yugioh_api/class/local.dart';
import 'dart:convert' as convert;

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
  ApiAccount _apiAcc = ApiAccount();

  void connect() async {
    var response = await _apiAcc.getToken(_login, _mdp);
    if (response.statusCode == 200) {
      localLogin = _login;
      localPassword = _mdp;
      var token = convert.jsonDecode(response.body);
      localToken = token['token'].toString();
      print(localLogin);
      print(localPassword);
      print(localToken);
      Navigator.pushReplacementNamed(context, '/routeHome');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Welcome back $_login !'),
      ));
    } else if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Invalid credentials'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Internal server error'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
                  obscureText: true,
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
