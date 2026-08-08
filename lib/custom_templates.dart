import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'template_model.dart';
import 'template_store.dart';

class CustomTemplateScreen extends StatefulWidget {
  const CustomTemplateScreen({super.key});

  @override
  State<CustomTemplateScreen> createState() => _CustomTemplateScreenState();
}

class _CustomTemplateScreenState extends State<CustomTemplateScreen> {
  final BrowserTemplateStore _store = BrowserTemplateStore();
  final Map<String, TextEditingController> _controllers = {};
  List<CustomCodeTemplate> _templates = [];
  CustomCodeTemplate? _selected;
  String? _warning;
  String? _generatedValue;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final decoded = decodeTemplates(await _store.read());
    if (!mounted) return;
    setState(() {
      _templates = decoded.templates;
      _warning = decoded.warning;
      _loading = false;
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _select(CustomCodeTemplate? template) {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    if (template != null) {
      for (final field in template.fields) {
        _controllers[field.id] = TextEditingController(
          text: field.defaultValue,
        );
      }
    }
    setState(() {
      _selected = template;
      _generatedValue = null;
    });
  }

  Map<String, String> get _values => {
    for (final entry in _controllers.entries) entry.key: entry.value.text,
  };

  TemplateBuildResult get _preview => _selected == null
      ? const TemplateBuildResult.invalid('テンプレートを選択してください。')
      : buildTemplateValue(_selected!, _values);

  Future<void> _saveTemplate(CustomCodeTemplate template) async {
    final index = _templates.indexWhere((item) => item.id == template.id);
    setState(() {
      if (index < 0) {
        _templates = [..._templates, template];
      } else {
        _templates = [..._templates]..[index] = template;
      }
      _warning = null;
    });
    await _store.write(encodeTemplates(_templates));
    if (mounted) _select(template);
  }

  Future<void> _openEditor({
    CustomCodeTemplate? template,
    bool copy = false,
  }) async {
    final result = await Navigator.of(context).push<CustomCodeTemplate>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) =>
            TemplateEditorScreen(template: template, saveAsCopy: copy),
      ),
    );
    if (result != null) await _saveTemplate(result);
  }

  Future<void> _delete() async {
    final selected = _selected;
    if (selected == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('テンプレートを削除しますか？'),
        content: Text('「${selected.name}」は元に戻せません。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('削除'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() {
      _templates = _templates.where((item) => item.id != selected.id).toList();
    });
    _select(null);
    await _store.write(encodeTemplates(_templates));
  }

  void _generate() {
    final preview = _preview;
    if (!preview.isValid) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(preview.error!)));
      return;
    }
    setState(() => _generatedValue = preview.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('カスタムテンプレート')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(),
        icon: const Icon(Icons.add),
        label: const Text('新規作成'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('テンプレートはこのブラウザー内だけに保存され、サーバーには送信されません。'),
                        if (_warning != null) ...[
                          const SizedBox(height: 12),
                          MaterialBanner(
                            content: Text(_warning!),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    setState(() => _warning = null),
                                child: const Text('閉じる'),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          key: const Key('template_selector'),
                          initialValue: _selected?.id,
                          decoration: const InputDecoration(
                            labelText: 'テンプレートを選択',
                          ),
                          items: _templates
                              .map(
                                (template) => DropdownMenuItem(
                                  value: template.id,
                                  child: Text(template.name),
                                ),
                              )
                              .toList(),
                          onChanged: (id) => _select(
                            _templates
                                .where((item) => item.id == id)
                                .firstOrNull,
                          ),
                        ),
                        if (_templates.isEmpty) ...[
                          const SizedBox(height: 12),
                          const Text('まだテンプレートがありません。「新規作成」から登録してください。'),
                        ],
                        if (_selected != null) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () =>
                                    _openEditor(template: _selected),
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text('編集'),
                              ),
                              OutlinedButton.icon(
                                onPressed: () => _openEditor(
                                  template: _selected,
                                  copy: true,
                                ),
                                icon: const Icon(Icons.copy_all_outlined),
                                label: const Text('コピーして保存'),
                              ),
                              OutlinedButton.icon(
                                onPressed: _delete,
                                icon: const Icon(Icons.delete_outline),
                                label: const Text('削除'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '原始形式',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          SelectableText(_selected!.source),
                          const SizedBox(height: 20),
                          for (final field in _selected!.fields) ...[
                            TextField(
                              key: Key('template_field_${field.id}'),
                              controller: _controllers[field.id],
                              maxLength: field.maxLength,
                              decoration: InputDecoration(
                                labelText: field.name,
                                hintText: field.placeholder,
                                helperText: field.replaceAll
                                    ? '同じ対象文字をすべて変更します'
                                    : '最初に一致する対象文字を変更します',
                              ),
                              onChanged: (_) => setState(() {
                                _generatedValue = null;
                              }),
                            ),
                            const SizedBox(height: 8),
                          ],
                          Card(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerLow,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '自動拼接プレビュー',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  SelectableText(
                                    _preview.value ?? _preview.error!,
                                    key: const Key('template_preview'),
                                    style: TextStyle(
                                      color: _preview.isValid
                                          ? null
                                          : Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          FilledButton.icon(
                            key: const Key('generate_template_qr'),
                            onPressed: _generate,
                            icon: const Icon(Icons.qr_code_2),
                            label: const Text('QRコードを生成'),
                          ),
                        ],
                        if (_generatedValue != null) ...[
                          const SizedBox(height: 24),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Container(
                                    color: Colors.white,
                                    padding: const EdgeInsets.all(12),
                                    child: BarcodeWidget(
                                      barcode: Barcode.qrCode(),
                                      data: _generatedValue!,
                                      width: 230,
                                      height: 230,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SelectableText(_generatedValue!),
                                  TextButton.icon(
                                    onPressed: () => Clipboard.setData(
                                      ClipboardData(text: _generatedValue!),
                                    ),
                                    icon: const Icon(Icons.copy_outlined),
                                    label: const Text('完成データをコピー'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class TemplateEditorScreen extends StatefulWidget {
  const TemplateEditorScreen({
    super.key,
    this.template,
    this.saveAsCopy = false,
  });

  final CustomCodeTemplate? template;
  final bool saveAsCopy;

  @override
  State<TemplateEditorScreen> createState() => _TemplateEditorScreenState();
}

class _TemplateEditorScreenState extends State<TemplateEditorScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _sourceController;
  late List<TemplateFieldDefinition> _fields;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.saveAsCopy && widget.template != null
          ? '${widget.template!.name} のコピー'
          : widget.template?.name ?? '',
    );
    _sourceController = TextEditingController(
      text: widget.template?.source ?? '',
    );
    _fields = [...?widget.template?.fields];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sourceController.dispose();
    super.dispose();
  }

  Future<void> _addOrEditField({int? index}) async {
    final current = index == null ? null : _fields[index];
    final name = TextEditingController(text: current?.name ?? '');
    final placeholder = TextEditingController(text: current?.placeholder ?? '');
    final defaultValue = TextEditingController(
      text: current?.defaultValue ?? '',
    );
    final maxLength = TextEditingController(
      text: current?.maxLength?.toString() ?? '',
    );
    var replaceAll = current?.replaceAll ?? false;
    final result = await showDialog<TemplateFieldDefinition>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(index == null ? 'フィールドを追加' : 'フィールドを編集'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  key: const Key('field_name'),
                  controller: name,
                  decoration: const InputDecoration(labelText: 'フィールド名'),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('field_placeholder'),
                  controller: placeholder,
                  decoration: const InputDecoration(
                    labelText: '原始形式内の対象文字',
                    hintText: 'AAAAAAA',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('field_default'),
                  controller: defaultValue,
                  decoration: const InputDecoration(labelText: '初期値（必須）'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: maxLength,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(labelText: '最大文字数（任意）'),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: replaceAll,
                  onChanged: (value) =>
                      setDialogState(() => replaceAll = value ?? false),
                  title: const Text('同じ対象文字をすべてこのフィールドにする'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('キャンセル'),
            ),
            FilledButton(
              onPressed: () {
                final fieldName = name.text.trim();
                final token = placeholder.text;
                final initial = defaultValue.text.trim();
                final limit = int.tryParse(maxLength.text);
                if (fieldName.isEmpty || token.isEmpty || initial.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('名前、対象文字、初期値を入力してください。')),
                  );
                  return;
                }
                if (!_sourceController.text.contains(token)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('対象文字が原始形式に見つかりません。')),
                  );
                  return;
                }
                if (limit != null && initial.length > limit) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('初期値が最大文字数を超えています。')),
                  );
                  return;
                }
                Navigator.pop(
                  context,
                  TemplateFieldDefinition(
                    id:
                        current?.id ??
                        'field_${DateTime.now().microsecondsSinceEpoch}',
                    name: fieldName,
                    placeholder: token,
                    defaultValue: initial,
                    maxLength: limit != null && limit > 0 ? limit : null,
                    replaceAll: replaceAll,
                  ),
                );
              },
              child: const Text('追加'),
            ),
          ],
        ),
      ),
    );
    if (result == null) return;
    setState(() {
      if (index == null) {
        _fields.add(result);
      } else {
        _fields[index] = result;
      }
    });
  }

  void _save() {
    final name = _nameController.text.trim();
    final source = _sourceController.text;
    if (name.isEmpty || source.isEmpty || _fields.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('名前、原始形式、1つ以上のフィールドが必要です。')));
      return;
    }
    final candidate = CustomCodeTemplate(
      id: widget.saveAsCopy || widget.template == null
          ? 'template_${DateTime.now().microsecondsSinceEpoch}'
          : widget.template!.id,
      name: name,
      source: source,
      fields: _fields,
      updatedAt: DateTime.now(),
    );
    final check = buildTemplateValue(candidate, const {});
    if (!check.isValid) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(check.error!)));
      return;
    }
    Navigator.pop(context, candidate);
  }

  @override
  Widget build(BuildContext context) {
    final sample = CustomCodeTemplate(
      id: 'preview',
      name: _nameController.text,
      source: _sourceController.text,
      fields: _fields,
      updatedAt: DateTime.now(),
    );
    final preview = buildTemplateValue(sample, const {});
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.template == null ? 'テンプレート作成' : 'テンプレート編集'),
        actions: [
          TextButton(
            key: const Key('save_template_top'),
            onPressed: _save,
            child: const Text('保存'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    key: const Key('template_name'),
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'テンプレート名'),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    key: const Key('template_source'),
                    controller: _sourceController,
                    minLines: 3,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: '原始形式',
                      hintText: '製番 M6123456789012AAAAAAAABBBBBBB511111111',
                      helperText: '変更したい部分も含め、完成形に近い文字列を入力します。',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '可変フィールド',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      FilledButton.tonalIcon(
                        key: const Key('add_template_field'),
                        onPressed: _addOrEditField,
                        icon: const Icon(Icons.add),
                        label: const Text('フィールド追加'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  for (var index = 0; index < _fields.length; index++)
                    Card(
                      child: ListTile(
                        title: Text(_fields[index].name),
                        subtitle: Text(
                          '対象: ${_fields[index].placeholder}  初期値: ${_fields[index].defaultValue}',
                        ),
                        onTap: () => _addOrEditField(index: index),
                        trailing: IconButton(
                          tooltip: 'フィールドを削除',
                          onPressed: () =>
                              setState(() => _fields.removeAt(index)),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text('プレビュー', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  SelectableText(preview.value ?? preview.error!),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    key: const Key('save_template'),
                    onPressed: _save,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('保存'),
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
