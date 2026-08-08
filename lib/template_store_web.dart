// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

class BrowserTemplateStore {
  static const _key = 'qr_barcode_studio.custom_templates.v2';
  static const _legacyKeys = [
    'qr_barcode_studio.custom_templates',
    'customTemplates',
  ];

  Future<String?> read() async {
    final current = html.window.localStorage[_key];
    if (current != null) return current;
    for (final legacyKey in _legacyKeys) {
      final legacy = html.window.localStorage[legacyKey];
      if (legacy != null) return legacy;
    }
    return null;
  }

  Future<void> write(String value) async {
    html.window.localStorage[_key] = value;
  }
}
