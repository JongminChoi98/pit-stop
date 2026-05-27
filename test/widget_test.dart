import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pit_stop/main.dart';

void main() {
  testWidgets('shows the workshop status screen', (tester) async {
    await tester.pumpWidget(const PitStopApp());

    expect(find.text('pit-stop'), findsOneWidget);
    expect(find.text('부산 사상구 정비소'), findsOneWidget);
    expect(find.text('첫 손님을 받을 준비 중입니다.'), findsOneWidget);
    expect(find.byKey(const Key('start-intake-button')), findsOneWidget);
  });
}
