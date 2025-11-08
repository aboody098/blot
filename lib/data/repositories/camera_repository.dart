import 'package:fire_safety_console/core/logger.dart';
import 'package:fire_safety_console/data/models/camera.dart';
import 'package:fire_safety_console/data/services/api_client.dart';

class CameraRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<Camera>> getCameras() async {
    try {
      final data = await _apiClient.getCameras();
      return data.map((json) => Camera.fromJson(json)).toList();
    } catch (e) {
      Logger.error('Failed to get cameras', tag: 'CameraRepository', exception: e);
      rethrow;
    }
  }

  Future<Camera> addCamera(Camera camera) async {
    try {
      final data = await _apiClient.addCamera(camera.toJson());
      return Camera.fromJson(data);
    } catch (e) {
      Logger.error('Failed to add camera', tag: 'CameraRepository', exception: e);
      rethrow;
    }
  }

  Future<void> updateCamera(Camera camera) async {
    try {
      await _apiClient.updateCamera(camera.id, camera.toJson());
    } catch (e) {
      Logger.error('Failed to update camera', tag: 'CameraRepository',
          exception: e);
      rethrow;
    }
  }

  Future<void> deleteCamera(int id) async {
    try {
      await _apiClient.deleteCamera(id);
    } catch (e) {
      Logger.error('Failed to delete camera', tag: 'CameraRepository',
          exception: e);
      rethrow;
    }
  }
}
