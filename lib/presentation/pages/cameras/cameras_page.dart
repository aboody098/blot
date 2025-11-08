import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fire_safety_console/app/theme/colors.dart';
import 'package:fire_safety_console/app/theme/text_styles.dart';
import 'package:fire_safety_console/presentation/pages/cameras/cameras_controller.dart';
import 'package:fire_safety_console/presentation/widgets/camera_tile.dart';

class CamerasPage extends GetView<CamerasController> {
  const CamerasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Cameras'),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshCameras,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCameraDialog(context, isDark),
        child: const Icon(Icons.add),
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
            // Statistics Bar
            _buildStatisticsBar(isDark),

            // Cameras List
            Expanded(
              child: Obx(() {
                if (controller.cameras.isEmpty) {
                  return _buildEmptyState(isDark);
                }

                return RefreshIndicator(
                  onRefresh: controller.refreshCameras,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: controller.cameras.length,
                    itemBuilder: (context, index) {
                      final camera = controller.cameras[index];
                      return CameraTile(
                        camera: camera,
                        onTap: () => _showCameraDetails(camera, isDark),
                        onEdit: () => _showEditCameraDialog(camera, context, isDark),
                        onDelete: () => _showDeleteConfirmation(camera.id),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatisticsBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Obx(() => _buildStatItem(
                'Online',
                controller.onlineCount.toString(),
                AppColors.success,
                isDark,
              )),
          Obx(() => _buildStatItem(
                'Offline',
                controller.offlineCount.toString(),
                AppColors.error,
                isDark,
              )),
          Obx(() => _buildStatItem(
                'Maintenance',
                controller.maintenanceCount.toString(),
                AppColors.warning,
                isDark,
              )),
          Obx(() => _buildStatItem(
                'Total',
                controller.cameras.length.toString(),
                AppColors.primary,
                isDark,
              )),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headlineSmall.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool isDark) {
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
            'No cameras configured',
            style: AppTextStyles.titleLarge.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a camera to get started',
            style: AppTextStyles.bodySmall.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showAddCameraDialog(BuildContext context, bool isDark) {
    final nameController = TextEditingController();
    final locationController = TextEditingController();
    final ipController = TextEditingController();
    final portController = TextEditingController(text: '8080');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        title: Text(
          'Add Camera',
          style: AppTextStyles.headlineMedium,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Camera Name',
                  hintText: 'e.g., Main Entrance',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  hintText: 'e.g., Zone A - Entry',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ipController,
                decoration: const InputDecoration(
                  labelText: 'IP Address',
                  hintText: '192.168.1.100',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: portController,
                decoration: const InputDecoration(
                  labelText: 'Port',
                  hintText: '8080',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          Obx(() => ElevatedButton(
                onPressed: controller.isAddingCamera.value
                    ? null
                    : () {
                        if (nameController.text.isEmpty ||
                            locationController.text.isEmpty ||
                            ipController.text.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Please fill all required fields',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }

                        controller.addCamera(
                          name: nameController.text,
                          location: locationController.text,
                          ipAddress: ipController.text,
                          port: int.tryParse(portController.text) ?? 8080,
                        );
                        Navigator.pop(context);
                      },
                child: controller.isAddingCamera.value
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Add'),
              )),
        ],
      ),
    );
  }

  void _showEditCameraDialog(camera, BuildContext context, bool isDark) {
    final nameController = TextEditingController(text: camera.name);
    final locationController = TextEditingController(text: camera.location);
    final ipController = TextEditingController(text: camera.ipAddress);
    final portController = TextEditingController(text: camera.port.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        title: Text(
          'Edit Camera',
          style: AppTextStyles.headlineMedium,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Camera Name',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ipController,
                decoration: const InputDecoration(
                  labelText: 'IP Address',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: portController,
                decoration: const InputDecoration(
                  labelText: 'Port',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedCamera = camera.copyWith(
                name: nameController.text,
                location: locationController.text,
                ipAddress: ipController.text,
                port: int.tryParse(portController.text) ?? camera.port,
                streamUrl:
                    'rtsp://${ipController.text}:${portController.text}/stream',
              );

              controller.updateCamera(updatedCamera);
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showCameraDetails(camera, bool isDark) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              camera.name,
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: 16),
            _buildDetailItem('Location', camera.location, isDark),
            _buildDetailItem('IP Address', '${camera.ipAddress}:${camera.port}', isDark),
            _buildDetailItem('Stream URL', camera.streamUrl, isDark),
            _buildDetailItem('Status', camera.status, isDark),
            _buildDetailItem(
              'Resolution',
              '${camera.resolutionWidth}x${camera.resolutionHeight}',
              isDark,
            ),
            _buildDetailItem('FPS', '${camera.frameRate}', isDark),
            _buildDetailItem(
              'Recording',
              camera.recordingEnabled ? 'Enabled' : 'Disabled',
              isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
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
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark ? AppColors.darkText : AppColors.lightText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(int cameraId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Camera'),
        content: const Text('Are you sure you want to delete this camera?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteCamera(cameraId);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
