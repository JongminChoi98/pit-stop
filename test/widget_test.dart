import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pit_stop/main.dart';

void main() {
  testWidgets('shows the workshop overview screen', (tester) async {
    await tester.pumpWidget(const PitStopApp());

    expect(find.text('pit-stop'), findsOneWidget);
    expect(find.text('부산 사상구 정비소'), findsOneWidget);
    expect(find.text('블록 정비소 월드'), findsOneWidget);
    expect(find.byKey(const Key('workshop-world-panel')), findsOneWidget);
    expect(find.text('첫 손님 선택됨'), findsOneWidget);
    expect(find.text('예산을 신경 쓰며 접수 순서를 기다림'), findsOneWidget);

    await tester.tap(find.byKey(const Key('world-hotspot-lift')));
    await tester.pumpAndSettle();

    expect(find.text('1번 리프트 선택됨'), findsOneWidget);
    expect(find.text('비어 있음, 진단 차량을 올릴 준비 완료'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('일일 요약'), 300);

    expect(find.text('일일 요약'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('손님 큐'), 300);

    expect(find.text('손님 큐'), findsOneWidget);
    expect(
      find.byKey(const Key('customer-avatar-placeholder')),
      findsOneWidget,
    );
    expect(find.text('예산 민감'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('작업대 상태'), 300);

    expect(find.text('작업대 상태'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const Key('start-intake-button')),
      300,
    );
    expect(find.byKey(const Key('start-intake-button')), findsOneWidget);
  });
}
