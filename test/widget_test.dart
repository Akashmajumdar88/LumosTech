// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_hr_assignment/main.dart';
import 'package:flutter_hr_assignment/data/services/api_service.dart';
import 'package:flutter_hr_assignment/data/services/cache_service.dart';
import 'package:flutter_hr_assignment/data/repositories/product_repository_impl.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Initialize test dependencies
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    
    final apiService = ApiService();
    final cacheService = CacheService(prefs);
    final productRepository = ProductRepositoryImpl(
      apiService: apiService,
      cacheService: cacheService,
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(productRepository: productRepository));

    // Verify that the app loads
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
