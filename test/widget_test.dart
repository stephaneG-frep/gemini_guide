import 'package:flutter_test/flutter_test.dart';
import 'package:gemini_guide/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const GeminiGuideApp());
    expect(find.text('Accueil'), findsOneWidget);
  });
}
