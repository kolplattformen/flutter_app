import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'api_model.dart';
import 'home_page.dart';

const title = '\$kolplattformen';

void main() {
  runApp(SkolplattformenApp());
}

class SkolplattformenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => ApiModel())],
      child: MaterialApp(
        title: title,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomePage(title: title),
      ),
    );
  }
}
