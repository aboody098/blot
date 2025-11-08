import 'package:get/get.dart';
import 'package:fire_safety_console/core/constants.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutController extends GetxController {
  // Observable state
  final isLoading = true.obs;

  // App info
  final appName = Constants.appName.obs;
  final appVersion = Constants.appVersion.obs;
  final buildNumber = ''.obs;
  final packageName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    try {
      isLoading.value = true;

      // Load package info
      try {
        final packageInfo = await PackageInfo.fromPlatform();
        appName.value = packageInfo.appName;
        appVersion.value = packageInfo.version;
        buildNumber.value = packageInfo.buildNumber;
        packageName.value = packageInfo.packageName;
      } catch (e) {
        // If package_info_plus fails, use constants
        print('Could not load package info: $e');
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print('Error loading app info: $e');
    }
  }

  void openGithub() {
    // In production, would open URL
    Get.snackbar(
      'Info',
      'Opening GitHub repository...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openDocumentation() {
    // In production, would open URL
    Get.snackbar(
      'Info',
      'Opening documentation...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openLicense() {
    // In production, would show license dialog
    Get.dialog(
      GetBuilder<AboutController>(
        builder: (_) => AlertDialog(
          title: const Text('License'),
          content: const SingleChildScrollView(
            child: Text(
              'MIT License\n\n'
              'Copyright (c) 2024 Fire Safety Systems\n\n'
              'Permission is hereby granted, free of charge, to any person obtaining a copy '
              'of this software and associated documentation files (the "Software"), to deal '
              'in the Software without restriction, including without limitation the rights '
              'to use, copy, modify, merge, publish, distribute, sublicense, and/or sell '
              'copies of the Software, and to permit persons to whom the Software is '
              'furnished to do so, subject to the following conditions:\n\n'
              'The above copyright notice and this permission notice shall be included in all '
              'copies or substantial portions of the Software.\n\n'
              'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR '
              'IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, '
              'FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE '
              'AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER '
              'LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, '
              'OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE '
              'SOFTWARE.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void contactSupport() {
    // In production, would open email or support form
    Get.snackbar(
      'Info',
      'Opening support contact...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
