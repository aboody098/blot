import 'package:get/get.dart';
import 'package:fire_safety_console/presentation/pages/analytics/analytics_controller.dart';

class AnalyticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnalyticsController>(() => AnalyticsController());
  }
}
