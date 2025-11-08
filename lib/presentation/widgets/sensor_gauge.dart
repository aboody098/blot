import 'package:flutter/material.dart';
import 'package:fire_safety_console/app/theme/colors.dart';
import 'package:fire_safety_console/app/theme/text_styles.dart';
import 'package:fire_safety_console/data/models/sensor.dart';

class SensorGauge extends StatelessWidget {
  final Sensor sensor;
  final double size;

  const SensorGauge({
    Key? key,
    required this.sensor,
    this.size = 120,
  }) : super(key: key);

  Color _getStatusColor() {
    if (!sensor.isHealthy) return AppColors.error;
    final ratio = (sensor.currentValue - sensor.minValue) /
        (sensor.maxValue - sensor.minValue);
    if (ratio > 0.8) return AppColors.error;
    if (ratio > 0.6) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ratio = (sensor.currentValue - sensor.minValue) /
        (sensor.maxValue - sensor.minValue)
        .clamp(0.0, 1.0);

    return Column(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? AppColors.darkSurface
                      : AppColors.lightBackground,
                  border: Border.all(
                    color: isDark
                        ? AppColors.border.withOpacity(0.2)
                        : AppColors.border,
                  ),
                ),
              ),
              // Progress ring
              CustomPaint(
                size: Size(size, size),
                painter: GaugePainter(
                  progress: ratio,
                  color: _getStatusColor(),
                  backgroundColor: isDark
                      ? AppColors.border.withOpacity(0.1)
                      : AppColors.divider,
                ),
              ),
              // Center content
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    sensor.currentValue.toStringAsFixed(1),
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: isDark
                          ? AppColors.darkText
                          : AppColors.lightText,
                    ),
                  ),
                  Text(
                    sensor.unit,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          sensor.name,
          style: AppTextStyles.bodySmall.copyWith(
            color:
                isDark ? AppColors.darkText : AppColors.lightText,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class GaugePainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  GaugePainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 4;

    // Background arc
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(
      rect,
      -3.14159 / 2,
      (2 * 3.14159 * progress),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(GaugePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
