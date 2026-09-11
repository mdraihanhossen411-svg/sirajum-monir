import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sirajum_monir_new/app/app.dart';

void main() {
  testWidgets('Sirajum Monir App launches successfully',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const SirajumMonirApp(),
        );

        expect(find.byType(MaterialApp), findsOneWidget);
      });
}