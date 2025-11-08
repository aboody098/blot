import 'package:get/get.dart';
import 'package:fire_safety_console/core/mock_data.dart';
import 'package:fire_safety_console/data/models/incident.dart';
import 'package:fire_safety_console/data/models/kpi_snapshot.dart';
import 'package:fire_safety_console/data/models/sensor.dart';
import 'package:fire_safety_console/data/models/service_status.dart';
import 'package:fire_safety_console/data/repositories/incident_repository.dart';
import 'package:fire_safety_console/data/repositories/sensor_repository.dart';
import 'package:fire_safety_console/data/services/websocket_service.dart';

class DashboardController extends GetxController {
  final IncidentRepository _incidentRepo = Get.find();
  final SensorRepository _sensorRepo = Get.find();
  final WebSocketService _wsService = Get.find();

  // Observable state
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Data observables
  final kpiSnapshot = Rx<KpiSnapshot?>(null);
  final recentIncidents = <Incident>[].obs;
  final sensors = <Sensor>[].obs;
  final serviceStatus = Rx<ServiceStatus?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadDashboardData();
    _setupWebSocketListeners();
  }

  @override
  void onClose() {
    // Clean up listeners if needed
    super.onClose();
  }

  Future<void> _loadDashboardData() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      // Load data from repositories or mock data
      await Future.wait([
        _loadKpis(),
        _loadRecentIncidents(),
        _loadSensors(),
        _loadServiceStatus(),
      ]);

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = 'Failed to load dashboard data: $e';
    }
  }

  Future<void> _loadKpis() async {
    try {
      // In demo mode, use mock data
      kpiSnapshot.value = MockData.getKpiSnapshot();

      // In production, would call:
      // kpiSnapshot.value = await _incidentRepo.getKpiSnapshot();
    } catch (e) {
      print('Error loading KPIs: $e');
    }
  }

  Future<void> _loadRecentIncidents() async {
    try {
      // Get recent incidents (last 5)
      final allIncidents = MockData.getIncidents();
      recentIncidents.value = allIncidents.take(5).toList();

      // In production, would call:
      // recentIncidents.value = await _incidentRepo.getRecentIncidents(limit: 5);
    } catch (e) {
      print('Error loading incidents: $e');
    }
  }

  Future<void> _loadSensors() async {
    try {
      sensors.value = MockData.getSensors();

      // In production, would call:
      // sensors.value = await _sensorRepo.getAllSensors();
    } catch (e) {
      print('Error loading sensors: $e');
    }
  }

  Future<void> _loadServiceStatus() async {
    try {
      serviceStatus.value = MockData.getServiceStatus();

      // In production, would call:
      // serviceStatus.value = await _healthRepo.getServiceStatus();
    } catch (e) {
      print('Error loading service status: $e');
    }
  }

  void _setupWebSocketListeners() {
    // Listen for real-time updates via WebSocket
    _wsService.messages.listen((message) {
      _handleWebSocketMessage(message);
    });
  }

  void _handleWebSocketMessage(Map<String, dynamic> message) {
    final type = message['type'] as String?;

    switch (type) {
      case 'IncidentCreated':
        _handleNewIncident(message);
        break;
      case 'SensorTick':
        _handleSensorUpdate(message);
        break;
      case 'ServiceHealthTick':
        _handleServiceHealthUpdate(message);
        break;
      default:
        break;
    }
  }

  void _handleNewIncident(Map<String, dynamic> message) {
    try {
      final incident = Incident.fromJson(message['data']);

      // Add to beginning of list
      recentIncidents.insert(0, incident);

      // Keep only 5 most recent
      if (recentIncidents.length > 5) {
        recentIncidents.removeLast();
      }

      // Update KPI
      if (kpiSnapshot.value != null) {
        // This would update the KPI counts
        _loadKpis();
      }
    } catch (e) {
      print('Error handling new incident: $e');
    }
  }

  void _handleSensorUpdate(Map<String, dynamic> message) {
    try {
      final sensorData = message['data'] as Map<String, dynamic>;
      final sensorId = sensorData['id'] as int;

      // Update sensor in list
      final index = sensors.indexWhere((s) => s.id == sensorId);
      if (index != -1) {
        sensors[index] = Sensor.fromJson(sensorData);
      }
    } catch (e) {
      print('Error handling sensor update: $e');
    }
  }

  void _handleServiceHealthUpdate(Map<String, dynamic> message) {
    try {
      serviceStatus.value = ServiceStatus.fromJson(message['data']);
    } catch (e) {
      print('Error handling service health update: $e');
    }
  }

  Future<void> refreshData() async {
    await _loadDashboardData();
  }

  void navigateToIncident(String incidentId) {
    Get.toNamed('/incident-detail', arguments: incidentId);
  }

  void navigateToIncidents() {
    Get.toNamed('/incidents');
  }

  void navigateToHealth() {
    Get.toNamed('/health');
  }
}
