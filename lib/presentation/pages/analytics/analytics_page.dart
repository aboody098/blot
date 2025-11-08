import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fire_safety_console/app/theme/colors.dart';
import 'package:fire_safety_console/app/theme/text_styles.dart';
import 'package:fire_safety_console/presentation/pages/analytics/analytics_controller.dart';
import 'package:fire_safety_console/presentation/widgets/kpi_card.dart';

class AnalyticsPage extends GetView<AnalyticsController> {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        elevation: 0,
        actions: [
          Obx(() => PopupMenuButton<String>(
                icon: const Icon(Icons.date_range),
                onSelected: controller.setTimeRange,
                itemBuilder: (context) => controller.timeRanges
                    .map((range) => PopupMenuItem(
                          value: range,
                          child: Row(
                            children: [
                              if (controller.selectedTimeRange.value == range)
                                const Icon(Icons.check, size: 20),
                              if (controller.selectedTimeRange.value == range)
                                const SizedBox(width: 8),
                              Text(range),
                            ],
                          ),
                        ))
                    .toList(),
              )),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshAnalytics,
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
                  'Error loading analytics',
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
                  onPressed: controller.refreshAnalytics,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshAnalytics,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary KPIs
                _buildSummaryKpis(isDark),
                const SizedBox(height: 24),

                // Alert Trends Chart
                _buildAlertTrendsSection(isDark),
                const SizedBox(height: 24),

                // PPE Compliance Chart
                _buildPpeComplianceSection(isDark),
                const SizedBox(height: 24),

                // Camera Uptime Chart
                _buildCameraUptimeSection(isDark),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSummaryKpis(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Overview',
              style: AppTextStyles.headlineMedium,
            ),
            Obx(() => Text(
                  controller.selectedTimeRange.value,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                )),
          ],
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
            Obx(() => KpiCard(
                  title: 'Total Alerts',
                  value: controller.totalAlerts.toString(),
                  icon: Icons.notifications,
                  iconColor: AppColors.warning,
                )),
            Obx(() => KpiCard(
                  title: 'Critical Alerts',
                  value: controller.criticalAlerts.toString(),
                  icon: Icons.error,
                  iconColor: AppColors.criticalRed,
                )),
            Obx(() => KpiCard(
                  title: 'Avg Compliance',
                  value: controller.averageCompliance.toStringAsFixed(0),
                  unit: '%',
                  icon: Icons.verified_user,
                  iconColor: AppColors.success,
                )),
            Obx(() => KpiCard(
                  title: 'Avg Uptime',
                  value: controller.averageUptime.toStringAsFixed(1),
                  unit: '%',
                  icon: Icons.schedule,
                  iconColor: AppColors.info,
                )),
          ],
        ),
      ],
    );
  }

  Widget _buildAlertTrendsSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alert Trends',
          style: AppTextStyles.headlineMedium,
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(() {
              if (controller.alertTrends.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('No data available'),
                  ),
                );
              }

              return Column(
                children: [
                  // Simple bar chart representation
                  SizedBox(
                    height: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: controller.alertTrends.map((trend) {
                        final critical = (trend['critical'] as int? ?? 0);
                        final major = (trend['major'] as int? ?? 0);
                        final minor = (trend['minor'] as int? ?? 0);
                        final total = critical + major + minor;
                        final maxHeight = 160.0;

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Stacked bars
                                if (total > 0)
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (critical > 0)
                                        Container(
                                          height: (critical / total * maxHeight)
                                              .clamp(4, maxHeight),
                                          decoration: BoxDecoration(
                                            color: AppColors.criticalRed,
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(4),
                                              topRight: Radius.circular(4),
                                            ),
                                          ),
                                        ),
                                      if (major > 0)
                                        Container(
                                          height: (major / total * maxHeight)
                                              .clamp(4, maxHeight),
                                          color: AppColors.majorYellow,
                                        ),
                                      if (minor > 0)
                                        Container(
                                          height: (minor / total * maxHeight)
                                              .clamp(4, maxHeight),
                                          decoration: BoxDecoration(
                                            color: AppColors.minorBlue,
                                            borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(4),
                                              bottomRight: Radius.circular(4),
                                            ),
                                          ),
                                        ),
                                    ],
                                  )
                                else
                                  Container(
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.darkBackground
                                          : AppColors.lightBackground,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                Text(
                                  trend['date'] as String,
                                  style: AppTextStyles.caption.copyWith(
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem('Critical', AppColors.criticalRed),
                      const SizedBox(width: 12),
                      _buildLegendItem('Major', AppColors.majorYellow),
                      const SizedBox(width: 12),
                      _buildLegendItem('Minor', AppColors.minorBlue),
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildPpeComplianceSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PPE Compliance by Location',
          style: AppTextStyles.headlineMedium,
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(() {
              if (controller.ppeCompliance.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('No data available'),
                  ),
                );
              }

              return Column(
                children: controller.ppeCompliance.map((item) {
                  final location = item['location'] as String;
                  final compliance = (item['compliance'] as int).toDouble() / 100;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              location,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: isDark
                                    ? AppColors.darkText
                                    : AppColors.lightText,
                              ),
                            ),
                            Text(
                              '${(compliance * 100).toStringAsFixed(0)}%',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: isDark
                                    ? AppColors.darkText
                                    : AppColors.lightText,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: compliance,
                            backgroundColor: isDark
                                ? AppColors.darkBackground
                                : AppColors.lightBackground,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              compliance >= 0.9
                                  ? AppColors.success
                                  : compliance >= 0.7
                                      ? AppColors.warning
                                      : AppColors.error,
                            ),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildCameraUptimeSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Camera Uptime',
          style: AppTextStyles.headlineMedium,
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(() {
              if (controller.cameraUptime.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('No data available'),
                  ),
                );
              }

              return Column(
                children: controller.cameraUptime.map((item) {
                  final camera = item['camera'] as String;
                  final uptime = (item['uptime'] as num).toDouble() / 100;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              camera,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: isDark
                                    ? AppColors.darkText
                                    : AppColors.lightText,
                              ),
                            ),
                            Text(
                              '${(uptime * 100).toStringAsFixed(1)}%',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: isDark
                                    ? AppColors.darkText
                                    : AppColors.lightText,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: uptime,
                            backgroundColor: isDark
                                ? AppColors.darkBackground
                                : AppColors.lightBackground,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              uptime >= 0.95
                                  ? AppColors.success
                                  : uptime >= 0.9
                                      ? AppColors.warning
                                      : AppColors.error,
                            ),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
