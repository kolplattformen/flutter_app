import 'dart:convert';

import 'package:http/http.dart' as http;

const MOCK_CHILDREN =
    r'[{"id": 0,"name": "Kalle Svensson (elev)","status": "F;GR","schoolId": "133372F4-AF59-613D-1636-543EC3652111"},{"id": 1,"name": "Jenny Andersson (elev)","status": "F;GR","schoolId": "133372F4-AF59-613D-1636-543EC3652111"}, {"id": 3,"name": "Lina Nilssom (elev)","status": "F;GR","schoolId": "133372F4-AF59-613D-1636-543EC3652111"}]';
const MOCK_NEWS =
    r'[{"id": 0,"header": "Nya direktiv från folkhälsomyndigheten","intro": "Nedan följer viktig information till dig som förälder med barn","body": "Hej\n\nNedan följer viktig information t...","imageUrl": "string"}]';
const MOCK_CALENDAR =
    r'[{"id": 0,"title": "Tidig stängning","description": "På torsdag stänger vi 15:45 på grund av Lucia","location": "","startDate": "2020-12-13","endDate": "2020-12-13","allDay": true}]';

abstract class Api {
  Future<bool> login(String ssn);
  Future<List<Child>> children();
  Future<List<CalendarEvent>> calendar(int childId);
  Future<List<News>> news(int childId);
  void clearHeaders();
}

class TestApi extends Api {
  @override
  Future<bool> login(String ssn) async => Future.value(true);

  @override
  Future<List<Child>> children() async {
    Iterable json = jsonDecode(MOCK_CHILDREN);
    print('TestApi children!');
    return json.map((c) => Child.fromJson(c)).toList();
  }

  @override
  Future<List<CalendarEvent>> calendar(int childId) async {
    Iterable json = jsonDecode(MOCK_CALENDAR);
    print('TestApi calendar!');
    return json.map((e) => CalendarEvent.fromJson(e)).toList();
  }

  @override
  Future<List<News>> news(int childId) async {
    Iterable json = jsonDecode(MOCK_NEWS);
    print('TestApi news!');
    return json.map((e) => News.fromJson(e)).toList();
  }

  @override
  void clearHeaders() {}
}

class ReleaseApi extends Api {
  static final String baseUrl = 'https://skolplattformen-api.snowflake.cash';

  Map<String, String> headers = Map();

  Future<bool> login(String ssn) async {
    try {
      final url = '$baseUrl/login?socialSecurityNumber=$ssn';
      final loginResponse = await http.post(url);
      final json = jsonDecode(loginResponse.body);
      final jwtResponse = await http.get('$baseUrl/login/${json['order']}/jwt');
      final jwt = jsonDecode(jwtResponse.body);
      headers['Authorization'] = jwt;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Child>> children() async {
    final url = '$baseUrl/children';
    final response = await http.get(url, headers: headers);
    Iterable json = jsonDecode(response.body);
    return json.map((e) => Child.fromJson(e)).toList();
  }

  Future<List<CalendarEvent>> calendar(int childId) async {
    final url = '$baseUrl/child/$childId/calendar';
    final response = await http.get(url, headers: headers);
    Iterable json = jsonDecode(response.body);
    return json.map((e) => CalendarEvent.fromJson(e)).toList();
  }

  Future<List<News>> news(int childId) async {
    final url = '$baseUrl/child/$childId/news';
    final response = await http.get(url, headers: headers);
    Iterable json = jsonDecode(response.body);
    return json.map((e) => News.fromJson(e)).toList();
  }

  @override
  void clearHeaders() {
    headers.clear();
  }
}

class News {
  final int id;
  final String header;
  final String intro;
  final String body;
  final String imageUrl;

  News(this.id, this.header, this.intro, this.body, this.imageUrl);

  News.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.header = json['header'],
        this.intro = json['intro'],
        this.body = json['body'],
        this.imageUrl = json['imageUrl'];
}

class CalendarEvent {
  final int id;
  final String title;
  final String description;
  final String location;
  final String startDate;
  final String endDate;
  final bool allDay;

  CalendarEvent(this.id, this.title, this.description, this.location,
      this.startDate, this.endDate, this.allDay);

  CalendarEvent.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.title = json['title'],
        this.description = json['description'],
        this.location = json['location'],
        this.startDate = json['startDate'],
        this.endDate = json['endDate'],
        allDay = json['allDay'];
}

class Child {
  final int id;
  final String name;
  final String status;
  final String schoolId;

  Child(this.id, this.name, this.status, this.schoolId);

  Child.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        status = json['status'],
        schoolId = json['schoolId'];
}
