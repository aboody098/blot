import 'package:get/get.dart';
import 'package:fire_safety_console/presentation/pages/settings/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
