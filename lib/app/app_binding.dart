import 'package:get/get.dart';

import '../data/repositories/analytics_repository.dart';
import '../data/repositories/camera_repository.dart';
import '../data/repositories/incident_repository.dart';
import '../data/repositories/sensor_repository.dart';
import '../data/repositories/training_repository.dart';
import '../data/services/api_client.dart';
import '../data/services/websocket_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.put<ApiClient>(ApiClient(), permanent: true);
    Get.put<WebSocketService>(WebSocketService(), permanent: true);

    // Repositories
    Get.put<IncidentRepository>(IncidentRepository(), permanent: true);
    Get.put<CameraRepository>(CameraRepository(), permanent: true);
    Get.put<SensorRepository>(SensorRepository(), permanent: true);
    Get.put<AnalyticsRepository>(AnalyticsRepository(), permanent: true);
    Get.put<TrainingRepository>(TrainingRepository(), permanent: true);
  }
}
