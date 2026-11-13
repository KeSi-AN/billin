import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

/// Hands a file to the share sheet (WhatsApp to the CA, Drive, email…).
typedef ShareReport = Future<void> Function(String path, String text);

const _mimeTypes = {
  '.xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  '.pdf': 'application/pdf',
  '.zip': 'application/zip',
};

Future<void> shareReportWithSystem(String path, String text) async {
  await SharePlus.instance.share(
    ShareParams(
      files: [XFile(path, mimeType: _mimeTypes[p.extension(path)])],
      text: text,
    ),
  );
}

/// Writes [bytes] to `<temp>/exports/<name>` and returns the path.
Future<String> saveExport(
  Future<Directory> Function() tempDir,
  String name,
  Uint8List bytes,
) async {
  final dir = Directory(p.join((await tempDir()).path, 'exports'));
  await dir.create(recursive: true);
  final file = File(p.join(dir.path, name));
  await file.writeAsBytes(bytes, flush: true);
  return file.path;
}

/// `Day book` + `2026-11-13` → `Day_book_2026-11-13`.
String exportName(String title, DateTime date) {
  final d =
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  return '${title.replaceAll(RegExp('[^A-Za-z0-9]+'), '_')}_$d';
}
