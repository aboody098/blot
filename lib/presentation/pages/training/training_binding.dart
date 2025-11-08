import 'package:get/get.dart';
import 'package:fire_safety_console/presentation/pages/training/training_controller.dart';

class TrainingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrainingController>(() => TrainingController());
  }
}
