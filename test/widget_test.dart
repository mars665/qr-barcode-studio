import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:starter_app/main.dart';

void main() {
  testWidgets('home menu shows create and scan actions', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('コードスタジオ'), findsOneWidget);
    expect(find.text('メニュー'), findsOneWidget);
    expect(find.text('コード作成'), findsOneWidget);
    expect(find.text('読み取り'), findsOneWidget);
  });

  testWidgets('privacy policy is available from the home screen', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('プライバシーポリシー'));
    await tester.pumpAndSettle();

    expect(find.text('1. 取得する情報'), findsOneWidget);
    expect(find.text('2. カメラの利用'), findsOneWidget);
    expect(find.text('shanlw1983@gmail.com'), findsOneWidget);
  });

  testWidgets('batch mode generates an inclusive number range', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('コード作成'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<CodeKind>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Code128').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'FROM'), '001');
    await tester.enterText(find.widgetWithText(TextField, 'TO'), '003');
    await tester.tap(find.text('まとめて作成'));
    await tester.pumpAndSettle();

    expect(find.text('3件のコード'), findsOneWidget);
    expect(find.widgetWithText(SelectableText, '001'), findsOneWidget);
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -1000));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(SelectableText, '003'), findsOneWidget);
  });

  testWidgets('selected type shows its input example', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('コード作成'));
    await tester.pumpAndSettle();

    expect(find.text('入力例: 490123456789'), findsOneWidget);

    await tester.tap(find.byType(DropdownButtonFormField<CodeKind>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('QRコード').last);
    await tester.pumpAndSettle();

    expect(find.text('入力例: https://example.com'), findsOneWidget);

    await tester.tap(find.text('サンプルを入力'));
    await tester.pumpAndSettle();
    expect(find.text('https://example.com'), findsWidgets);
  });

  testWidgets('batch mode validates every generated value', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('コード作成'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'FROM'), '001');
    await tester.enterText(find.widgetWithText(TextField, 'TO'), '003');
    await tester.pumpAndSettle();

    expect(find.text('✕ 無効'), findsOneWidget);
    expect(find.textContaining('「001」が無効です。'), findsOneWidget);
  });
}
