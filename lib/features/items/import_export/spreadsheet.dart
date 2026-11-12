// The .xlsx parts are XML fragments joined without spaces on purpose.
// ignore_for_file: missing_whitespace_between_adjacent_strings

import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:xml/xml.dart';

/// A sheet as rows of cell text. Short rows are not padded.
typedef Rows = List<List<String>>;

class SpreadsheetException implements Exception {
  const SpreadsheetException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Reads the first sheet of an `.xlsx` file, or a CSV file.
///
/// Detected from the content (xlsx is a zip, starting with "PK"), so a file
/// with the wrong extension still works.
Rows readSpreadsheet(Uint8List bytes) {
  if (bytes.length > 2 && bytes[0] == 0x50 && bytes[1] == 0x4B) {
    return readXlsx(bytes);
  }
  return readCsv(utf8.decode(bytes, allowMalformed: true));
}

// ---------------------------------------------------------------- CSV ----

/// RFC 4180 CSV: quoted fields, doubled quotes, line breaks inside quotes.
/// The separator (comma, semicolon or tab) is guessed from the first line,
/// because Excel in some locales saves "CSV" with semicolons.
Rows readCsv(String text) {
  var input = text;
  if (input.startsWith('﻿')) input = input.substring(1); // Excel BOM
  final firstLine = input.split('\n').first;
  final separator = [',', ';', '\t'].reduce(
    (best, s) =>
        s.allMatches(firstLine).length > best.allMatches(firstLine).length
        ? s
        : best,
  );

  final rows = <List<String>>[];
  var row = <String>[];
  final field = StringBuffer();
  var inQuotes = false;
  for (var i = 0; i < input.length; i++) {
    final c = input[i];
    if (inQuotes) {
      if (c == '"') {
        if (i + 1 < input.length && input[i + 1] == '"') {
          field.write('"');
          i++;
        } else {
          inQuotes = false;
        }
      } else {
        field.write(c);
      }
    } else if (c == '"') {
      inQuotes = true;
    } else if (c == separator) {
      row.add(field.toString());
      field.clear();
    } else if (c == '\n' || c == '\r') {
      if (c == '\r' && i + 1 < input.length && input[i + 1] == '\n') i++;
      row.add(field.toString());
      field.clear();
      rows.add(row);
      row = <String>[];
    } else {
      field.write(c);
    }
  }
  if (field.isNotEmpty || row.isNotEmpty) {
    row.add(field.toString());
    rows.add(row);
  }
  return rows
      .map((r) => r.map((c) => c.trim()).toList())
      .where((r) => r.any((c) => c.isNotEmpty))
      .toList();
}

String writeCsv(Rows rows) {
  String cell(String v) =>
      v.contains(RegExp('[",\r\n]')) ? '"${v.replaceAll('"', '""')}"' : v;
  // BOM so Excel opens UTF-8 (₹, Hindi names) correctly.
  return '﻿${rows.map((r) => r.map(cell).join(',')).join('\r\n')}\r\n';
}

// --------------------------------------------------------------- XLSX ----

/// Minimal reader for the first worksheet of an Office Open XML workbook.
Rows readXlsx(Uint8List bytes) {
  final Archive zip;
  try {
    zip = ZipDecoder().decodeBytes(bytes);
  } on Object {
    throw const SpreadsheetException('Not a valid .xlsx file');
  }
  String? text(String path) {
    final f = zip.findFile(path);
    return f == null ? null : utf8.decode(f.content);
  }

  // Shared strings (most text cells point here).
  final shared = <String>[];
  final sst = text('xl/sharedStrings.xml');
  if (sst != null) {
    for (final si in XmlDocument.parse(sst).findAllElements('si')) {
      shared.add(si.findAllElements('t').map((t) => t.innerText).join());
    }
  }

  // First sheet, via workbook.xml → its relationship target.
  var sheetPath = 'xl/worksheets/sheet1.xml';
  final workbook = text('xl/workbook.xml');
  final rels = text('xl/_rels/workbook.xml.rels');
  if (workbook != null && rels != null) {
    final first = XmlDocument.parse(workbook)
        .findAllElements('sheet')
        .firstOrNull;
    final rid =
        first?.getAttribute('r:id') ??
        first?.attributes.where((a) => a.name.local == 'id').firstOrNull?.value;
    final target = XmlDocument.parse(rels)
        .findAllElements('Relationship')
        .where((r) => r.getAttribute('Id') == rid)
        .firstOrNull
        ?.getAttribute('Target');
    if (target != null) {
      sheetPath = target.startsWith('/')
          ? target.substring(1)
          : 'xl/${target.replaceFirst(RegExp(r'^\./'), '')}';
    }
  }
  final sheet = text(sheetPath);
  if (sheet == null) {
    throw const SpreadsheetException('The workbook has no sheet');
  }

  final rows = <List<String>>[];
  for (final row in XmlDocument.parse(sheet).findAllElements('row')) {
    final cells = <int, String>{};
    var next = 0;
    for (final c in row.findElements('c')) {
      final ref = c.getAttribute('r');
      final col = ref == null ? next : _columnIndex(ref);
      next = col + 1;
      final type = c.getAttribute('t');
      final v = c.findElements('v').firstOrNull?.innerText;
      final value = switch (type) {
        's' => v == null ? '' : shared[int.parse(v)],
        'inlineStr' => c.findAllElements('t').map((t) => t.innerText).join(),
        'b' => v == '1' ? 'TRUE' : 'FALSE',
        'str' || 'e' => v ?? '',
        _ => v == null ? '' : _cleanNumber(v),
      };
      cells[col] = value.trim();
    }
    if (cells.isEmpty) continue;
    final width = cells.keys.reduce((a, b) => a > b ? a : b) + 1;
    final list = List.generate(width, (i) => cells[i] ?? '');
    if (list.any((c) => c.isNotEmpty)) rows.add(list);
  }
  return rows;
}

/// `A1` → 0, `C7` → 2, `AA3` → 26.
int _columnIndex(String ref) {
  var n = 0;
  for (final ch in ref.toUpperCase().codeUnits) {
    if (ch < 65 || ch > 90) break;
    n = n * 26 + (ch - 64);
  }
  return n - 1;
}

/// Excel stores numbers as floating point text: `240.00000000000003`,
/// `8.901719110054E12`. Turn them back into what the user typed.
String _cleanNumber(String raw) {
  final value = double.tryParse(raw);
  if (value == null) return raw;
  if (value == value.roundToDouble() && value.abs() < 1e15) {
    return value.toInt().toString();
  }
  final fixed = value.toStringAsFixed(6).replaceFirst(RegExp(r'\.?0+$'), '');
  return fixed;
}

/// Writes a single-sheet `.xlsx`. Text cells are inline strings (no shared
/// string table); numbers in [numericColumns] are written as numbers so
/// Excel can sum them. The first row is bold and frozen.
Uint8List writeXlsx(
  Rows rows, {
  String sheetName = 'Items',
  Set<int> numericColumns = const {},
}) {
  String esc(String v) => v
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');
  String col(int i) {
    var n = i + 1;
    var s = '';
    while (n > 0) {
      final r = (n - 1) % 26;
      s = String.fromCharCode(65 + r) + s;
      n = (n - 1) ~/ 26;
    }
    return s;
  }

  final sheet = StringBuffer()
    ..write(
      '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
      '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">'
      '<sheetViews><sheetView workbookViewId="0">'
      '<pane ySplit="1" topLeftCell="A2" activePane="bottomLeft" state="frozen"/>'
      '</sheetView></sheetViews><sheetData>',
    );
  for (var r = 0; r < rows.length; r++) {
    sheet.write('<row r="${r + 1}">');
    for (var c = 0; c < rows[r].length; c++) {
      final v = rows[r][c];
      if (v.isEmpty) continue;
      final ref = '${col(c)}${r + 1}';
      final style = r == 0 ? ' s="1"' : '';
      if (r > 0 && numericColumns.contains(c) && double.tryParse(v) != null) {
        sheet.write('<c r="$ref"$style><v>$v</v></c>');
      } else {
        sheet.write(
          '<c r="$ref" t="inlineStr"$style><is><t xml:space="preserve">${esc(v)}</t></is></c>',
        );
      }
    }
    sheet.write('</row>');
  }
  sheet.write('</sheetData></worksheet>');

  final files = <String, String>{
    '[Content_Types].xml':
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
        '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
        '<Default Extension="xml" ContentType="application/xml"/>'
        '<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>'
        '<Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>'
        '<Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>'
        '</Types>',
    '_rels/.rels':
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
        '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>'
        '</Relationships>',
    'xl/workbook.xml':
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" '
        'xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">'
        '<sheets><sheet name="${esc(sheetName)}" sheetId="1" r:id="rId1"/></sheets></workbook>',
    'xl/_rels/workbook.xml.rels':
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
        '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>'
        '<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>'
        '</Relationships>',
    'xl/styles.xml':
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">'
        '<fonts count="2"><font><sz val="11"/><name val="Calibri"/></font>'
        '<font><b/><sz val="11"/><name val="Calibri"/></font></fonts>'
        '<fills count="2"><fill><patternFill patternType="none"/></fill>'
        '<fill><patternFill patternType="gray125"/></fill></fills>'
        '<borders count="1"><border><left/><right/><top/><bottom/><diagonal/></border></borders>'
        '<cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>'
        '<cellXfs count="2"><xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/>'
        '<xf numFmtId="0" fontId="1" fillId="0" borderId="0" xfId="0" applyFont="1"/></cellXfs>'
        '</styleSheet>',
    'xl/worksheets/sheet1.xml': sheet.toString(),
  };
  final archive = Archive();
  files.forEach((name, content) {
    final data = utf8.encode(content);
    archive.addFile(ArchiveFile(name, data.length, data));
  });
  return Uint8List.fromList(ZipEncoder().encode(archive));
}
