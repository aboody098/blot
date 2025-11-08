import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fire_safety_console/app/theme/colors.dart';
import 'package:fire_safety_console/app/theme/text_styles.dart';
import 'package:fire_safety_console/core/constants.dart';
import 'package:fire_safety_console/presentation/pages/incident_detail/incident_detail_controller.dart';

class IncidentDetailPage extends GetView<IncidentDetailController> {
  const IncidentDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Incident Details'),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshIncident,
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
                  'Error loading incident',
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
                  onPressed: controller.refreshIncident,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final incident = controller.incident.value;
        if (incident == null) return const SizedBox.shrink();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(incident, isDark),

              // Quick Actions
              _buildQuickActions(incident, isDark),

              // Details Section
              _buildDetailsSection(incident, isDark),

              // Evidence Section
              _buildEvidenceSection(incident, isDark),

              // Timeline Section
              _buildTimelineSection(isDark),

              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader(incident, bool isDark) {
    Color getSeverityColor() {
      switch (incident.severity) {
        case Constants.severityCritical:
          return AppColors.criticalRed;
        case Constants.severityMajor:
          return AppColors.majorYellow;
        case Constants.severityMinor:
          return AppColors.minorBlue;
        default:
          return AppColors.minorBlue;
      }
    }

    Color getStatusColor() {
      switch (incident.status) {
        case Constants.statusOpen:
          return AppColors.error;
        case Constants.statusAcknowledged:
          return AppColors.warning;
        case Constants.statusEscalated:
          return AppColors.criticalRed;
        case Constants.statusClosed:
          return AppColors.success;
        default:
          return AppColors.info;
      }
    }

    return Container(
      padding: const EdgeInsets.all(24),
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Severity and Status badges
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: getSeverityColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  incident.severity,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: getSeverityColor(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  incident.status,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: getStatusColor(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            incident.title,
            style: AppTextStyles.headlineLarge.copyWith(
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
          const SizedBox(height: 8),

          // ID
          Text(
            incident.id,
            style: AppTextStyles.bodySmall.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(incident, bool isDark) {
    final canAcknowledge = incident.status == Constants.statusOpen;
    final canEscalate = incident.status != Constants.statusClosed &&
        incident.status != Constants.statusEscalated;
    final canClose = incident.status != Constants.statusClosed;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (canAcknowledge)
            Expanded(
              child: Obx(() => ElevatedButton.icon(
                    onPressed: controller.isAcknowledging.value
                        ? null
                        : controller.acknowledgeIncident,
                    icon: controller.isAcknowledging.value
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check),
                    label: const Text('Acknowledge'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.info,
                    ),
                  )),
            ),
          if (canAcknowledge && (canEscalate || canClose))
            const SizedBox(width: 8),
          if (canEscalate)
            Expanded(
              child: Obx(() => OutlinedButton.icon(
                    onPressed: controller.isEscalating.value
                        ? null
                        : controller.escalateIncident,
                    icon: controller.isEscalating.value
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.arrow_upward),
                    label: const Text('Escalate'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.warning,
                    ),
                  )),
            ),
          if (canEscalate && canClose) const SizedBox(width: 8),
          if (canClose)
            Expanded(
              child: Obx(() => ElevatedButton.icon(
                    onPressed: controller.isClosing.value
                        ? null
                        : controller.closeIncident,
                    icon: controller.isClosing.value
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.close),
                    label: const Text('Close'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                    ),
                  )),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(incident, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 0,
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Details',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                'Description',
                incident.description,
                isDark,
              ),
              const Divider(height: 24),
              _buildDetailRow(
                'Detection Class',
                incident.detectionClass,
                isDark,
              ),
              const Divider(height: 24),
              _buildDetailRow(
                'Confidence',
                '${(incident.confidence * 100).toStringAsFixed(1)}%',
                isDark,
              ),
              const Divider(height: 24),
              _buildDetailRow(
                'Location',
                incident.location ?? 'N/A',
                isDark,
              ),
              const Divider(height: 24),
              _buildDetailRow(
                'Camera ID',
                incident.cameraId.toString(),
                isDark,
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => controller.navigateToCamera(incident.cameraId),
                ),
              ),
              const Divider(height: 24),
              _buildDetailRow(
                'Created At',
                DateFormat('yyyy-MM-dd HH:mm:ss').format(incident.createdAt),
                isDark,
              ),
              if (incident.acknowledgedAt != null) ...[
                const Divider(height: 24),
                _buildDetailRow(
                  'Acknowledged At',
                  DateFormat('yyyy-MM-dd HH:mm:ss')
                      .format(incident.acknowledgedAt!),
                  isDark,
                ),
              ],
              if (incident.closedAt != null) ...[
                const Divider(height: 24),
                _buildDetailRow(
                  'Closed At',
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(incident.closedAt!),
                  isDark,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark, {Widget? trailing}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEvidenceSection(incident, bool isDark) {
    if (incident.evidenceUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Evidence',
            style: AppTextStyles.headlineSmall.copyWith(
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: incident.evidenceUrls.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < incident.evidenceUrls.length - 1 ? 12 : 0,
                  ),
                  child: Container(
                    width: 120,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.image, size: 48),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Timeline',
            style: AppTextStyles.headlineSmall.copyWith(
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.timeline.length,
                itemBuilder: (context, index) {
                  final event = controller.timeline[index];
                  return _buildTimelineItem(event, isDark);
                },
              )),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(Map<String, dynamic> event, bool isDark) {
    IconData getIcon() {
      switch (event['icon'] as String) {
        case 'create':
          return Icons.warning_amber;
        case 'acknowledge':
          return Icons.check_circle;
        case 'close':
          return Icons.cancel;
        default:
          return Icons.circle;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? AppColors.primaryLight.withOpacity(0.2)
                  : AppColors.primary.withOpacity(0.1),
            ),
            child: Icon(
              getIcon(),
              size: 20,
              color: isDark ? AppColors.primaryLight : AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title'] as String,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event['description'] as String,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('yyyy-MM-dd HH:mm:ss')
                      .format(event['timestamp'] as DateTime),
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
