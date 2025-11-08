import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fire_safety_console/app/theme/colors.dart';
import 'package:fire_safety_console/app/theme/text_styles.dart';
import 'package:fire_safety_console/presentation/pages/health/health_controller.dart';

class HealthPage extends GetView<HealthController> {
  const HealthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('System Health'),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshHealth,
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
                  'Error loading system health',
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
                  onPressed: controller.refreshHealth,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final status = controller.serviceStatus.value;
        if (status == null) return const SizedBox.shrink();

        return RefreshIndicator(
          onRefresh: controller.refreshHealth,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Header
                _buildStatusHeader(status, isDark),
                const SizedBox(height: 24),

                // Resource Usage
                _buildResourceUsageSection(status, isDark),
                const SizedBox(height: 24),

                // Disk Space
                if (status.diskSpace != null) ...[
                  _buildDiskSpaceSection(status, isDark),
                  const SizedBox(height: 24),
                ],

                // System Logs
                _buildLogsSection(isDark),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatusHeader(status, bool isDark) {
    Color getStatusColor() {
      switch (status.status) {
        case 'HEALTHY':
          return AppColors.success;
        case 'DEGRADED':
          return AppColors.warning;
        case 'CRITICAL':
          return AppColors.error;
        default:
          return AppColors.disabled;
      }
    }

    IconData getStatusIcon() {
      switch (status.status) {
        case 'HEALTHY':
          return Icons.check_circle;
        case 'DEGRADED':
          return Icons.warning;
        case 'CRITICAL':
          return Icons.error;
        default:
          return Icons.help;
      }
    }

    return Card(
      elevation: 0,
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              getStatusIcon(),
              size: 64,
              color: getStatusColor(),
            ),
            const SizedBox(height: 16),
            Text(
              status.status,
              style: AppTextStyles.headlineLarge.copyWith(
                color: getStatusColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'System Uptime: ${status.uptime}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Active Connections: ${status.activeConnections}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceUsageSection(status, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resource Usage',
          style: AppTextStyles.headlineMedium,
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildResourceItem(
                  'CPU Usage',
                  '${status.cpuUsage.toStringAsFixed(1)}%',
                  status.cpuUsage / 100,
                  isDark,
                ),
                const SizedBox(height: 16),
                _buildResourceItem(
                  'Memory Usage',
                  '${status.memoryUsage.toStringAsFixed(1)}%',
                  status.memoryUsage / 100,
                  isDark,
                ),
                const SizedBox(height: 16),
                _buildResourceItem(
                  'GPU Usage',
                  '${status.gpuUsage.toStringAsFixed(1)}%',
                  status.gpuUsage / 100,
                  isDark,
                ),
                const SizedBox(height: 16),
                _buildResourceItem(
                  'Storage Usage',
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
  }

  Widget _buildResourceItem(String label, String value, double progress, bool isDark) {
    Color getProgressColor() {
      if (progress > 0.9) return AppColors.error;
      if (progress > 0.7) return AppColors.warning;
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
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: isDark
                ? AppColors.darkBackground
                : AppColors.lightBackground,
            valueColor: AlwaysStoppedAnimation<Color>(getProgressColor()),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildDiskSpaceSection(status, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Disk Space',
          style: AppTextStyles.headlineMedium,
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: status.diskSpace!.entries.map<Widget>((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                      Text(
                        entry.value,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogsSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'System Logs',
          style: AppTextStyles.headlineMedium,
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(() {
              if (controller.logs.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('No logs available'),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: controller.logs.map((log) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            log,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontFamily: 'monospace',
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
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
}
