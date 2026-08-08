import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/main.dart';

void main() {
  testWidgets('creates, reloads, edits fields and generates a template QR', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('カスタムテンプレート'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('新規作成'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('template_name')), '製番テスト');
    await tester.enterText(
      find.byKey(const Key('template_source')),
      '製番 M6123456789012AAAAAAAABBBBBBB511111111',
    );

    await tester.tap(find.byKey(const Key('add_template_field')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('field_name')), '工程A');
    await tester.enterText(
      find.byKey(const Key('field_placeholder')),
      'AAAAAAAA',
    );
    await tester.enterText(find.byKey(const Key('field_default')), 'A0000001');
    await tester.tap(find.text('追加'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('add_template_field')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('field_name')), '工程B');
    await tester.enterText(
      find.byKey(const Key('field_placeholder')),
      'BBBBBBB',
    );
    await tester.enterText(find.byKey(const Key('field_default')), 'B000001');
    await tester.tap(find.text('追加'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('save_template_top')));
    await tester.pumpAndSettle();
    expect(find.text('製番テスト'), findsOneWidget);

    final fields = find.byType(TextField);
    expect(fields, findsNWidgets(2));
    await tester.enterText(fields.first, 'A1234567');
    await tester.enterText(fields.last, 'B765432');
    await tester.pump();
    expect(
      find.text('製番 M6123456789012A1234567B765432511111111'),
      findsOneWidget,
    );
    await tester.ensureVisible(find.byKey(const Key('generate_template_qr')));
    await tester.drag(find.byType(ListView), const Offset(0, -120));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('generate_template_qr')));
    await tester.pumpAndSettle();
    expect(find.text('完成データをコピー'), findsOneWidget);

    // Recreate the app to verify that the store reloads the saved template.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('カスタムテンプレート'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('template_selector')), findsOneWidget);
    expect(find.text('製番テスト'), findsOneWidget);
  });
}
