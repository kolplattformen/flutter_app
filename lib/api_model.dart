import 'package:flutter/material.dart';
import 'api.dart';

class ApiModel extends ChangeNotifier {
  final Api api = Api();

  var loggedIn = false;

  Future<bool> login(String ssn) async {
    loggedIn = await api.login(ssn);
    notifyListeners();
    return loggedIn;
  }

  Future<List<Child>> children() async => api.children();

  Future<List<News>> news(int childId) async => api.news(childId);

  Future<List<CalendarEvent>> calendar(int childId) async =>
      api.calendar(childId);
}
