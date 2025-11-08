import 'package:flutter/material.dart';
import 'package:fire_safety_console/app/theme/colors.dart';
import 'package:fire_safety_console/app/theme/text_styles.dart';
import 'package:fire_safety_console/core/constants.dart';
import 'package:fire_safety_console/data/models/camera.dart';

class CameraTile extends StatelessWidget {
  final Camera camera;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CameraTile({
    Key? key,
    required this.camera,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (camera.status) {
      case Constants.cameraStatusOnline:
        return AppColors.statusOnline;
      case Constants.cameraStatusOffline:
        return AppColors.statusOffline;
      case Constants.cameraStatusMaintenance:
        return AppColors.statusMaintenance;
      default:
        return AppColors.statusOffline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          camera.name,
                          style: AppTextStyles.titleLarge.copyWith(
                            color: isDark
                                ? AppColors.darkText
                                : AppColors.lightText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          camera.location,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getStatusColor(),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          camera.status,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: _getStatusColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'IP: ${camera.ipAddress}:${camera.port}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                  if (onEdit != null)
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 16,
                          color: isDark
                              ? AppColors.primaryLight
                              : AppColors.primary,
                        ),
                        onPressed: onEdit,
                      ),
                    ),
                  if (onDelete != null)
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          size: 16,
                          color: AppColors.error,
                        ),
                        onPressed: onDelete,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
