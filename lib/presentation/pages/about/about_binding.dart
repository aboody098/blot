import 'package:get/get.dart';
import 'package:fire_safety_console/presentation/pages/about/about_controller.dart';

class AboutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutController>(() => AboutController());
  }
}
