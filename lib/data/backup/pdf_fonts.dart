import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

/// Fonts embedded in the PDF world book: Roboto (Latin, Cyrillic, Greek)
/// with a Noto Sans SC subset as fallback for Chinese. The built-in PDF
/// Times font is Latin-1 only and turned everything else into boxes.
class PdfFonts {
  final pw.Font base;
  final pw.Font bold;
  final pw.Font italic;
  final List<pw.Font> fallback;

  const PdfFonts({
    required this.base,
    required this.bold,
    required this.italic,
    this.fallback = const [],
  });

  static Future<PdfFonts> load([AssetBundle? bundle]) async {
    final assets = bundle ?? rootBundle;
    Future<pw.Font> font(String name) async =>
        pw.Font.ttf(await assets.load('assets/fonts/$name'));
    return PdfFonts(
      base: await font('Roboto-Regular.ttf'),
      bold: await font('Roboto-Bold.ttf'),
      italic: await font('Roboto-Italic.ttf'),
      fallback: [await font('NotoSansSC-Subset.ttf')],
    );
  }

  pw.ThemeData get theme => pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
        boldItalic: bold,
        fontFallback: fallback,
      );
}
