import 'package:flutter/material.dart';

import 'api.dart';
import 'api_model.dart';

class ChildDetailsScreen extends StatelessWidget {
  final Child child;
  final ApiModel apiModel;

  ChildDetailsScreen(this.child, this.apiModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(child.name),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: apiModel.news(child.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<News> news = snapshot.data;
              print('Got ${news.length} news');
              return ListView.builder(
                  itemCount: news.length,
                  itemBuilder: (context, index) => NewsItem(news[index]));
            } else {
              return Center(child: Text('Inga nyheter för detta barn!'));
            }
          },
        ),
      ),
    );
  }
}

class NewsItem extends StatelessWidget {
  final News news;

  NewsItem(this.news);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(news.header), Text(news.intro), Text(news.body)],
    );
  }
}
