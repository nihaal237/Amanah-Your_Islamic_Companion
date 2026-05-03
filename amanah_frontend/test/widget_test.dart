// test/widget_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:amanah_frontend/main.dart';

void main() {
  testWidgets('Amanah app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AmanahApp());
    // App should launch without throwing
    expect(find.byType(AmanahApp), findsOneWidget);
  });
}