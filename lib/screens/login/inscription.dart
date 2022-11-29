import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yugioh_api/class/api_account.dart';

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({super.key, required this.title});

  final String title;

  @override
  InscriptionPageState createState() => InscriptionPageState();
}

class InscriptionPageState extends State<InscriptionPage> {
  final _formKey = GlobalKey<FormState>();
  String _login = '';
  String _mdp1 = '';
  String _mdp2 = '';
  ApiAccount _apiAcc = ApiAccount();

  void checkAccount() async {
    var response = await _apiAcc.createAccount(_login, _mdp1);
    log(response.statusCode.toString());
    if (response.statusCode == 201) {
      Navigator.pushReplacementNamed(context, '/routeConnexion');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Account create'),
      ));
    } else if (response.statusCode == 422) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Login already in used'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Server error'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        leading: Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/routeConnexion');
              },
              child: Icon(
                Icons.arrow_back,
                size: 26.0,
              ),
            )),
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
                      _mdp1 = valeur.toString();
                    }
                  },
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: "Verify password"),
                  validator: (valeur) {
                    if (valeur == null || valeur.isEmpty) {
                      return 'Please enter your password';
                    } else if (valeur != _mdp1) {
                      return 'Your passwords are different';
                    } else {
                      _mdp2 = valeur.toString();
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      checkAccount();
                    }
                  },
                  child: const Text("Sign up"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
