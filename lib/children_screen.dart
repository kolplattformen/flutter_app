import 'package:flutter/material.dart';

import 'api.dart';
import 'api_model.dart';
import 'child_details_screen.dart';
import 'login_screen.dart';

class ChildrenScreen extends StatelessWidget {
  final ApiModel apiModel;

  const ChildrenScreen({Key key, this.apiModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var children = apiModel.children;
    return Scaffold(
      appBar: AppBar(
        title: Text('Dina barn'),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                apiModel.logout();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(apiModel),
                    ));
              })
        ],
      ),
      body: children.isNotEmpty ? ListView.builder(
        itemBuilder: (context, index) => ChildItem(children[index], apiModel),
        itemCount: children.length,
      ) : Center(child: Text('Kunde inte hitta några barn kopplat till dig.'),),
    );
  }
}

class ChildItem extends StatelessWidget {
  final Child child;
  final ApiModel apiModel;

  ChildItem(this.child, this.apiModel);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChildDetailsScreen(child, apiModel),
            )),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${child.name} (${child.status})',
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
