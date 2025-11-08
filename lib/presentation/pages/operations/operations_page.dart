import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fire_safety_console/app/theme/colors.dart';
import 'package:fire_safety_console/app/theme/text_styles.dart';
import 'package:fire_safety_console/presentation/pages/operations/operations_controller.dart';
import 'package:fire_safety_console/core/constants.dart';

class OperationsPage extends GetView<OperationsController> {
  const OperationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Operations Center'),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        elevation: 0,
        actions: [
          Obx(() => PopupMenuButton<int>(
                icon: const Icon(Icons.grid_view),
                onSelected: controller.setGridColumns,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(
                          Icons.crop_square,
                          color: controller.gridColumns.value == 1
                              ? AppColors.primary
                              : null,
                        ),
                        const SizedBox(width: 8),
                        const Text('1x1'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(
                          Icons.grid_4x4,
                          color: controller.gridColumns.value == 2
                              ? AppColors.primary
                              : null,
                        ),
                        const SizedBox(width: 8),
                        const Text('2x2'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 3,
                    child: Row(
                      children: [
                        Icon(
                          Icons.grid_3x3,
                          color: controller.gridColumns.value == 3
                              ? AppColors.primary
                              : null,
                        ),
                        const SizedBox(width: 8),
                        const Text('3x3'),
                      ],
                    ),
                  ),
                ],
              )),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshCameras,
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
                  'Error loading cameras',
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
                  onPressed: controller.refreshCameras,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Metrics Bar
            _buildMetricsBar(isDark),

            // Camera Grid
            Expanded(
              child: Obx(() {
                final selectedId = controller.selectedCameraId.value;
                if (selectedId != null) {
                  // Show single camera in full screen
                  final camera = controller.cameras.firstWhereOrNull(
                    (c) => c.id == selectedId,
                  );
                  if (camera != null) {
                    return _buildFullScreenCamera(camera, isDark);
                  }
                }

                // Show grid of cameras
                return _buildCameraGrid(isDark);
              }),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildMetricsBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Obx(() => _buildMetricItem(
                'Total Detections',
                controller.totalDetections.value.toString(),
                Icons.center_focus_strong,
                isDark,
              )),
          Obx(() => _buildMetricItem(
                'Active Alerts',
                controller.activeAlerts.value.toString(),
                Icons.notifications_active,
                isDark,
              )),
          Obx(() => _buildMetricItem(
                'Avg FPS',
                controller.averageFps.value.toStringAsFixed(1),
                Icons.speed,
                isDark,
              )),
          Obx(() => _buildMetricItem(
                'Online Cameras',
                controller.cameras
                    .where((c) => c.status == Constants.cameraStatusOnline)
                    .length
                    .toString(),
                Icons.videocam,
                isDark,
              )),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isDark ? AppColors.primaryLight : AppColors.primary,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: AppTextStyles.titleMedium.copyWith(
                color: isDark ? AppColors.darkText : AppColors.lightText,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCameraGrid(bool isDark) {
    return Obx(() {
      if (controller.cameras.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.videocam_off,
                size: 64,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                'No cameras available',
                style: AppTextStyles.titleMedium.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        );
      }

      return GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: controller.gridColumns.value,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 16 / 9,
        ),
        itemCount: controller.cameras.length,
        itemBuilder: (context, index) {
          final camera = controller.cameras[index];
          return _buildCameraFeed(camera, isDark);
        },
      );
    });
  }

  Widget _buildCameraFeed(camera, bool isDark) {
    final isOnline = camera.status == Constants.cameraStatusOnline;

    return GestureDetector(
      onDoubleTap: () => controller.toggleFullScreen(camera.id),
      child: Card(
        elevation: 0,
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Camera feed placeholder
            Container(
              color: Colors.black,
              child: isOnline
                  ? Center(
                      child: Icon(
                        Icons.videocam,
                        size: 48,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.videocam_off,
                            size: 48,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'OFFLINE',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            // Info overlay
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            camera.name,
                            style: AppTextStyles.titleSmall.copyWith(
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            camera.location,
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isOnline ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Action buttons overlay
            Positioned(
              bottom: 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                  Icons.fullscreen,
                  color: Colors.white.withOpacity(0.8),
                ),
                onPressed: () => controller.toggleFullScreen(camera.id),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullScreenCamera(camera, bool isDark) {
    final isOnline = camera.status == Constants.cameraStatusOnline;

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Camera feed
          Center(
            child: isOnline
                ? Icon(
                    Icons.videocam,
                    size: 120,
                    color: Colors.white.withOpacity(0.3),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.videocam_off,
                        size: 120,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Camera Offline',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
          ),

          // Top bar with info
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          camera.name,
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          camera.location,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isOnline
                          ? AppColors.success.withOpacity(0.2)
                          : AppColors.error.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      camera.status,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isOnline ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Exit full screen button
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () => controller.selectCamera(null),
              child: const Icon(Icons.fullscreen_exit),
            ),
          ),
        ],
      ),
    );
  }
}
