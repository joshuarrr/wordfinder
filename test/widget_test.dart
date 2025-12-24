import 'package:flutter_test/flutter_test.dart';
import 'package:wordfinder/app.dart';

void main() {
  testWidgets('App should build', (WidgetTester tester) async {
    await tester.pumpWidget(const WordFinderApp());
    expect(find.text('Word Finder'), findsOneWidget);
  });
}
