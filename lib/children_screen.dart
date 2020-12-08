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
          IconButton(icon: Icon(Icons.logout), onPressed: () async {
            apiModel.logout();
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => LoginScreen(apiModel),
            ));
          })
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChildDetailsScreen(children[index], apiModel),
                  )),
              child: ChildItem(children[index]));
        },
        itemCount: children.length,
      ),
    );
  }
}

class ChildItem extends StatelessWidget {
  final Child child;

  ChildItem(this.child);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.0,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${child.name} (${child.status})', style: Theme.of(context).textTheme.headline6,),
          Text('Skola: ${child.schoolId}', style: Theme.of(context).textTheme.subtitle1,),
        ],
      ),
    );
  }
}
