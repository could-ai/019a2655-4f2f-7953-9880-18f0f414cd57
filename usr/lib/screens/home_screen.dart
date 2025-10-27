import 'package:flutter/material.dart';
import 'package:couldai_user_app/services/scanner_service.dart';
import 'package:couldai_user_app/models/analysis_result.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();
  final ScannerService _scannerService = ScannerService();
  AnalysisResult? _analysisResult;
  bool _isLoading = false;
  String? _error;

  void _startAnalysis() async {
    if (_urlController.text.isEmpty) {
      setState(() {
        _error = "Please enter a URL";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _analysisResult = null;
      _error = null;
    });

    try {
      final result = await _scannerService.analyze(_urlController.text);
      setState(() {
        _analysisResult = result;
      });
    } catch (e) {
      setState(() {
        _error = "Failed to analyze URL: ${e.toString()}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Vulnerability Analyzer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Enter URL to analyze (e.g., https://example.com)',
                errorText: _error,
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _startAnalysis,
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text('Analyze'),
            ),
            const SizedBox(height: 24.0),
            if (_analysisResult != null)
              _buildResults(_analysisResult!),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(AnalysisResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analysis Results for: ${result.url}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        _buildResultCard(
          'HTTP Header Analysis',
          result.headerAnalysis,
        ),
        const SizedBox(height: 16),
        _buildResultCard(
          'Form Analysis',
          result.formAnalysis,
        ),
        const SizedBox(height: 16),
        _buildResultCard(
          'Vulnerable Libraries',
          result.vulnerableLibraries,
        ),
      ],
    );
  }

  Widget _buildResultCard(String title, Map<String, String> data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(height: 20),
            if (data.isEmpty)
              const Text('No issues found.')
            else
              ...data.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${entry.key}: ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Text(entry.value),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
