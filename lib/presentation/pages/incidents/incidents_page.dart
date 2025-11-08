import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fire_safety_console/app/theme/colors.dart';
import 'package:fire_safety_console/app/theme/text_styles.dart';
import 'package:fire_safety_console/presentation/pages/incidents/incidents_controller.dart';
import 'package:fire_safety_console/presentation/widgets/alert_list_item.dart';

class IncidentsPage extends GetView<IncidentsController> {
  const IncidentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Incidents'),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context, isDark),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshIncidents,
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
                  'Error loading incidents',
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
                  onPressed: controller.refreshIncidents,
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

            // Search Bar
            _buildSearchBar(isDark),

            // Active Filters
            _buildActiveFilters(isDark),

            // Incidents List
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshIncidents,
                child: Obx(() {
                  if (controller.filteredIncidents.isEmpty) {
                    return _buildEmptyState(isDark);
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: controller.filteredIncidents.length,
                    itemBuilder: (context, index) {
                      final incident = controller.filteredIncidents[index];
                      return AlertListItem(
                        incident: incident,
                        onTap: () => controller.navigateToIncident(incident.id),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatisticsBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Obx(() => _buildStatItem(
                'Critical',
                controller.criticalCount.toString(),
                AppColors.criticalRed,
                isDark,
              )),
          Obx(() => _buildStatItem(
                'Major',
                controller.majorCount.toString(),
                AppColors.majorYellow,
                isDark,
              )),
          Obx(() => _buildStatItem(
                'Minor',
                controller.minorCount.toString(),
                AppColors.minorBlue,
                isDark,
              )),
          Obx(() => _buildStatItem(
                'Open',
                controller.openCount.toString(),
                AppColors.warning,
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

  Widget _buildSearchBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: controller.setSearchQuery,
        decoration: InputDecoration(
          hintText: 'Search incidents...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Obx(() {
            if (controller.searchQuery.value.isEmpty) {
              return const SizedBox.shrink();
            }
            return IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => controller.setSearchQuery(''),
            );
          }),
          filled: true,
          fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildActiveFilters(bool isDark) {
    return Obx(() {
      final hasFilters = controller.selectedSeverity.value != null ||
          controller.selectedStatus.value != null;

      if (!hasFilters) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Text(
              'Filters:',
              style: AppTextStyles.bodySmall.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Wrap(
                spacing: 8,
                children: [
                  if (controller.selectedSeverity.value != null)
                    Chip(
                      label: Text(controller.selectedSeverity.value!),
                      onDeleted: () => controller.setSeverityFilter(null),
                      deleteIconColor: AppColors.error,
                    ),
                  if (controller.selectedStatus.value != null)
                    Chip(
                      label: Text(controller.selectedStatus.value!),
                      onDeleted: () => controller.setStatusFilter(null),
                      deleteIconColor: AppColors.error,
                    ),
                ],
              ),
            ),
            TextButton(
              onPressed: controller.clearFilters,
              child: const Text('Clear All'),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 64,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No incidents found',
            style: AppTextStyles.titleLarge.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'All clear! No incidents match your filters.',
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

  void _showFilterBottomSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Incidents',
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: 24),

            // Severity filter
            Text(
              'Severity',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 12),
            Obx(() => Wrap(
                  spacing: 8,
                  children: [
                    for (final severity in controller.severities)
                      ChoiceChip(
                        label: Text(severity),
                        selected:
                            controller.selectedSeverity.value == severity,
                        onSelected: (selected) {
                          controller.setSeverityFilter(
                            selected ? severity : null,
                          );
                        },
                      ),
                  ],
                )),
            const SizedBox(height: 24),

            // Status filter
            Text(
              'Status',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 12),
            Obx(() => Wrap(
                  spacing: 8,
                  children: [
                    for (final status in controller.statuses)
                      ChoiceChip(
                        label: Text(status),
                        selected: controller.selectedStatus.value == status,
                        onSelected: (selected) {
                          controller.setStatusFilter(
                            selected ? status : null,
                          );
                        },
                      ),
                  ],
                )),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      controller.clearFilters();
                      Navigator.pop(context);
                    },
                    child: const Text('Clear Filters'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
