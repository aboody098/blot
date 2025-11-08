import 'package:get/get.dart';
import 'package:fire_safety_console/core/mock_data.dart';
import 'package:fire_safety_console/data/repositories/analytics_repository.dart';

class AnalyticsController extends GetxController {
  final AnalyticsRepository _analyticsRepo = Get.find();

  // Observable state
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Data observables
  final alertTrends = <Map<String, dynamic>>[].obs;
  final ppeCompliance = <Map<String, dynamic>>[].obs;
  final cameraUptime = <Map<String, dynamic>>[].obs;

  // Time range filter
  final selectedTimeRange = '7 days'.obs;
  final timeRanges = ['24 hours', '7 days', '30 days', '90 days'];

  @override
  void onInit() {
    super.onInit();
    _loadAnalytics();
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }

  Future<void> _loadAnalytics() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      // Load analytics data from repository or mock data
      final data = MockData.getAnalytics();

      alertTrends.value = List<Map<String, dynamic>>.from(
        data['alert_trends'] ?? [],
      );

      ppeCompliance.value = List<Map<String, dynamic>>.from(
        data['ppe_compliance'] ?? [],
      );

      cameraUptime.value = List<Map<String, dynamic>>.from(
        data['camera_uptime'] ?? [],
      );

      // In production, would call:
      // final result = await _analyticsRepo.getAnalytics(
      //   timeRange: selectedTimeRange.value,
      // );

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = 'Failed to load analytics: $e';
    }
  }

  void setTimeRange(String range) {
    selectedTimeRange.value = range;
    _loadAnalytics();
  }

  Future<void> refreshAnalytics() async {
    await _loadAnalytics();
  }

  // Calculate totals
  int get totalAlerts {
    int total = 0;
    for (var trend in alertTrends) {
      total += (trend['critical'] as int? ?? 0);
      total += (trend['major'] as int? ?? 0);
      total += (trend['minor'] as int? ?? 0);
    }
    return total;
  }

  int get criticalAlerts {
    int total = 0;
    for (var trend in alertTrends) {
      total += (trend['critical'] as int? ?? 0);
    }
    return total;
  }

  double get averageCompliance {
    if (ppeCompliance.isEmpty) return 0.0;
    double total = 0;
    for (var item in ppeCompliance) {
      total += (item['compliance'] as int? ?? 0).toDouble();
    }
    return total / ppeCompliance.length;
  }

  double get averageUptime {
    if (cameraUptime.isEmpty) return 0.0;
    double total = 0;
    for (var item in cameraUptime) {
      total += (item['uptime'] as num? ?? 0).toDouble();
    }
    return total / cameraUptime.length;
  }
}
