import 'package:get/get.dart';
import 'package:fire_safety_console/presentation/pages/incidents/incidents_controller.dart';

class IncidentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IncidentsController>(() => IncidentsController());
  }
}
