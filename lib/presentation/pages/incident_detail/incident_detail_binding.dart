import 'package:get/get.dart';
import 'package:fire_safety_console/presentation/pages/incident_detail/incident_detail_controller.dart';

class IncidentDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IncidentDetailController>(() => IncidentDetailController());
  }
}
