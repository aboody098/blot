import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fire_safety_console/app/theme/colors.dart';
import 'package:fire_safety_console/app/theme/text_styles.dart';
import 'package:fire_safety_console/core/constants.dart';
import 'package:fire_safety_console/presentation/pages/about/about_controller.dart';

class AboutPage extends GetView<AboutController> {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 48),

              // App Icon/Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? AppColors.primaryLight : AppColors.primary,
                ),
                child: const Icon(
                  Icons.local_fire_department,
                  size: 64,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 24),

              // App Name
              Obx(() => Text(
                    controller.appName.value,
                    style: AppTextStyles.headlineLarge.copyWith(
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                    textAlign: TextAlign.center,
                  )),

              const SizedBox(height: 8),

              // Version
              Obx(() => Text(
                    'Version ${controller.appVersion.value}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  )),

              if (controller.buildNumber.value.isNotEmpty) ...[
                const SizedBox(height: 4),
                Obx(() => Text(
                      'Build ${controller.buildNumber.value}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    )),
              ],

              const SizedBox(height: 8),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'AI-powered fire safety monitoring and incident management system',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 32),

              // Info Section
              _buildInfoSection(isDark),

              const SizedBox(height: 24),

              // Links Section
              _buildLinksSection(isDark),

              const SizedBox(height: 24),

              // Footer
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '© 2024 ${Constants.appAuthor}. All rights reserved.',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 0,
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.info_outline,
                color: isDark ? AppColors.primaryLight : AppColors.primary,
              ),
              title: Text(
                'About',
                style: AppTextStyles.titleMedium,
              ),
              subtitle: Text(
                'Real-time fire safety monitoring with YOLO-based detection',
                style: AppTextStyles.bodySmall,
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(
                Icons.security,
                color: isDark ? AppColors.primaryLight : AppColors.primary,
              ),
              title: Text(
                'Security',
                style: AppTextStyles.titleMedium,
              ),
              subtitle: Text(
                'Enterprise-grade security with end-to-end encryption',
                style: AppTextStyles.bodySmall,
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(
                Icons.speed,
                color: isDark ? AppColors.primaryLight : AppColors.primary,
              ),
              title: Text(
                'Performance',
                style: AppTextStyles.titleMedium,
              ),
              subtitle: Text(
                'Real-time detection with sub-second response times',
                style: AppTextStyles.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinksSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 0,
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.code,
                color: isDark ? AppColors.primaryLight : AppColors.primary,
              ),
              title: Text(
                'GitHub Repository',
                style: AppTextStyles.titleMedium,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: controller.openGithub,
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(
                Icons.menu_book,
                color: isDark ? AppColors.primaryLight : AppColors.primary,
              ),
              title: Text(
                'Documentation',
                style: AppTextStyles.titleMedium,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: controller.openDocumentation,
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(
                Icons.description,
                color: isDark ? AppColors.primaryLight : AppColors.primary,
              ),
              title: Text(
                'License',
                style: AppTextStyles.titleMedium,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: controller.openLicense,
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(
                Icons.support_agent,
                color: isDark ? AppColors.primaryLight : AppColors.primary,
              ),
              title: Text(
                'Contact Support',
                style: AppTextStyles.titleMedium,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: controller.contactSupport,
            ),
          ],
        ),
      ),
    );
  }
}
