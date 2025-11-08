import 'package:fire_safety_console/core/logger.dart';
import 'package:fire_safety_console/data/services/api_client.dart';

class AnalyticsRepository {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> getAnalytics({DateTime? from, DateTime? to}) async {
    try {
      final data = await _apiClient.getAnalytics(from: from, to: to);
      return data;
    } catch (e) {
      Logger.error('Failed to get analytics', tag: 'AnalyticsRepository',
          exception: e);
      rethrow;
    }
  }

  // Parse analytics data to extract specific metrics
  List<Map<String, dynamic>> getAlertTrends(Map<String, dynamic> data) {
    final trends = data['alert_trends'] as List? ?? [];
    return List<Map<String, dynamic>>.from(trends);
  }

  List<Map<String, dynamic>> getPPECompliance(Map<String, dynamic> data) {
    final compliance = data['ppe_compliance'] as List? ?? [];
    return List<Map<String, dynamic>>.from(compliance);
  }

  List<Map<String, dynamic>> getCameraUptime(Map<String, dynamic> data) {
    final uptime = data['camera_uptime'] as List? ?? [];
    return List<Map<String, dynamic>>.from(uptime);
  }
}
