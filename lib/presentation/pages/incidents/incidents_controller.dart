import 'package:get/get.dart';
import 'package:fire_safety_console/core/mock_data.dart';
import 'package:fire_safety_console/core/constants.dart';
import 'package:fire_safety_console/data/models/incident.dart';
import 'package:fire_safety_console/data/repositories/incident_repository.dart';
import 'package:fire_safety_console/data/services/websocket_service.dart';

class IncidentsController extends GetxController {
  final IncidentRepository _incidentRepo = Get.find();
  final WebSocketService _wsService = Get.find();

  // Observable state
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Data observables
  final incidents = <Incident>[].obs;
  final filteredIncidents = <Incident>[].obs;

  // Filter observables
  final selectedSeverity = Rx<String?>(null);
  final selectedStatus = Rx<String?>(null);
  final searchQuery = ''.obs;

  // Available filter options
  final severities = [
    Constants.severityCritical,
    Constants.severityMajor,
    Constants.severityMinor,
  ];

  final statuses = [
    Constants.statusOpen,
    Constants.statusAcknowledged,
    Constants.statusEscalated,
    Constants.statusClosed,
  ];

  @override
  void onInit() {
    super.onInit();
    _loadIncidents();
    _setupWebSocketListeners();
  }

  @override
  void onClose() {
    // Clean up listeners if needed
    super.onClose();
  }

  Future<void> _loadIncidents() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      // Load incidents from repository or mock data
      incidents.value = MockData.getIncidents();

      // In production, would call:
      // incidents.value = await _incidentRepo.getAllIncidents();

      // Apply initial filters
      _applyFilters();

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = 'Failed to load incidents: $e';
    }
  }

  void _setupWebSocketListeners() {
    // Listen for real-time incident updates
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
      case 'IncidentUpdated':
        _handleIncidentUpdate(message);
        break;
      default:
        break;
    }
  }

  void _handleNewIncident(Map<String, dynamic> message) {
    try {
      final incident = Incident.fromJson(message['data']);

      // Add to beginning of list
      incidents.insert(0, incident);

      // Reapply filters
      _applyFilters();
    } catch (e) {
      print('Error handling new incident: $e');
    }
  }

  void _handleIncidentUpdate(Map<String, dynamic> message) {
    try {
      final incident = Incident.fromJson(message['data']);

      // Update incident in list
      final index = incidents.indexWhere((i) => i.id == incident.id);
      if (index != -1) {
        incidents[index] = incident;
      }

      // Reapply filters
      _applyFilters();
    } catch (e) {
      print('Error handling incident update: $e');
    }
  }

  void _applyFilters() {
    var filtered = incidents.toList();

    // Filter by severity
    if (selectedSeverity.value != null) {
      filtered = filtered
          .where((i) => i.severity == selectedSeverity.value)
          .toList();
    }

    // Filter by status
    if (selectedStatus.value != null) {
      filtered = filtered
          .where((i) => i.status == selectedStatus.value)
          .toList();
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((i) {
        return i.title.toLowerCase().contains(query) ||
            i.description.toLowerCase().contains(query) ||
            i.detectionClass.toLowerCase().contains(query) ||
            i.id.toLowerCase().contains(query);
      }).toList();
    }

    filteredIncidents.value = filtered;
  }

  void setSeverityFilter(String? severity) {
    selectedSeverity.value = severity;
    _applyFilters();
  }

  void setStatusFilter(String? status) {
    selectedStatus.value = status;
    _applyFilters();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void clearFilters() {
    selectedSeverity.value = null;
    selectedStatus.value = null;
    searchQuery.value = '';
    _applyFilters();
  }

  Future<void> refreshIncidents() async {
    await _loadIncidents();
  }

  void navigateToIncident(String incidentId) {
    Get.toNamed('/incident-detail', arguments: incidentId);
  }

  int get criticalCount =>
      incidents.where((i) => i.severity == Constants.severityCritical).length;

  int get majorCount =>
      incidents.where((i) => i.severity == Constants.severityMajor).length;

  int get minorCount =>
      incidents.where((i) => i.severity == Constants.severityMinor).length;

  int get openCount =>
      incidents.where((i) => i.status == Constants.statusOpen).length;
}
