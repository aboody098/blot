import 'package:fire_safety_console/core/logger.dart';
import 'package:fire_safety_console/data/models/incident.dart';
import 'package:fire_safety_console/data/services/api_client.dart';

class IncidentRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<Incident>> getIncidents({
    int? limit,
    int? offset,
    String? status,
    String? severity,
  }) async {
    try {
      final data = await _apiClient.getIncidents(
        limit: limit ?? 50,
        offset: offset ?? 0,
        status: status,
        severity: severity,
      );
      return data.map((json) => Incident.fromJson(json)).toList();
    } catch (e) {
      Logger.error('Failed to get incidents', tag: 'IncidentRepository',
          exception: e);
      rethrow;
    }
  }

  Future<Incident> getIncident(String id) async {
    try {
      final data = await _apiClient.getIncident(id);
      return Incident.fromJson(data);
    } catch (e) {
      Logger.error('Failed to get incident', tag: 'IncidentRepository',
          exception: e);
      rethrow;
    }
  }

  Future<void> acknowledgeIncident(String id) async {
    try {
      await _apiClient.acknowledgeIncident(id);
    } catch (e) {
      Logger.error('Failed to acknowledge incident', tag: 'IncidentRepository',
          exception: e);
      rethrow;
    }
  }

  Future<void> escalateIncident(String id) async {
    try {
      await _apiClient.escalateIncident(id);
    } catch (e) {
      Logger.error('Failed to escalate incident', tag: 'IncidentRepository',
          exception: e);
      rethrow;
    }
  }

  Future<void> closeIncident(String id) async {
    try {
      await _apiClient.closeIncident(id);
    } catch (e) {
      Logger.error('Failed to close incident', tag: 'IncidentRepository',
          exception: e);
      rethrow;
    }
  }
}
