// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:skolplattformen/api.dart';

void main() {
  test('Test json decoding', () {
    final result = jsonDecode(MOCK_CHILDREN, reviver: (key, value) {
      print('$key = $value');
      return value;
    });
    // List<Child> children = jsonDecode(MOCK_CHILDREN, reviver: (key, value) => Child.fromJson(value));
    // print('Got ${children.length}');
    // print('Child: ${children[0].name}');
  });
}
