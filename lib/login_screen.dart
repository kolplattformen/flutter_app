import 'package:flutter/material.dart';

import 'api_model.dart';
import 'children_screen.dart';

class LoginScreen extends StatelessWidget {
  final _ssnController = TextEditingController();
  final ApiModel apiModel;

  LoginScreen(this.apiModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inloggning'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _ssnController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Personnummer (12 siffror)'),
              ),
              OutlineButton(
                  child: Text('Starta BankID'),
                  onPressed: () async {
                    final result = await apiModel.login(_ssnController.text);
                    if (result) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChildrenScreen(apiModel: apiModel),
                          ));
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
