import 'package:flutter/services.dart';

class FileShareChannel {
  const FileShareChannel();

  static const MethodChannel _channel = MethodChannel(
    'com.legado.legado_flutter/file_share',
  );

  Future<void> shareFile(String path, String title) async {
    await _channel.invokeMethod<void>('shareFile', {
      'path': path,
      'title': title,
    });
  }
}
