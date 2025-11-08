import 'package:get/get.dart';
import 'package:fire_safety_console/core/mock_data.dart';
import 'package:fire_safety_console/core/constants.dart';
import 'package:fire_safety_console/data/models/incident.dart';
import 'package:fire_safety_console/data/repositories/incident_repository.dart';
import 'package:fire_safety_console/data/services/websocket_service.dart';

class IncidentDetailController extends GetxController {
  final IncidentRepository _incidentRepo = Get.find();
  final WebSocketService _wsService = Get.find();

  // Observable state
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Data observables
  final incident = Rx<Incident?>(null);
  final timeline = <Map<String, dynamic>>[].obs;

  // Action states
  final isAcknowledging = false.obs;
  final isEscalating = false.obs;
  final isClosing = false.obs;

  String? incidentId;

  @override
  void onInit() {
    super.onInit();
    incidentId = Get.arguments as String?;
    if (incidentId != null) {
      _loadIncidentDetail();
      _setupWebSocketListeners();
    } else {
      hasError.value = true;
      errorMessage.value = 'No incident ID provided';
    }
  }

  @override
  void onClose() {
    // Clean up listeners if needed
    super.onClose();
  }

  Future<void> _loadIncidentDetail() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      // Load incident from repository or mock data
      final incidents = MockData.getIncidents();
      incident.value = incidents.firstWhereOrNull((i) => i.id == incidentId);

      if (incident.value == null) {
        hasError.value = true;
        errorMessage.value = 'Incident not found';
      } else {
        _buildTimeline();
      }

      // In production, would call:
      // incident.value = await _incidentRepo.getIncidentById(incidentId!);

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = 'Failed to load incident: $e';
    }
  }

  void _buildTimeline() {
    final inc = incident.value;
    if (inc == null) return;

    timeline.clear();

    // Created event
    timeline.add({
      'timestamp': inc.createdAt,
      'title': 'Incident Created',
      'description': 'Incident detected by YOLO model',
      'icon': 'create',
    });

    // Acknowledged event
    if (inc.acknowledgedAt != null) {
      timeline.add({
        'timestamp': inc.acknowledgedAt,
        'title': 'Incident Acknowledged',
        'description': 'Incident reviewed by operator',
        'icon': 'acknowledge',
      });
    }

    // Closed event
    if (inc.closedAt != null) {
      timeline.add({
        'timestamp': inc.closedAt,
        'title': 'Incident Closed',
        'description': 'Incident resolved and closed',
        'icon': 'close',
      });
    }

    // Sort by timestamp descending
    timeline.sort((a, b) =>
        (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));
  }

  void _setupWebSocketListeners() {
    // Listen for real-time incident updates
    _wsService.messages.listen((message) {
      _handleWebSocketMessage(message);
    });
  }

  void _handleWebSocketMessage(Map<String, dynamic> message) {
    final type = message['type'] as String?;

    if (type == 'IncidentUpdated') {
      try {
        final updatedIncident = Incident.fromJson(message['data']);
        if (updatedIncident.id == incidentId) {
          incident.value = updatedIncident;
          _buildTimeline();
        }
      } catch (e) {
        print('Error handling incident update: $e');
      }
    }
  }

  Future<void> acknowledgeIncident() async {
    if (incident.value == null || isAcknowledging.value) return;

    try {
      isAcknowledging.value = true;

      // In production, would call:
      // await _incidentRepo.acknowledgeIncident(incidentId!);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Update local incident
      incident.value = incident.value!.copyWith(
        status: Constants.statusAcknowledged,
        acknowledgedAt: DateTime.now(),
      );

      _buildTimeline();

      Get.snackbar(
        'Success',
        'Incident acknowledged successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      isAcknowledging.value = false;
    } catch (e) {
      isAcknowledging.value = false;
      Get.snackbar(
        'Error',
        'Failed to acknowledge incident: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> escalateIncident() async {
    if (incident.value == null || isEscalating.value) return;

    try {
      isEscalating.value = true;

      // In production, would call:
      // await _incidentRepo.escalateIncident(incidentId!);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Update local incident
      incident.value = incident.value!.copyWith(
        status: Constants.statusEscalated,
      );

      _buildTimeline();

      Get.snackbar(
        'Success',
        'Incident escalated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      isEscalating.value = false;
    } catch (e) {
      isEscalating.value = false;
      Get.snackbar(
        'Error',
        'Failed to escalate incident: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> closeIncident() async {
    if (incident.value == null || isClosing.value) return;

    try {
      isClosing.value = true;

      // In production, would call:
      // await _incidentRepo.closeIncident(incidentId!);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Update local incident
      incident.value = incident.value!.copyWith(
        status: Constants.statusClosed,
        closedAt: DateTime.now(),
      );

      _buildTimeline();

      Get.snackbar(
        'Success',
        'Incident closed successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      isClosing.value = false;
    } catch (e) {
      isClosing.value = false;
      Get.snackbar(
        'Error',
        'Failed to close incident: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> refreshIncident() async {
    await _loadIncidentDetail();
  }

  void navigateToCamera(int cameraId) {
    Get.toNamed('/cameras', arguments: cameraId);
  }
}
