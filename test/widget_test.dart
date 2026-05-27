import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pit_stop/main.dart';

void main() {
  testWidgets('shows the workshop overview screen', (tester) async {
    await tester.pumpWidget(const PitStopApp());

    expect(find.text('pit-stop'), findsOneWidget);
    expect(find.text('부산 사상구 정비소'), findsOneWidget);
    expect(find.text('일일 요약'), findsOneWidget);
    expect(find.text('손님 큐'), findsOneWidget);
    expect(find.text('작업대 상태'), findsOneWidget);

    await tester.drag(find.byType(Scrollable), const Offset(0, -500));
    await tester.pump();

    expect(find.byKey(const Key('start-intake-button')), findsOneWidget);
  });
}
