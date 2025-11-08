import 'package:get/get.dart';
import 'package:fire_safety_console/core/constants.dart';
import 'package:fire_safety_console/data/models/detection_class.dart';

class SettingsController extends GetxController {
  // Observable state
  final isLoading = false.obs;
  final isSaving = false.obs;

  // YOLO Detection Settings
  final globalConfidenceThreshold = 0.5.obs;
  final detectionClasses = <DetectionClass>[].obs;

  // App Settings
  final isDarkMode = false.obs;
  final enableNotifications = true.obs;
  final enableSoundAlerts = true.obs;
  final autoRefreshInterval = 30.obs; // seconds

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }

  Future<void> _loadSettings() async {
    try {
      isLoading.value = true;

      // Load detection classes
      detectionClasses.value = [
        DetectionClass(
          id: 1,
          name: 'Fire',
          enabled: true,
          confidenceThreshold: 0.8,
          description: 'Fire detection',
          color: '#D13438',
        ),
        DetectionClass(
          id: 2,
          name: 'Smoke',
          enabled: true,
          confidenceThreshold: 0.7,
          description: 'Smoke detection',
          color: '#FFB900',
        ),
        DetectionClass(
          id: 3,
          name: 'Gas Leak',
          enabled: true,
          confidenceThreshold: 0.75,
          description: 'Gas leak detection',
          color: '#3B78FF',
        ),
        DetectionClass(
          id: 4,
          name: 'PPE Violation',
          enabled: true,
          confidenceThreshold: 0.6,
          description: 'Personal protective equipment violation',
          color: '#FFB900',
        ),
        DetectionClass(
          id: 5,
          name: 'Unauthorized Access',
          enabled: false,
          confidenceThreshold: 0.65,
          description: 'Unauthorized personnel access',
          color: '#D13438',
        ),
      ];

      // In production, would load from storage:
      // globalConfidenceThreshold.value = await _prefs.getDouble('confidence_threshold') ?? 0.5;
      // isDarkMode.value = await _prefs.getBool('dark_mode') ?? false;

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print('Error loading settings: $e');
    }
  }

  void setGlobalConfidenceThreshold(double value) {
    globalConfidenceThreshold.value = value;
  }

  void toggleDetectionClass(int classId) {
    final index = detectionClasses.indexWhere((c) => c.id == classId);
    if (index != -1) {
      final currentClass = detectionClasses[index];
      detectionClasses[index] = DetectionClass(
        id: currentClass.id,
        name: currentClass.name,
        enabled: !currentClass.enabled,
        confidenceThreshold: currentClass.confidenceThreshold,
        description: currentClass.description,
        color: currentClass.color,
      );
    }
  }

  void setClassConfidenceThreshold(int classId, double value) {
    final index = detectionClasses.indexWhere((c) => c.id == classId);
    if (index != -1) {
      final currentClass = detectionClasses[index];
      detectionClasses[index] = DetectionClass(
        id: currentClass.id,
        name: currentClass.name,
        enabled: currentClass.enabled,
        confidenceThreshold: value,
        description: currentClass.description,
        color: currentClass.color,
      );
    }
  }

  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value;
    // In production, would save to storage and update theme
  }

  void toggleNotifications() {
    enableNotifications.value = !enableNotifications.value;
  }

  void toggleSoundAlerts() {
    enableSoundAlerts.value = !enableSoundAlerts.value;
  }

  void setAutoRefreshInterval(int seconds) {
    autoRefreshInterval.value = seconds;
  }

  Future<void> saveSettings() async {
    try {
      isSaving.value = true;

      // In production, would save to backend:
      // await _settingsRepo.saveSettings({
      //   'global_confidence_threshold': globalConfidenceThreshold.value,
      //   'detection_classes': detectionClasses.map((c) => c.toJson()).toList(),
      //   'notifications_enabled': enableNotifications.value,
      //   'sound_alerts_enabled': enableSoundAlerts.value,
      //   'auto_refresh_interval': autoRefreshInterval.value,
      // });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      Get.snackbar(
        'Success',
        'Settings saved successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      isSaving.value = false;
    } catch (e) {
      isSaving.value = false;
      Get.snackbar(
        'Error',
        'Failed to save settings: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> resetToDefaults() async {
    globalConfidenceThreshold.value = Constants.yoloConfidenceThreshold;
    enableNotifications.value = true;
    enableSoundAlerts.value = true;
    autoRefreshInterval.value = 30;

    // Reset detection classes
    for (int i = 0; i < detectionClasses.length; i++) {
      final currentClass = detectionClasses[i];
      detectionClasses[i] = DetectionClass(
        id: currentClass.id,
        name: currentClass.name,
        enabled: true,
        confidenceThreshold: Constants.yoloConfidenceThreshold,
        description: currentClass.description,
        color: currentClass.color,
      );
    }

    Get.snackbar(
      'Success',
      'Settings reset to defaults',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
