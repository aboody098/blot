import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fire_safety_console/app/theme/colors.dart';
import 'package:fire_safety_console/app/theme/text_styles.dart';
import 'package:fire_safety_console/presentation/pages/training/training_controller.dart';

class TrainingPage extends GetView<TrainingController> {
  const TrainingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Training'),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshTrainingRuns,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showStartTrainingDialog(context, isDark),
        icon: const Icon(Icons.add),
        label: const Text('Start Training'),
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
                  'Error loading training runs',
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
                  onPressed: controller.refreshTrainingRuns,
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

            // Training Runs List
            Expanded(
              child: Obx(() {
                if (controller.trainingRuns.isEmpty) {
                  return _buildEmptyState(isDark);
                }

                return RefreshIndicator(
                  onRefresh: controller.refreshTrainingRuns,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: controller.trainingRuns.length,
                    itemBuilder: (context, index) {
                      final training = controller.trainingRuns[index];
                      return _buildTrainingRunCard(training, isDark);
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
                'Running',
                controller.runningCount.toString(),
                AppColors.info,
                isDark,
              )),
          Obx(() => _buildStatItem(
                'Queued',
                controller.queuedCount.toString(),
                AppColors.warning,
                isDark,
              )),
          Obx(() => _buildStatItem(
                'Completed',
                controller.completedCount.toString(),
                AppColors.success,
                isDark,
              )),
          Obx(() => _buildStatItem(
                'Total',
                controller.trainingRuns.length.toString(),
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

  Widget _buildTrainingRunCard(training, bool isDark) {
    Color getStatusColor() {
      switch (training.status) {
        case 'RUNNING':
          return AppColors.info;
        case 'COMPLETED':
          return AppColors.success;
        case 'FAILED':
          return AppColors.error;
        case 'QUEUED':
          return AppColors.warning;
        default:
          return AppColors.disabled;
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
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
                        training.name,
                        style: AppTextStyles.titleLarge.copyWith(
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        training.id,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    training.status,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: getStatusColor(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Progress bar
            if (training.status == 'RUNNING' || training.status == 'COMPLETED')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Epoch ${training.epoch} / ${training.totalEpochs}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                      Text(
                        '${(training.progress * 100).toStringAsFixed(0)}%',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: training.progress,
                      backgroundColor: isDark
                          ? AppColors.darkBackground
                          : AppColors.lightBackground,
                      valueColor: AlwaysStoppedAnimation<Color>(getStatusColor()),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),

            // Metrics
            if (training.status == 'RUNNING' || training.status == 'COMPLETED')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetric(
                    'Accuracy',
                    '${(training.accuracy * 100).toStringAsFixed(1)}%',
                    isDark,
                  ),
                  _buildMetric(
                    'mAP',
                    '${(training.mAP * 100).toStringAsFixed(1)}%',
                    isDark,
                  ),
                  _buildMetric(
                    'Loss',
                    training.trainingLoss.toStringAsFixed(3),
                    isDark,
                  ),
                ],
              ),

            const SizedBox(height: 12),

            // Metadata
            Row(
              children: [
                Icon(
                  Icons.model_training,
                  size: 16,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  training.model ?? 'N/A',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormat('HH:mm').format(training.startedAt),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),

            // Actions
            if (training.status == 'RUNNING' || training.status == 'QUEUED')
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => controller.stopTraining(training.id),
                      child: const Text('Stop'),
                    ),
                  ],
                ),
              ),
            if (training.status == 'COMPLETED' || training.status == 'FAILED')
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => _showDeleteConfirmation(training.id),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value, bool isDark) {
    return Column(
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
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.model_training,
            size: 64,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No training runs yet',
            style: AppTextStyles.titleLarge.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a new training run to get started',
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

  void _showStartTrainingDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        title: Text(
          'Start New Training',
          style: AppTextStyles.headlineMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Training Name',
                hintText: 'e.g., Fire Detection v2',
              ),
              onChanged: (value) => controller.newTrainingName.value = value,
            ),
            const SizedBox(height: 16),
            Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedModel.value,
                  decoration: const InputDecoration(
                    labelText: 'Model',
                  ),
                  items: controller.availableModels
                      .map((model) => DropdownMenuItem(
                            value: model,
                            child: Text(model),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedModel.value = value;
                    }
                  },
                )),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Total Epochs',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                controller.totalEpochs.value = int.tryParse(value) ?? 100;
              },
              controller: TextEditingController(
                text: controller.totalEpochs.value.toString(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          Obx(() => ElevatedButton(
                onPressed: controller.isStartingTraining.value
                    ? null
                    : () {
                        controller.startNewTraining();
                        Navigator.pop(context);
                      },
                child: controller.isStartingTraining.value
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Start'),
              )),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(String trainingId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Training'),
        content: const Text('Are you sure you want to delete this training run?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteTraining(trainingId);
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
