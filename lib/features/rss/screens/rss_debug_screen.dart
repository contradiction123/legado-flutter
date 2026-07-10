import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';

/// RSS 源调试页面
///
/// 对标原：RssDebugActivity.kt
class RssDebugScreen extends ConsumerStatefulWidget {
  const RssDebugScreen({super.key});

  @override
  ConsumerState<RssDebugScreen> createState() => _RssDebugScreenState();
}

class _RssDebugScreenState extends ConsumerState<RssDebugScreen> {
  final _urlController = TextEditingController();
  String? _result;
  bool _isParsing = false;
  String? _error;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('RSS 调试')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // URL 输入
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(
              labelText: 'RSS 订阅地址',
              hintText: '输入 RSS/Atom 地址进行测试',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.link),
            ),
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 12),

          // 测试按钮
          FilledButton.icon(
            icon: _isParsing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.play_arrow),
            label: Text(_isParsing ? '解析中…' : '开始测试'),
            onPressed: _isParsing ? null : _startDebug,
          ),
          const SizedBox(height: 16),

          // 错误信息
          if (_error != null)
            Card(
              color: theme.colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: theme.colorScheme.error),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // 解析结果
          if (_result != null) ...[
            Text(
              '解析结果',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                _result!,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _startDebug() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      setState(() => _error = '请输入订阅地址');
      return;
    }

    setState(() {
      _isParsing = true;
      _error = null;
      _result = null;
    });

    try {
      // 使用 Dio 直接获取并展示 XML 内容
      final dio = DioClient.instance;
      final response = await dio.dio.get(url);
      setState(() {
        _result =
            '测试 URL: $url\n\n状态码: ${response.statusCode}\n\n${response.data.toString().substring(0, response.data.toString().length.clamp(0, 1000))}';
        _isParsing = false;
      });
    } catch (e) {
      setState(() {
        _error = '解析失败: $e';
        _isParsing = false;
      });
    }
  }
}
