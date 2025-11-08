import 'package:get/get.dart';
import 'package:fire_safety_console/presentation/pages/health/health_controller.dart';

class HealthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HealthController>(() => HealthController());
  }
}
