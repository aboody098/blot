import 'package:get/get.dart';
import 'package:fire_safety_console/core/mock_data.dart';
import 'package:fire_safety_console/data/models/camera.dart';
import 'package:fire_safety_console/data/repositories/camera_repository.dart';
import 'package:fire_safety_console/data/services/websocket_service.dart';

class OperationsController extends GetxController {
  final CameraRepository _cameraRepo = Get.find();
  final WebSocketService _wsService = Get.find();

  // Observable state
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Data observables
  final cameras = <Camera>[].obs;
  final selectedCameraId = Rx<int?>(null);
  final gridColumns = 2.obs; // 2x2, 3x3, etc.

  // Metrics observables
  final totalDetections = 0.obs;
  final activeAlerts = 0.obs;
  final averageFps = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCameras();
    _setupWebSocketListeners();
    _simulateMetrics();
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

    switch (type) {
      case 'CameraStatusChanged':
        _handleCameraStatusChange(message);
        break;
      case 'DetectionEvent':
        _handleDetectionEvent(message);
        break;
      default:
        break;
    }
  }

  void _handleCameraStatusChange(Map<String, dynamic> message) {
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

  void _handleDetectionEvent(Map<String, dynamic> message) {
    // Update detection metrics
    totalDetections.value++;
    activeAlerts.value++;
  }

  void _simulateMetrics() {
    // Simulate real-time metrics updates
    Future.delayed(const Duration(seconds: 1), () {
      if (!isClosed) {
        averageFps.value = 28.5 + (DateTime.now().millisecond % 100) / 100;
        _simulateMetrics();
      }
    });
  }

  void setGridColumns(int columns) {
    gridColumns.value = columns;
  }

  void selectCamera(int? cameraId) {
    selectedCameraId.value = cameraId;
  }

  void toggleFullScreen(int cameraId) {
    if (selectedCameraId.value == cameraId) {
      selectedCameraId.value = null;
    } else {
      selectedCameraId.value = cameraId;
    }
  }

  Future<void> refreshCameras() async {
    await _loadCameras();
  }

  void navigateToCameraSettings(int cameraId) {
    Get.toNamed('/cameras', arguments: cameraId);
  }
}
