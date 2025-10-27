import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:couldai_user_app/models/analysis_result.dart';

class PdfService {
  Future<Uint8List> generatePdf(AnalysisResult result) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          _buildHeader(result),
          pw.Divider(),
          _buildSection(
            'AI-Powered Summary & Recommendations',
            {'Executive Summary': result.aiSummary},
          ),
          _buildSection('HTTP Header Analysis', result.headerAnalysis),
          _buildSection('Form Analysis', result.formAnalysis),
          _buildSection('Vulnerable Libraries', result.vulnerableLibraries),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader(AnalysisResult result) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Vulnerability Analysis Report',
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          'Target URL: ${result.url}',
          style: const pw.TextStyle(fontSize: 16),
        ),
        pw.SizedBox(height: 16),
      ],
    );
  }

  pw.Widget _buildSection(String title, Map<String, String> data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        if (data.isEmpty)
          pw.Text('No issues found.')
        else
          ...data.entries.map((entry) {
            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 8.0),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '${entry.key}: ',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Expanded(
                    child: pw.Text(entry.value),
                  ),
                ],
              ),
            );
          }),
        pw.SizedBox(height: 16),
      ],
    );
  }
}
