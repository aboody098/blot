import 'package:get/get.dart';
import 'package:fire_safety_console/core/mock_data.dart';
import 'package:fire_safety_console/data/models/service_status.dart';
import 'package:fire_safety_console/data/services/websocket_service.dart';

class HealthController extends GetxController {
  final WebSocketService _wsService = Get.find();

  // Observable state
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Data observables
  final serviceStatus = Rx<ServiceStatus?>(null);
  final logs = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadServiceHealth();
    _setupWebSocketListeners();
  }

  @override
  void onClose() {
    // Clean up listeners if needed
    super.onClose();
  }

  Future<void> _loadServiceHealth() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      // Load service status from mock data
      final status = MockData.getServiceStatus();
      serviceStatus.value = status;
      logs.value = status.logs;

      // In production, would call:
      // serviceStatus.value = await _healthRepo.getServiceStatus();

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = 'Failed to load service health: $e';
    }
  }

  void _setupWebSocketListeners() {
    // Listen for real-time health updates
    _wsService.messages.listen((message) {
      _handleWebSocketMessage(message);
    });
  }

  void _handleWebSocketMessage(Map<String, dynamic> message) {
    final type = message['type'] as String?;

    if (type == 'ServiceHealthTick') {
      try {
        serviceStatus.value = ServiceStatus.fromJson(message['data']);
        if (serviceStatus.value != null) {
          logs.value = serviceStatus.value!.logs;
        }
      } catch (e) {
        print('Error handling service health update: $e');
      }
    }
  }

  Future<void> refreshHealth() async {
    await _loadServiceHealth();
  }

  String get statusText {
    final status = serviceStatus.value?.status;
    return status ?? 'UNKNOWN';
  }

  bool get isHealthy {
    return serviceStatus.value?.status == 'HEALTHY';
  }

  bool get isDegraded {
    return serviceStatus.value?.status == 'DEGRADED';
  }

  bool get isCritical {
    return serviceStatus.value?.status == 'CRITICAL';
  }
}
