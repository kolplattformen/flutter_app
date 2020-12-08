// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:skolplattformen/api_model.dart';

void main() {
  test('Test json decoding', () async {
    final model = ApiModel();
    final children = model.children;
    children.forEach((child) => print('Child: ${child.name}'));
  });
}
