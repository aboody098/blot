import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fire_safety_console/app/theme/colors.dart';
import 'package:fire_safety_console/app/theme/text_styles.dart';
import 'package:fire_safety_console/presentation/pages/settings/settings_controller.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: controller.resetToDefaults,
            child: const Text('Reset'),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // YOLO Detection Settings Section
              _buildSectionHeader('YOLO Detection Settings', isDark),
              _buildGlobalThresholdSetting(isDark),
              const SizedBox(height: 8),
              _buildDetectionClassesSection(isDark),

              const SizedBox(height: 24),

              // App Settings Section
              _buildSectionHeader('App Settings', isDark),
              _buildAppSettings(isDark),

              const SizedBox(height: 32),

              // Save Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Obx(() => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isSaving.value
                            ? null
                            : controller.saveSettings,
                        child: controller.isSaving.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Save Settings'),
                      ),
                    )),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Text(
        title,
        style: AppTextStyles.headlineSmall.copyWith(
          color: isDark ? AppColors.darkText : AppColors.lightText,
        ),
      ),
    );
  }

  Widget _buildGlobalThresholdSetting(bool isDark) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 0,
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Global Confidence Threshold',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                Obx(() => Text(
                      controller.globalConfidenceThreshold.value.toStringAsFixed(2),
                      style: AppTextStyles.titleMedium.copyWith(
                        color: isDark ? AppColors.primaryLight : AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ],
            ),
            const SizedBox(height: 8),
            Obx(() => Slider(
                  value: controller.globalConfidenceThreshold.value,
                  min: 0.0,
                  max: 1.0,
                  divisions: 20,
                  onChanged: controller.setGlobalConfidenceThreshold,
                )),
            Text(
              'Minimum confidence score for all detections',
              style: AppTextStyles.caption.copyWith(
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetectionClassesSection(bool isDark) {
    return Obx(() => Column(
          children: controller.detectionClasses.map((detectionClass) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              elevation: 0,
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detectionClass.name,
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: isDark
                                      ? AppColors.darkText
                                      : AppColors.lightText,
                                ),
                              ),
                              if (detectionClass.description != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  detectionClass.description!,
                                  style: AppTextStyles.caption.copyWith(
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Switch(
                          value: detectionClass.enabled,
                          onChanged: (_) =>
                              controller.toggleDetectionClass(detectionClass.id),
                        ),
                      ],
                    ),
                    if (detectionClass.enabled) ...[
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Threshold',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          Text(
                            detectionClass.confidenceThreshold.toStringAsFixed(2),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isDark
                                  ? AppColors.primaryLight
                                  : AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: detectionClass.confidenceThreshold,
                        min: 0.0,
                        max: 1.0,
                        divisions: 20,
                        onChanged: (value) => controller.setClassConfidenceThreshold(
                          detectionClass.id,
                          value,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ));
  }

  Widget _buildAppSettings(bool isDark) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          elevation: 0,
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          child: ListTile(
            title: Text(
              'Dark Mode',
              style: AppTextStyles.titleMedium,
            ),
            subtitle: Text(
              'Use dark theme',
              style: AppTextStyles.caption,
            ),
            trailing: Obx(() => Switch(
                  value: controller.isDarkMode.value,
                  onChanged: (_) => controller.toggleDarkMode(),
                )),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          elevation: 0,
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          child: ListTile(
            title: Text(
              'Enable Notifications',
              style: AppTextStyles.titleMedium,
            ),
            subtitle: Text(
              'Show push notifications for incidents',
              style: AppTextStyles.caption,
            ),
            trailing: Obx(() => Switch(
                  value: controller.enableNotifications.value,
                  onChanged: (_) => controller.toggleNotifications(),
                )),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          elevation: 0,
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          child: ListTile(
            title: Text(
              'Sound Alerts',
              style: AppTextStyles.titleMedium,
            ),
            subtitle: Text(
              'Play sound for critical incidents',
              style: AppTextStyles.caption,
            ),
            trailing: Obx(() => Switch(
                  value: controller.enableSoundAlerts.value,
                  onChanged: (_) => controller.toggleSoundAlerts(),
                )),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          elevation: 0,
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Auto-Refresh Interval',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    Obx(() => Text(
                          '${controller.autoRefreshInterval.value}s',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: isDark
                                ? AppColors.primaryLight
                                : AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ],
                ),
                const SizedBox(height: 8),
                Obx(() => Slider(
                      value: controller.autoRefreshInterval.value.toDouble(),
                      min: 10,
                      max: 120,
                      divisions: 22,
                      onChanged: (value) =>
                          controller.setAutoRefreshInterval(value.toInt()),
                    )),
                Text(
                  'How often to refresh data automatically',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
