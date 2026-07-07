import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

/// PDF رپورٹ بنانے کی سروس - اردو فونٹ کے ساتھ
class PdfService {
  static Future<pw.Font> _urduFont() async {
    // Noto Nastaliq Urdu font must be bundled locally for pdf package (it cannot use GoogleFonts network font).
    final fontData = await rootBundle.load('assets/fonts/NotoNastaliqUrdu-Regular.ttf');
    return pw.Font.ttf(fontData);
  }

  static Future<void> generateAndShareReport({
    required String title,
    required List<MapEntry<String, String>> rows,
  }) async {
    final doc = pw.Document();
    final font = await _urduFont();

    doc.addPage(
      pw.Page(
        textDirection: pw.TextDirection.rtl,
        build: (context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  title,
                  style: pw.TextStyle(font: font, fontSize: 22, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 16),
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey400),
                  children: rows
                      .map(
                        (e) => pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(e.value, style: pw.TextStyle(font: font, fontSize: 14)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(e.key, style: pw.TextStyle(font: font, fontSize: 14)),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.sharePdf(bytes: await doc.save(), filename: '${title.replaceAll(' ', '_')}.pdf');
  }
}
