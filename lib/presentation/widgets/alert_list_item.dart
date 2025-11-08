import 'package:flutter/material.dart';
import 'package:fire_safety_console/app/theme/colors.dart';
import 'package:fire_safety_console/app/theme/text_styles.dart';
import 'package:fire_safety_console/core/constants.dart';
import 'package:fire_safety_console/data/models/incident.dart';
import 'package:intl/intl.dart';

class AlertListItem extends StatelessWidget {
  final Incident incident;
  final VoidCallback? onTap;

  const AlertListItem({
    Key? key,
    required this.incident,
    this.onTap,
  }) : super(key: key);

  Color _getSeverityColor() {
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timeago =
        DateFormat('HH:mm').format(incident.createdAt);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 4,
                height: 80,
                decoration: BoxDecoration(
                  color: _getSeverityColor(),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            incident.title,
                            style: AppTextStyles.titleLarge.copyWith(
                              color: isDark
                                  ? AppColors.darkText
                                  : AppColors.lightText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getSeverityColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            incident.severity,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: _getSeverityColor(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      incident.description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkBackground
                                : AppColors.lightBackground,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            incident.detectionClass,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          timeago,
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Conf: ${(incident.confidence * 100).toStringAsFixed(0)}%',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
