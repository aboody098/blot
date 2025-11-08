import 'package:get/get.dart';
import 'package:fire_safety_console/presentation/pages/cameras/cameras_controller.dart';

class CamerasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CamerasController>(() => CamerasController());
  }
}
