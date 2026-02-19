import 'package:flutter_test/flutter_test.dart';
import 'package:lotto_app/main.dart';

void main() {
  testWidgets('LottoApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const LottoApp());
    expect(find.text('번호 생성기'), findsOneWidget);
    expect(find.text('번호 생성하기'), findsOneWidget);
  });
}
