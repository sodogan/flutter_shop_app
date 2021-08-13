// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shop_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    //Set up
    const mockData1 = {
      'id': '1',
      'title': 'Tshirt',
      'description': 'New wave',
      'imageUrl': 'google.com',
      'price': 12.34,
      "isFavourite": true,
    };

    const mockData2 = {
      'id': '1',
      'title': 'Tshirt',
      'description': 'New wave',
      'imageUrl': 'google.com',
      'price': 5,
    };

    const mockData3 = {
      'id': '1',
      'title': 'Tshirt',
      'description': 'New wave',
      'imageUrl': 'google.com',
      'price': 9,
    };

    const mockDataList = [
      mockData1,
      mockData2,
      mockData3,
    ];
  });
}
