import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/template_model.dart';

void main() {
  CustomCodeTemplate sample({bool replaceAll = false}) => CustomCodeTemplate(
    id: 'manufacturing',
    name: '製番',
    source: '製番 M6123456789012AAAAAAAABBBBBBB511111111',
    fields: [
      const TemplateFieldDefinition(
        id: 'a',
        name: '工程A',
        placeholder: 'AAAAAAAA',
        defaultValue: 'A0000001',
        maxLength: 8,
      ),
      TemplateFieldDefinition(
        id: 'b',
        name: '工程B',
        placeholder: 'BBBBBBB',
        defaultValue: 'B000001',
        maxLength: 7,
        replaceAll: replaceAll,
      ),
    ],
    updatedAt: DateTime.utc(2026, 8, 8),
  );

  test('builds complete QR content from variable fields', () {
    final result = buildTemplateValue(sample(), {
      'a': 'A1234567',
      'b': 'B765432',
    });

    expect(result.isValid, isTrue);
    expect(result.value, '製番 M6123456789012A1234567B765432511111111');
  });

  test('supports changed field lengths and enforces maximum length', () {
    expect(
      buildTemplateValue(sample(), {'a': '短い', 'b': 'B1'}).value,
      '製番 M6123456789012短いB1511111111',
    );
    final invalid = buildTemplateValue(sample(), {'a': '123456789', 'b': 'B1'});
    expect(invalid.isValid, isFalse);
    expect(invalid.error, contains('8文字以内'));
  });

  test(
    'repeated placeholder can replace one occurrence or every occurrence',
    () {
      final one = CustomCodeTemplate(
        id: 'one',
        name: 'one',
        source: 'XX-XX',
        fields: const [
          TemplateFieldDefinition(
            id: 'x',
            name: '番号',
            placeholder: 'XX',
            defaultValue: '01',
          ),
        ],
        updatedAt: DateTime.utc(2026),
      );
      final all = CustomCodeTemplate(
        id: 'all',
        name: 'all',
        source: 'XX-XX',
        fields: const [
          TemplateFieldDefinition(
            id: 'x',
            name: '番号',
            placeholder: 'XX',
            defaultValue: '01',
            replaceAll: true,
          ),
        ],
        updatedAt: DateTime.utc(2026),
      );

      expect(buildTemplateValue(one, {'x': '99'}).value, '99-XX');
      expect(buildTemplateValue(all, {'x': '99'}).value, '99-99');
    },
  );

  test('rejects empty values and missing placeholders', () {
    expect(
      buildTemplateValue(sample(), {'a': '', 'b': 'B1'}).error,
      contains('工程A'),
    );
    final missing = CustomCodeTemplate(
      id: 'missing',
      name: 'missing',
      source: 'fixed',
      fields: const [
        TemplateFieldDefinition(
          id: 'x',
          name: '番号',
          placeholder: 'XX',
          defaultValue: '01',
        ),
      ],
      updatedAt: DateTime.utc(2026),
    );
    expect(buildTemplateValue(missing, const {}).error, contains('見つかりません'));
  });

  test('persistence round trip and legacy keys remain compatible', () {
    final encoded = encodeTemplates([sample()]);
    final decoded = decodeTemplates(encoded);
    expect(decoded.warning, isNull);
    expect(decoded.templates.single.name, '製番');
    expect(decoded.templates.single.fields.length, 2);

    final legacy = decodeTemplates(
      '[{"title":"旧形式","format":"AA-999","fields":'
      '[{"label":"番号","token":"AA","default":"01","length":2}]}]',
    );
    expect(legacy.templates.single.name, '旧形式');
    expect(legacy.templates.single.fields.single.maxLength, 2);
  });

  test('invalid local storage data returns a recoverable warning', () {
    final decoded = decodeTemplates('{broken json');
    expect(decoded.templates, isEmpty);
    expect(decoded.warning, isNotNull);
  });
}
