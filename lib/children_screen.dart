import 'package:flutter/material.dart';
import 'api_model.dart';

import 'api.dart';
import 'child_details_screen.dart';

class ChildrenScreen extends StatelessWidget {
  final ApiModel apiModel;

  const ChildrenScreen({Key key, this.apiModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dina barn'),
      ),
      body: FutureBuilder(
        future: apiModel.children(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Child> children = snapshot.data ?? [];
            print('Hittade ${children.length} barn');
            return ListView.builder(
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChildDetailsScreen(children[index], apiModel),)),
                  child: ChildItem(children[index])),
              itemCount: children.length,
            );
          } else {
            print('Laddar in barn...');
            return Center(child: Text('Läser in dina barn...'));
          }
        },
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
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(child.name),
    );
  }
}
