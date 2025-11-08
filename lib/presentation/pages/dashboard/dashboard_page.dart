import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fire_safety_console/app/theme/colors.dart';
import 'package:fire_safety_console/app/theme/text_styles.dart';
import 'package:fire_safety_console/presentation/pages/dashboard/dashboard_controller.dart';
import 'package:fire_safety_console/presentation/widgets/kpi_card.dart';
import 'package:fire_safety_console/presentation/widgets/alert_list_item.dart';
import 'package:fire_safety_console/presentation/widgets/sensor_gauge.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshData,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading dashboard',
                  style: AppTextStyles.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  controller.errorMessage.value,
                  style: AppTextStyles.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: controller.refreshData,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // KPI Section
                _buildKpiSection(),
                const SizedBox(height: 24),

                // Recent Incidents Section
                _buildRecentIncidentsSection(isDark),
                const SizedBox(height: 24),

                // Sensors Section
                _buildSensorsSection(isDark),
                const SizedBox(height: 24),

                // Service Status Section
                _buildServiceStatusSection(isDark),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildKpiSection() {
    return Obx(() {
      final kpi = controller.kpiSnapshot.value;
      if (kpi == null) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Performance Indicators',
            style: AppTextStyles.headlineMedium,
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              KpiCard(
                title: 'Total Incidents',
                value: kpi.totalIncidents.toString(),
                icon: Icons.warning_amber,
                iconColor: AppColors.warning,
                onTap: controller.navigateToIncidents,
              ),
              KpiCard(
                title: 'Critical',
                value: kpi.criticalIncidents.toString(),
                icon: Icons.error,
                iconColor: AppColors.criticalRed,
                onTap: controller.navigateToIncidents,
              ),
              KpiCard(
                title: 'Online Cameras',
                value: kpi.onlineCameras.toString(),
                unit: '/ ${kpi.onlineCameras + kpi.offlineCameras}',
                icon: Icons.videocam,
                iconColor: AppColors.success,
              ),
              KpiCard(
                title: 'Avg. Confidence',
                value: '${(kpi.averageConfidence * 100).toStringAsFixed(0)}',
                unit: '%',
                icon: Icons.analytics,
                iconColor: AppColors.info,
              ),
              KpiCard(
                title: 'Healthy Sensors',
                value: kpi.ppeSensorsHealthy.toString(),
                unit: '/ ${kpi.ppeSensorsHealthy + kpi.ppeSensorsUnhealthy}',
                icon: Icons.sensors,
                iconColor: AppColors.success,
              ),
              KpiCard(
                title: 'System Uptime',
                value: kpi.systemUptime.toStringAsFixed(1),
                unit: '%',
                icon: Icons.schedule,
                iconColor: AppColors.success,
                onTap: controller.navigateToHealth,
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildRecentIncidentsSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Incidents',
              style: AppTextStyles.headlineMedium,
            ),
            TextButton(
              onPressed: controller.navigateToIncidents,
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() {
          if (controller.recentIncidents.isEmpty) {
            return Card(
              elevation: 0,
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 48,
                        color: AppColors.success,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No recent incidents',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.recentIncidents.length,
            itemBuilder: (context, index) {
              final incident = controller.recentIncidents[index];
              return AlertListItem(
                incident: incident,
                onTap: () => controller.navigateToIncident(incident.id),
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildSensorsSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sensor Readings',
          style: AppTextStyles.headlineMedium,
        ),
        const SizedBox(height: 12),
        Obx(() {
          if (controller.sensors.isEmpty) {
            return const SizedBox.shrink();
          }

          return SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.sensors.length,
              itemBuilder: (context, index) {
                final sensor = controller.sensors[index];
                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0 : 8,
                    right: index == controller.sensors.length - 1 ? 0 : 8,
                  ),
                  child: SensorGauge(sensor: sensor),
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildServiceStatusSection(bool isDark) {
    return Obx(() {
      final status = controller.serviceStatus.value;
      if (status == null) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Service Status',
                style: AppTextStyles.headlineMedium,
              ),
              TextButton(
                onPressed: controller.navigateToHealth,
                child: const Text('View Details'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildStatusRow(
                    'CPU Usage',
                    '${status.cpuUsage.toStringAsFixed(1)}%',
                    status.cpuUsage / 100,
                    isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildStatusRow(
                    'Memory Usage',
                    '${status.memoryUsage.toStringAsFixed(1)}%',
                    status.memoryUsage / 100,
                    isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildStatusRow(
                    'GPU Usage',
                    '${status.gpuUsage.toStringAsFixed(1)}%',
                    status.gpuUsage / 100,
                    isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildStatusRow(
                    'Storage',
                    '${status.storageUsage.toStringAsFixed(1)}%',
                    status.storageUsage / 100,
                    isDark,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildStatusRow(String label, String value, double progress, bool isDark) {
    Color getProgressColor() {
      if (progress > 0.8) return AppColors.error;
      if (progress > 0.6) return AppColors.warning;
      return AppColors.success;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark ? AppColors.darkText : AppColors.lightText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: isDark
                ? AppColors.darkBackground
                : AppColors.lightBackground,
            valueColor: AlwaysStoppedAnimation<Color>(getProgressColor()),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
