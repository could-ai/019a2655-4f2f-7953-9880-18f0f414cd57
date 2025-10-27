class AnalysisResult {
  final String url;
  final String aiSummary;
  final Map<String, String> headerAnalysis;
  final Map<String, String> formAnalysis;
  final Map<String, String> vulnerableLibraries;

  AnalysisResult({
    required this.url,
    required this.aiSummary,
    required this.headerAnalysis,
    required this.formAnalysis,
    required this.vulnerableLibraries,
  });
}
