import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../lib/features/tasbih/pages/tasbih_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('দৈনিক ইতিহাস tap করলে history sheet খোলে', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      const MaterialApp(
        home: TasbihPage(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    final historyFinder = find.text('দৈনিক ইতিহাস');

    expect(
      historyFinder,
      findsOneWidget,
      reason: 'TasbihPage load হওয়ার পর দৈনিক ইতিহাস পাওয়া যায়নি',
    );

    // দৈনিক ইতিহাস card-টি viewport-এর নিচে থাকলে আগে scroll করে দৃশ্যমান করি।
    await tester.ensureVisible(historyFinder);
    await tester.pump();

    // এখন tap করার মতো অবস্থায় আছে।
    await tester.tap(historyFinder);
    await tester.pump(const Duration(milliseconds: 500));

    expect(
      find.byType(BottomSheet),
      findsOneWidget,
    );

  });
}
