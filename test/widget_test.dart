// This is a basic Flutter widget test.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kalmfu_panda/app.dart';

void main() {
  testWidgets('App starts with splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const KalmFuPandaApp());

    // Verify that the app builds without errors.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
