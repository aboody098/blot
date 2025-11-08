import 'package:get/get.dart';
import 'package:fire_safety_console/core/mock_data.dart';
import 'package:fire_safety_console/core/constants.dart';
import 'package:fire_safety_console/data/models/camera.dart';
import 'package:fire_safety_console/data/repositories/camera_repository.dart';
import 'package:fire_safety_console/data/services/websocket_service.dart';

class CamerasController extends GetxController {
  final CameraRepository _cameraRepo = Get.find();
  final WebSocketService _wsService = Get.find();

  // Observable state
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Data observables
  final cameras = <Camera>[].obs;

  // Action states
  final isAddingCamera = false.obs;
  final isDeletingCamera = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCameras();
    _setupWebSocketListeners();
  }

  @override
  void onClose() {
    // Clean up listeners if needed
    super.onClose();
  }

  Future<void> _loadCameras() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      // Load cameras from repository or mock data
      cameras.value = MockData.getCameras();

      // In production, would call:
      // cameras.value = await _cameraRepo.getAllCameras();

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = 'Failed to load cameras: $e';
    }
  }

  void _setupWebSocketListeners() {
    // Listen for real-time camera updates
    _wsService.messages.listen((message) {
      _handleWebSocketMessage(message);
    });
  }

  void _handleWebSocketMessage(Map<String, dynamic> message) {
    final type = message['type'] as String?;

    if (type == 'CameraStatusChanged') {
      try {
        final cameraData = message['data'] as Map<String, dynamic>;
        final cameraId = cameraData['id'] as int;

        // Update camera in list
        final index = cameras.indexWhere((c) => c.id == cameraId);
        if (index != -1) {
          cameras[index] = Camera.fromJson(cameraData);
        }
      } catch (e) {
        print('Error handling camera status change: $e');
      }
    }
  }

  Future<void> addCamera({
    required String name,
    required String location,
    required String ipAddress,
    required int port,
  }) async {
    try {
      isAddingCamera.value = true;

      // In production, would call:
      // final camera = await _cameraRepo.addCamera(
      //   name: name,
      //   location: location,
      //   ipAddress: ipAddress,
      //   port: port,
      // );

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Create new camera
      final newCamera = Camera(
        id: DateTime.now().millisecondsSinceEpoch,
        name: name,
        location: location,
        ipAddress: ipAddress,
        port: port,
        streamUrl: 'rtsp://$ipAddress:$port/stream',
        status: Constants.cameraStatusOffline,
        latitude: 25.3548,
        longitude: 55.3643,
        recordingEnabled: true,
        resolutionWidth: 1920,
        resolutionHeight: 1080,
        frameRate: 30,
      );

      cameras.add(newCamera);

      Get.snackbar(
        'Success',
        'Camera added successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      isAddingCamera.value = false;
    } catch (e) {
      isAddingCamera.value = false;
      Get.snackbar(
        'Error',
        'Failed to add camera: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updateCamera(Camera camera) async {
    try {
      // In production, would call:
      // await _cameraRepo.updateCamera(camera);

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      // Update camera in list
      final index = cameras.indexWhere((c) => c.id == camera.id);
      if (index != -1) {
        cameras[index] = camera;
      }

      Get.snackbar(
        'Success',
        'Camera updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update camera: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteCamera(int cameraId) async {
    try {
      isDeletingCamera.value = true;

      // In production, would call:
      // await _cameraRepo.deleteCamera(cameraId);

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      // Remove from list
      cameras.removeWhere((c) => c.id == cameraId);

      Get.snackbar(
        'Success',
        'Camera deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      isDeletingCamera.value = false;
    } catch (e) {
      isDeletingCamera.value = false;
      Get.snackbar(
        'Error',
        'Failed to delete camera: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> refreshCameras() async {
    await _loadCameras();
  }

  int get onlineCount =>
      cameras.where((c) => c.status == Constants.cameraStatusOnline).length;

  int get offlineCount =>
      cameras.where((c) => c.status == Constants.cameraStatusOffline).length;

  int get maintenanceCount => cameras
      .where((c) => c.status == Constants.cameraStatusMaintenance)
      .length;
}
