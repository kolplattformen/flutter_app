import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'api_model.dart';
import 'children_screen.dart';
import 'login_screen.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Consumer<ApiModel>(
      builder: (context, apiModel, child) {
        if (apiModel.loggedIn) {
          return ChildrenScreen(apiModel: apiModel);
        } else {
          return LoginScreen(apiModel);
        }
      },
    );
  }
}
