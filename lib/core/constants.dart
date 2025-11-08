class Constants {
  // App info
  static const String appName = 'Fire Safety Console';
  static const String appVersion = '1.0.0';
  static const String appAuthor = 'Fire Safety Systems';

  // Severity levels
  static const String severityCritical = 'CRITICAL';
  static const String severityMajor = 'MAJOR';
  static const String severityMinor = 'MINOR';

  // Incident status
  static const String statusOpen = 'OPEN';
  static const String statusAcknowledged = 'ACKNOWLEDGED';
  static const String statusClosed = 'CLOSED';
  static const String statusEscalated = 'ESCALATED';

  // Detection classes
  static const List<String> detectionClasses = [
    'Fire',
    'Smoke',
    'Gas Leak',
    'PPE Violation',
    'Unauthorized Access',
  ];

  // Camera status
  static const String cameraStatusOnline = 'ONLINE';
  static const String cameraStatusOffline = 'OFFLINE';
  static const String cameraStatusMaintenance = 'MAINTENANCE';

  // Service status
  static const String serviceStatusHealthy = 'HEALTHY';
  static const String serviceStatusDegraded = 'DEGRADED';
  static const String serviceStatusCritical = 'CRITICAL';

  // WebSocket message types
  static const String wsTypeIncidentCreated = 'IncidentCreated';
  static const String wsTypeIncidentUpdated = 'IncidentUpdated';
  static const String wsTypeSensorTick = 'SensorTick';
  static const String wsTypeServiceHealthTick = 'ServiceHealthTick';
  static const String wsTypeTrainingProgress = 'TrainingProgress';

  // Storage keys
  static const String storageKeyTheme = 'theme_mode';
  static const String storageKeyLanguage = 'language';
  static const String storageKeyApiToken = 'api_token';

  // Durations
  static const Duration wsHeartbeatInterval = Duration(seconds: 30);
  static const Duration wsReconnectInterval = Duration(seconds: 5);
  static const Duration apiTimeout = Duration(seconds: 30);

  // Thresholds
  static const double yoloConfidenceThreshold = 0.5;
  static const int maxRetries = 3;
}
