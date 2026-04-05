import '../../core/api/api_client.dart';
import '../models/report_model.dart';

class ReportService {
  final ApiClient _apiClient;

  ReportService(this._apiClient);

  /// Submit a new issue report for a location.
  Future<ReportModel> submitReport(ReportModel report) async {
    final response = await _apiClient.post('/reports', data: report.toJson());
    return ReportModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Fetch all submitted reports (for admin/history use).
  Future<List<ReportModel>> getReports() async {
    final response = await _apiClient.get('/reports');
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => ReportModel.fromJson(json as Map<String, dynamic>)).toList();
  }
}
