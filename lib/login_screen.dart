import 'package:flutter/material.dart';
import 'package:personnummer/personnummer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skolplattformen/child_details_screen.dart';

import 'api_model.dart';
import 'children_screen.dart';

const SSN_REGEXP = r'^\d{12}$';
const SSN_KEY = 'user.ssn';

class LoginScreen extends StatefulWidget {
  final ApiModel apiModel;

  LoginScreen(this.apiModel);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _ssnController;
  var _ssnOk = false;

  final RegExp regExp = RegExp(SSN_REGEXP);

  @override
  void initState() {
    super.initState();
    _ssnController = TextEditingController();
    _ssnController.addListener(() {
      final text = _ssnController.text;
      setState(() {
        _ssnOk = regExp.hasMatch(text) && Personnummer.valid(text.substring(2));
        print('SSN changed: $text - $_ssnOk');
      });
    });
    _loadStoredSsn();
  }

  Future<void> _loadStoredSsn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedSsn = prefs.getString(SSN_KEY);
    if (storedSsn.isNotEmpty &&
        regExp.hasMatch(storedSsn) &&
        Personnummer.valid(storedSsn.substring(2))) {
      _ssnController.text = storedSsn;
    }
  }

  @override
  void dispose() {
    _ssnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var loginAction = () async {
      final loginFuture = widget.apiModel.login(_ssnController.text);

      if (await loginFuture) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(SSN_KEY, _ssnController.text);
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return ChildrenScreen(apiModel: widget.apiModel);
          },
        ));
      }
    };

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
                  child: Text('Påbörja inloggning!'),
                  onPressed: _ssnOk ? loginAction : null)
            ],
          ),
        ),
      ),
    );
  }
}
