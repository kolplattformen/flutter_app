import 'package:flutter/material.dart';

import 'api.dart';

const REVIEW_USER = '121212121212';

class ApiModel extends ChangeNotifier {
  final Api testApi = TestApi();
  final Api releaseApi = ReleaseApi();

  Api api;

  var ssn = '';
  var children = List<Child>.empty();
  var loggedIn = false;
  var childNews = Map<int, List<News>>();
  var childCalendar = Map<int, List<CalendarEvent>>();

  Future<bool> login(String ssn) async {
    this.ssn = ssn;
    if (ssn == REVIEW_USER) {
      print('Switch to test API');
      api = testApi;
    } else {
      print('Switch to release API');
      api = releaseApi;
    }
    loggedIn = await api.login(ssn);
    if (loggedIn) {
      await _loadChildren();
    }
    notifyListeners();
    return loggedIn;
  }

  Future _loadChildren() async {
    children = await api.children();
    children.forEach((child) async {
      final news = await api.news(child.id);
      childNews[child.id] = news;
      final calendar = await api.calendar(child.id);
      childCalendar[child.id] = calendar;
    });
  }

  Future<void> reload() async {
    if (loggedIn) {
      _loadChildren();
      notifyListeners();
    }
  }

  Future<void> logout() async {
    loggedIn = false;
    api.clearHeaders();
    notifyListeners();
  }
}
