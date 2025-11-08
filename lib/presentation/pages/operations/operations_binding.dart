import 'package:get/get.dart';
import 'package:fire_safety_console/presentation/pages/operations/operations_controller.dart';

class OperationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OperationsController>(() => OperationsController());
  }
}
