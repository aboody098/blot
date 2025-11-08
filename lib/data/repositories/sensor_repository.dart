import 'package:fire_safety_console/core/logger.dart';
import 'package:fire_safety_console/data/models/sensor.dart';
import 'package:fire_safety_console/data/services/api_client.dart';

class SensorRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<Sensor>> getSensors() async {
    try {
      final data = await _apiClient.getSensors();
      return data.map((json) => Sensor.fromJson(json)).toList();
    } catch (e) {
      Logger.error('Failed to get sensors', tag: 'SensorRepository', exception: e);
      rethrow;
    }
  }
}
