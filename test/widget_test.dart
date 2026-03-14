import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:my_app/main.dart';

void main() {
  testWidgets('CareBridge app loads', (WidgetTester tester) async {

    // Build the CareBridge app
    await tester.pumpWidget(const CareBridgeApp());

    // Verify MaterialApp loads
    expect(find.byType(MaterialApp), findsOneWidget);

    // Verify Login page appears first
    expect(find.textContaining("Login"), findsWidgets);
  });
}