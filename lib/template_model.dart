import 'dart:convert';

class TemplateFieldDefinition {
  const TemplateFieldDefinition({
    required this.id,
    required this.name,
    required this.placeholder,
    this.defaultValue = '',
    this.maxLength,
    this.replaceAll = false,
  });

  final String id;
  final String name;
  final String placeholder;
  final String defaultValue;
  final int? maxLength;
  final bool replaceAll;

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'placeholder': placeholder,
    'defaultValue': defaultValue,
    'maxLength': maxLength,
    'replaceAll': replaceAll,
  };

  factory TemplateFieldDefinition.fromJson(Map<String, dynamic> json) {
    final placeholder = (json['placeholder'] ?? json['token'] ?? '').toString();
    return TemplateFieldDefinition(
      id: (json['id'] ?? 'field_${placeholder.hashCode}').toString(),
      name: (json['name'] ?? json['label'] ?? 'フィールド').toString(),
      placeholder: placeholder,
      defaultValue: (json['defaultValue'] ?? json['default'] ?? '').toString(),
      maxLength: _positiveInt(json['maxLength'] ?? json['length']),
      replaceAll: json['replaceAll'] == true,
    );
  }
}

class CustomCodeTemplate {
  const CustomCodeTemplate({
    required this.id,
    required this.name,
    required this.source,
    required this.fields,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String source;
  final List<TemplateFieldDefinition> fields;
  final DateTime updatedAt;

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'source': source,
    'fields': fields.map((field) => field.toJson()).toList(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory CustomCodeTemplate.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'];
    return CustomCodeTemplate(
      id: (json['id'] ?? 'template_${DateTime.now().microsecondsSinceEpoch}')
          .toString(),
      name: (json['name'] ?? json['title'] ?? '名称未設定').toString(),
      source: (json['source'] ?? json['format'] ?? json['template'] ?? '')
          .toString(),
      fields: rawFields is List
          ? rawFields
                .whereType<Map>()
                .map(
                  (field) => TemplateFieldDefinition.fromJson(
                    Map<String, dynamic>.from(field),
                  ),
                )
                .toList()
          : const [],
      updatedAt:
          DateTime.tryParse((json['updatedAt'] ?? '').toString()) ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}

class TemplateBuildResult {
  const TemplateBuildResult.valid(this.value) : error = null;
  const TemplateBuildResult.invalid(this.error) : value = null;

  final String? value;
  final String? error;
  bool get isValid => value != null;
}

TemplateBuildResult buildTemplateValue(
  CustomCodeTemplate template,
  Map<String, String> values,
) {
  if (template.name.trim().isEmpty) {
    return const TemplateBuildResult.invalid('テンプレート名を入力してください。');
  }
  if (template.source.isEmpty) {
    return const TemplateBuildResult.invalid('原始形式を入力してください。');
  }

  var result = template.source;
  for (final field in template.fields) {
    if (field.name.trim().isEmpty || field.placeholder.isEmpty) {
      return const TemplateBuildResult.invalid('フィールド名と対象文字を入力してください。');
    }
    final value = (values[field.id] ?? field.defaultValue).trim();
    if (value.isEmpty) {
      return TemplateBuildResult.invalid('${field.name}を入力してください。');
    }
    if (field.maxLength != null && value.length > field.maxLength!) {
      return TemplateBuildResult.invalid(
        '${field.name}は${field.maxLength}文字以内で入力してください。',
      );
    }
    if (!result.contains(field.placeholder)) {
      return TemplateBuildResult.invalid(
        '「${field.placeholder}」が原始形式に見つかりません。',
      );
    }
    result = field.replaceAll
        ? result.replaceAll(field.placeholder, value)
        : result.replaceFirst(field.placeholder, value);
  }
  return TemplateBuildResult.valid(result);
}

class TemplateDecodeResult {
  const TemplateDecodeResult(this.templates, {this.warning});

  final List<CustomCodeTemplate> templates;
  final String? warning;
}

TemplateDecodeResult decodeTemplates(String? raw) {
  if (raw == null || raw.trim().isEmpty) {
    return const TemplateDecodeResult([]);
  }
  try {
    final decoded = jsonDecode(raw);
    final list = decoded is List
        ? decoded
        : decoded is Map && decoded['templates'] is List
        ? decoded['templates'] as List
        : const [];
    final templates = <CustomCodeTemplate>[];
    for (final item in list) {
      if (item is! Map) continue;
      final template = CustomCodeTemplate.fromJson(
        Map<String, dynamic>.from(item),
      );
      if (template.source.isNotEmpty) templates.add(template);
    }
    return TemplateDecodeResult(templates);
  } catch (_) {
    return const TemplateDecodeResult(
      [],
      warning: '保存データを読み込めませんでした。新しい一覧として開始します。',
    );
  }
}

String encodeTemplates(List<CustomCodeTemplate> templates) => jsonEncode({
  'version': 2,
  'templates': templates.map((template) => template.toJson()).toList(),
});

int? _positiveInt(Object? value) {
  final parsed = value is int ? value : int.tryParse(value?.toString() ?? '');
  return parsed != null && parsed > 0 ? parsed : null;
}
