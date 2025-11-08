import 'package:get/get.dart';

import '../data/repositories/analytics_repository.dart';
import '../data/repositories/camera_repository.dart';
import '../data/repositories/incident_repository.dart';
import '../data/repositories/sensor_repository.dart';
import '../data/repositories/training_repository.dart';
import '../data/services/api_client.dart';
import '../data/services/websocket_service.dart';
import '../data/services/firebase_service.dart';
import '../data/services/notification_service.dart';
import '../data/local/local_cache.dart';
import '../data/local/offline_sync.dart';
import '../data/local/state_persistence.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // API and WebSocket Services
    Get.put<ApiClient>(ApiClient(), permanent: true);
    Get.put<WebSocketService>(WebSocketService(), permanent: true);

    // Firebase Service
    Get.put<FirebaseService>(FirebaseService(), permanent: true);

    // Local Services
    Get.put<LocalCache>(LocalCache(), permanent: true);
    Get.put<NotificationService>(NotificationService(), permanent: true);
    Get.put<OfflineSync>(OfflineSync(), permanent: true);

    // State Persistence
    Get.put<StatePersistence>(StatePersistence(), permanent: true);

    // Repositories
    Get.put<IncidentRepository>(IncidentRepository(), permanent: true);
    Get.put<CameraRepository>(CameraRepository(), permanent: true);
    Get.put<SensorRepository>(SensorRepository(), permanent: true);
    Get.put<AnalyticsRepository>(AnalyticsRepository(), permanent: true);
    Get.put<TrainingRepository>(TrainingRepository(), permanent: true);
  }
}
