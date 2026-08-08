import 'package:barcode_widget/barcode_widget.dart' as generator;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as scanner;

import 'custom_templates.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'コードスタジオ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF006C67)),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('コードスタジオ')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    'メニュー',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '使用する機能を選択してください。',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 28),
                  MenuCard(
                    icon: Icons.qr_code_2,
                    title: 'コード作成',
                    description: 'QRコード・バーコードを1件または一括で作成します。',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ToolScreen(initialIndex: 0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  MenuCard(
                    icon: Icons.qr_code_scanner,
                    title: '読み取り',
                    description: 'カメラでコードを読み取り、内容を表示します。',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ToolScreen(initialIndex: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  MenuCard(
                    icon: Icons.dashboard_customize_outlined,
                    title: 'カスタムテンプレート',
                    description: '定型文の変更部分だけを入力してQRコードを作成します。',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const CustomTemplateScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const PrivacyPolicyScreen(),
                      ),
                    ),
                    icon: const Icon(Icons.privacy_tip_outlined),
                    label: const Text('プライバシーポリシー'),
                  ),
                  if (kIsWeb)
                    Text(
                      'カメラ映像と読み取りデータは端末内で処理され、サーバーには送信されません。',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('プライバシーポリシー')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'プライバシーポリシー',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('最終更新日：2026年8月8日'),
                  SizedBox(height: 24),
                  Text(
                    '1. 取得する情報',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '本アプリは、氏名、メールアドレス、位置情報などの個人情報を収集しません。'
                    'アカウント登録も必要ありません。',
                  ),
                  SizedBox(height: 20),
                  Text(
                    '2. カメラの利用',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'カメラはQRコードおよびバーコードを読み取る目的でのみ使用します。'
                    'カメラ映像は端末内で処理され、保存または外部サーバーへ送信されません。',
                  ),
                  SizedBox(height: 20),
                  Text(
                    '3. 入力・読み取りデータ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'コード作成時の入力内容と読み取り結果は端末内で処理されます。'
                    '本アプリはこれらのデータを外部へ送信しません。'
                    '読み取り履歴はアプリ終了後に保持されません。',
                  ),
                  SizedBox(height: 20),
                  Text(
                    '4. カスタムテンプレート',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '作成したカスタムテンプレートはブラウザーのlocalStorageまたは端末内にのみ保存され、'
                    '外部サーバーへ送信されません。ブラウザーのデータを消去すると削除されます。',
                  ),
                  SizedBox(height: 20),
                  Text(
                    '5. 第三者提供・広告',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('個人情報の第三者提供、広告配信、行動分析は行いません。'),
                  SizedBox(height: 20),
                  Text(
                    '6. お問い合わせ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  SelectableText('shanlw1983@gmail.com'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  const MenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Row(
            children: [
              CircleAvatar(radius: 28, child: Icon(icon, size: 30)),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 6),
                    Text(description),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class ToolScreen extends StatelessWidget {
  const ToolScreen({super.key, required this.initialIndex});

  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(initialIndex == 0 ? 'コード作成' : '読み取り')),
      body: initialIndex == 0 ? const GenerateScreen() : const ScanScreen(),
    );
  }
}

enum CodeKind {
  ean13('JAN（EAN-13）', '490123456789'),
  ean8('JAN（EAN-8）', '4901234'),
  code128('Code128', 'SHIP-2026-001'),
  code39('Code39', 'ASSET-0098'),
  itf('ITF', '12345678'),
  isbn('ISBN', '978-4-0000-0000-0'),
  qr('QRコード', 'https://example.com');

  const CodeKind(this.label, this.sample);
  final String label;
  final String sample;

  String get batchSample => switch (this) {
    CodeKind.ean13 => 'FROM 490123456780 / TO 490123456782',
    CodeKind.ean8 => 'FROM 4901230 / TO 4901232',
    CodeKind.itf => 'FROM 00000001 / TO 00000003',
    _ => 'FROM 001 / TO 003',
  };

  generator.Barcode createBarcode() {
    return switch (this) {
      CodeKind.ean13 => generator.Barcode.ean13(),
      CodeKind.ean8 => generator.Barcode.ean8(),
      CodeKind.code128 => generator.Barcode.code128(),
      CodeKind.code39 => generator.Barcode.code39(),
      CodeKind.itf => generator.Barcode.itf(),
      CodeKind.isbn => generator.Barcode.isbn(),
      CodeKind.qr => generator.Barcode.qrCode(),
    };
  }

  DataValidation validate(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return const DataValidation.invalid('データを入力してください。');
    }

    if (this == CodeKind.ean13 || this == CodeKind.ean8) {
      if (!RegExp(r'^\d+$').hasMatch(trimmed)) {
        return const DataValidation.invalid('数字だけを入力してください。');
      }
      final shortLength = this == CodeKind.ean13 ? 12 : 7;
      final fullLength = shortLength + 1;
      if (trimmed.length == shortLength) {
        final checkDigit = _calculateGtinCheckDigit(trimmed);
        return DataValidation.valid(
          '$trimmed$checkDigit',
          '有効・チェックデジットを自動付与: $checkDigit',
        );
      }
      if (trimmed.length == fullLength) {
        final expected = _calculateGtinCheckDigit(
          trimmed.substring(0, shortLength),
        );
        if (trimmed.endsWith(expected)) {
          return DataValidation.valid(trimmed, '有効・チェックデジット確認済み');
        }
        return DataValidation.invalid('チェックデジットが正しくありません（正しい末尾: $expected）。');
      }
      return DataValidation.invalid(
        this == CodeKind.ean13
            ? 'JAN（EAN-13）は12桁または13桁です。'
            : 'JAN（EAN-8）は7桁または8桁です。',
      );
    }

    final normalized = this == CodeKind.isbn
        ? trimmed.replaceAll(RegExp(r'[-\s]'), '')
        : trimmed;
    try {
      if (!createBarcode().isValid(normalized)) {
        return DataValidation.invalid(_formatErrorMessage);
      }
    } catch (_) {
      return DataValidation.invalid(_formatErrorMessage);
    }
    return DataValidation.valid(normalized, '有効');
  }

  String get _formatErrorMessage => switch (this) {
    CodeKind.code128 => 'Code128で使用できないデータです。',
    CodeKind.code39 => 'Code39は英大文字・数字・一部記号を使用してください。',
    CodeKind.itf => 'ITFは偶数桁の数字を入力してください。',
    CodeKind.isbn => 'ISBN-10またはISBN-13を入力してください。',
    _ => '入力データを確認してください。',
  };

  static String _calculateGtinCheckDigit(String digits) {
    var sum = 0;
    var weight = 3;
    for (var index = digits.length - 1; index >= 0; index--) {
      sum += int.parse(digits[index]) * weight;
      weight = weight == 3 ? 1 : 3;
    }
    return ((10 - (sum % 10)) % 10).toString();
  }
}

class DataValidation {
  const DataValidation.valid(this.normalizedData, this.message)
    : isValid = true;
  const DataValidation.invalid(this.message)
    : isValid = false,
      normalizedData = null;

  final bool isValid;
  final String? normalizedData;
  final String message;
}

class BatchRangeResult {
  const BatchRangeResult.valid(this.values) : error = null;
  const BatchRangeResult.invalid(this.error) : values = null;

  final List<String>? values;
  final String? error;
  bool get isValid => values != null;
}

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({super.key});

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  CodeKind _kind = CodeKind.ean13;
  bool _batchMode = false;
  List<String> _generatedValues = const [];

  @override
  void dispose() {
    _inputController.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _generate() {
    late List<String> values;

    if (_batchMode) {
      final range = _buildBatchRange();
      if (!range.isValid) {
        _showMessage(range.error!);
        return;
      }
      values = range.values!;
    } else {
      values = [
        _inputController.text.trim(),
      ].where((value) => value.isNotEmpty).toList();
    }

    if (values.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('コードにするデータを入力してください。')));
      return;
    }

    final normalizedValues = <String>[];
    for (final value in values) {
      final validation = _kind.validate(value);
      if (!validation.isValid) {
        _showMessage('${_kind.label}:「$value」は無効です。${validation.message}');
        return;
      }
      normalizedValues.add(validation.normalizedData!);
    }
    values = normalizedValues;

    setState(() => _generatedValues = values);
    FocusScope.of(context).unfocus();
  }

  BatchRangeResult _buildBatchRange() {
    final fromText = _fromController.text.trim();
    final toText = _toController.text.trim();
    if (fromText.isEmpty || toText.isEmpty) {
      return const BatchRangeResult.invalid('FROMとTOを入力してください。');
    }

    final from = int.tryParse(fromText);
    final to = int.tryParse(toText);
    if (from == null || to == null) {
      return const BatchRangeResult.invalid('FROMとTOには整数を入力してください。');
    }
    if (from < 0 || to < 0) {
      return const BatchRangeResult.invalid('FROMとTOには0以上の整数を入力してください。');
    }
    if (from > to) {
      return const BatchRangeResult.invalid('FROMはTO以下の値にしてください。');
    }
    if (to - from + 1 > 1000) {
      return const BatchRangeResult.invalid('一度に作成できるコードは最大1,000件です。');
    }

    final width = fromText.length > toText.length
        ? fromText.length
        : toText.length;
    return BatchRangeResult.valid([
      for (var number = from; number <= to; number++)
        number.toString().padLeft(width, '0'),
    ]);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildValidationStatus() {
    final input = _inputController.text.trim();
    if (input.isEmpty) return const SizedBox.shrink();

    final validation = _kind.validate(input);
    final color = validation.isValid
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.error;
    final details = validation.message == '有効'
        ? '入力形式に問題ありません'
        : validation.message.replaceFirst('有効・', '');

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: 0.35)),
            ),
            child: Text(
              validation.isValid ? '✓ 有効' : '✕ 無効',
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(details, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }

  Widget _buildBatchValidationStatus() {
    final fromText = _fromController.text.trim();
    final toText = _toController.text.trim();
    if (fromText.isEmpty && toText.isEmpty) return const SizedBox.shrink();

    final range = _buildBatchRange();
    if (!range.isValid) {
      return _buildStatusBadge(isValid: false, details: range.error!);
    }

    final values = range.values!;
    for (final value in values) {
      final validation = _kind.validate(value);
      if (!validation.isValid) {
        return _buildStatusBadge(
          isValid: false,
          details: '「$value」が無効です。${validation.message}',
        );
      }
    }
    return _buildStatusBadge(
      isValid: true,
      details: '${values.length}件すべて有効です。',
    );
  }

  Widget _buildStatusBadge({required bool isValid, required String details}) {
    final color = isValid
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.error;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: 0.35)),
            ),
            child: Text(
              isValid ? '✓ 有効' : '✕ 無効',
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(details, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }

  Widget _buildExample(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline, size: 18),
          const SizedBox(width: 6),
          Expanded(child: Text('入力例: $text')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          sliver: SliverList.list(
            children: [
              Text(
                'QRコード・バーコードを作成',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                '種類を選び、コードに含める文字や番号を入力します。',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<CodeKind>(
                initialValue: _kind,
                decoration: const InputDecoration(
                  labelText: 'コードの種類',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: CodeKind.values
                    .map(
                      (kind) => DropdownMenuItem(
                        value: kind,
                        child: Text(kind.label),
                      ),
                    )
                    .toList(),
                onChanged: (kind) {
                  if (kind != null) {
                    setState(() {
                      _kind = kind;
                      _generatedValues = const [];
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('複数コードを一括作成'),
                subtitle: const Text('FROMからTOまでの連番を作成します'),
                value: _batchMode,
                onChanged: (value) {
                  setState(() {
                    _batchMode = value;
                    _generatedValues = const [];
                  });
                },
              ),
              const SizedBox(height: 8),
              if (_batchMode)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _fromController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              labelText: 'FROM',
                              hintText: '001',
                              helperText: '開始番号',
                            ),
                            onChanged: (_) {
                              setState(() => _generatedValues = const []);
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(12, 18, 12, 0),
                          child: Icon(Icons.arrow_forward),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _toController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              labelText: 'TO',
                              hintText: '010',
                              helperText: '終了番号',
                            ),
                            onChanged: (_) {
                              setState(() => _generatedValues = const []);
                            },
                            onSubmitted: (_) => _generate(),
                          ),
                        ),
                      ],
                    ),
                    _buildExample(_kind.batchSample),
                    _buildBatchValidationStatus(),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _inputController,
                      minLines: 2,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'データ',
                        hintText: _kind.sample,
                        alignLabelWithHint: true,
                      ),
                      onChanged: (_) {
                        setState(() => _generatedValues = const []);
                      },
                      onSubmitted: (_) => _generate(),
                    ),
                    _buildExample(_kind.sample),
                    _buildValidationStatus(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () {
                          _inputController.text = _kind.sample;
                          setState(() => _generatedValues = const []);
                        },
                        icon: const Icon(Icons.science_outlined),
                        label: const Text('サンプルを入力'),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _generate,
                icon: const Icon(Icons.auto_awesome),
                label: Text(_batchMode ? 'まとめて作成' : 'コードを作成'),
              ),
              if (_generatedValues.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  '${_generatedValues.length}件のコード',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          sliver: SliverList.builder(
            itemCount: _generatedValues.length,
            itemBuilder: (context, index) {
              final value = _generatedValues[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GeneratedCodeCard(
                  kind: _kind,
                  value: value,
                  index: index + 1,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class GeneratedCodeCard extends StatelessWidget {
  const GeneratedCodeCard({
    super.key,
    required this.kind,
    required this.value,
    required this.index,
  });

  final CodeKind kind;
  final String value;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isQr = kind == CodeKind.qr;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$index. ${kind.label}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                IconButton(
                  tooltip: 'データをコピー',
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: value));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('データをコピーしました。')),
                      );
                    }
                  },
                  icon: const Icon(Icons.copy_outlined),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(12),
                child: generator.BarcodeWidget(
                  barcode: kind.createBarcode(),
                  data: value,
                  width: isQr ? 210 : 300,
                  height: isQr ? 210 : 110,
                  drawText: !isQr,
                  errorBuilder: (context, error) => SizedBox(
                    height: 100,
                    child: Center(
                      child: Text(
                        'この形式では作成できません。\n入力内容を確認してください。',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SelectableText(value),
          ],
        ),
      ),
    );
  }
}

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final scanner.MobileScannerController _scannerController =
      scanner.MobileScannerController(
        detectionSpeed: scanner.DetectionSpeed.noDuplicates,
        formats: const [
          scanner.BarcodeFormat.qrCode,
          scanner.BarcodeFormat.code128,
          scanner.BarcodeFormat.code39,
          scanner.BarcodeFormat.ean13,
          scanner.BarcodeFormat.ean8,
          scanner.BarcodeFormat.upcA,
          scanner.BarcodeFormat.upcE,
          scanner.BarcodeFormat.dataMatrix,
          scanner.BarcodeFormat.pdf417,
          scanner.BarcodeFormat.aztec,
        ],
      );

  final List<ScannedItem> _results = [];
  String? _lastValue;
  DateTime? _lastDetectedAt;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _handleDetection(scanner.BarcodeCapture capture) {
    final now = DateTime.now();
    for (final code in capture.barcodes) {
      final value = code.rawValue?.trim();
      if (value == null || value.isEmpty) continue;

      final isRapidDuplicate =
          value == _lastValue &&
          _lastDetectedAt != null &&
          now.difference(_lastDetectedAt!) < const Duration(seconds: 3);
      if (isRapidDuplicate) continue;

      setState(() {
        _lastValue = value;
        _lastDetectedAt = now;
        _results.insert(
          0,
          ScannedItem(value: value, format: code.format.name, scannedAt: now),
        );
      });
      HapticFeedback.mediumImpact();
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: Stack(
            fit: StackFit.expand,
            children: [
              scanner.MobileScanner(
                controller: _scannerController,
                onDetect: _handleDetection,
                placeholderBuilder: (context) => const ColoredBox(
                  color: Colors.black,
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorBuilder: (context, error) => _ScannerErrorView(
                  error: error,
                  onRetry: _scannerController.start,
                ),
              ),
              IgnorePointer(
                child: Center(
                  child: Container(
                    width: 250,
                    height: 170,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 3),
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 12,
                bottom: 12,
                child: Row(
                  children: [
                    ValueListenableBuilder<scanner.MobileScannerState>(
                      valueListenable: _scannerController,
                      builder: (context, state, _) {
                        if (state.torchState ==
                            scanner.TorchState.unavailable) {
                          return const SizedBox.shrink();
                        }
                        return IconButton.filledTonal(
                          tooltip: 'ライト',
                          onPressed: _scannerController.toggleTorch,
                          icon: Icon(
                            state.torchState == scanner.TorchState.on
                                ? Icons.flashlight_on
                                : Icons.flashlight_on_outlined,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      tooltip: 'カメラ切替',
                      onPressed: _scannerController.switchCamera,
                      icon: const Icon(Icons.cameraswitch_outlined),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _results.isEmpty
                      ? 'コードを枠内に合わせてください'
                      : '読み取り結果（${_results.length}件）',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (_results.isNotEmpty)
                TextButton.icon(
                  onPressed: () => setState(_results.clear),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('クリア'),
                ),
            ],
          ),
        ),
        Expanded(
          child: _results.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      '読み取ったデータはここに表示されます。',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  itemCount: _results.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return ScanResultCard(item: _results[index]);
                  },
                ),
        ),
      ],
    );
  }
}

class _ScannerErrorView extends StatelessWidget {
  const _ScannerErrorView({required this.error, required this.onRetry});

  final scanner.MobileScannerException error;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final message = switch (error.errorCode) {
      scanner.MobileScannerErrorCode.permissionDenied =>
        'カメラの使用が許可されていません。\nブラウザーまたは端末の設定でカメラを許可してください。',
      scanner.MobileScannerErrorCode.unsupported =>
        'この端末またはブラウザーではカメラ読み取りを利用できません。',
      _ => 'カメラを開始できませんでした。',
    };

    return ColoredBox(
      color: Colors.black87,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.no_photography_outlined,
                color: Colors.white,
                size: 44,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('再試行'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScannedItem {
  const ScannedItem({
    required this.value,
    required this.format,
    required this.scannedAt,
  });

  final String value;
  final String format;
  final DateTime scannedAt;
}

class ScanResultCard extends StatelessWidget {
  const ScanResultCard({super.key, required this.item});

  final ScannedItem item;

  @override
  Widget build(BuildContext context) {
    final time =
        '${item.scannedAt.hour.toString().padLeft(2, '0')}:'
        '${item.scannedAt.minute.toString().padLeft(2, '0')}:'
        '${item.scannedAt.second.toString().padLeft(2, '0')}';

    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.qr_code_scanner)),
        title: SelectableText(item.value),
        subtitle: Text('${item.format}  •  $time'),
        trailing: IconButton(
          tooltip: 'コピー',
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: item.value));
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('読み取り結果をコピーしました。')));
            }
          },
          icon: const Icon(Icons.copy_outlined),
        ),
      ),
    );
  }
}
