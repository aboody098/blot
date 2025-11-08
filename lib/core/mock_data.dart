import 'package:fire_safety_console/core/constants.dart';
import 'package:fire_safety_console/data/models/camera.dart';
import 'package:fire_safety_console/data/models/incident.dart';
import 'package:fire_safety_console/data/models/kpi_snapshot.dart';
import 'package:fire_safety_console/data/models/sensor.dart';
import 'package:fire_safety_console/data/models/training_run.dart';
import 'package:fire_safety_console/data/models/service_status.dart';

class MockData {
  static KpiSnapshot getKpiSnapshot() {
    return KpiSnapshot(
      totalIncidents: 47,
      criticalIncidents: 2,
      majorIncidents: 8,
      minorIncidents: 37,
      onlineCameras: 24,
      offlineCameras: 2,
      averageConfidence: 0.94,
      ppeSensorsHealthy: 156,
      ppeSensorsUnhealthy: 4,
      timestamp: DateTime.now(),
      systemUptime: 99.8,
    );
  }

  static List<Incident> getIncidents() {
    return [
      Incident(
        id: 'INC-2024-001',
        title: 'Fire Detected in Zone A',
        description: 'YOLO detection: Fire detected in machinery area',
        severity: Constants.severityCritical,
        status: Constants.statusOpen,
        detectionClass: 'Fire',
        cameraId: 1,
        confidence: 0.96,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        location: 'Zone A - Level 1',
      ),
      Incident(
        id: 'INC-2024-002',
        title: 'Smoke Detection Alert',
        description: 'Smoke pattern detected in processing unit',
        severity: Constants.severityMajor,
        status: Constants.statusAcknowledged,
        detectionClass: 'Smoke',
        cameraId: 3,
        confidence: 0.87,
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        acknowledgedAt: DateTime.now().subtract(const Duration(hours: 3)),
        location: 'Unit B - Processing',
      ),
      Incident(
        id: 'INC-2024-003',
        title: 'PPE Violation Detected',
        description: 'Personnel without safety equipment detected',
        severity: Constants.severityMinor,
        status: Constants.statusClosed,
        detectionClass: 'PPE Violation',
        cameraId: 5,
        confidence: 0.92,
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        closedAt: DateTime.now().subtract(const Duration(hours: 1)),
        location: 'Entry Point 2',
      ),
      Incident(
        id: 'INC-2024-004',
        title: 'Gas Leak Detected',
        description: 'Potential gas leak sensor activation',
        severity: Constants.severityMajor,
        status: Constants.statusEscalated,
        detectionClass: 'Gas Leak',
        cameraId: 7,
        confidence: 0.91,
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        location: 'Storage Area C',
      ),
      Incident(
        id: 'INC-2024-005',
        title: 'Unauthorized Access',
        description: 'Unauthorized personnel in restricted area',
        severity: Constants.severityMinor,
        status: Constants.statusOpen,
        detectionClass: 'Unauthorized Access',
        cameraId: 2,
        confidence: 0.88,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        location: 'Restricted Zone B',
      ),
    ];
  }

  static List<Camera> getCameras() {
    return [
      Camera(
        id: 1,
        name: 'Main Entrance',
        location: 'Zone A - Entry',
        ipAddress: '192.168.1.101',
        port: 8080,
        streamUrl: 'rtsp://192.168.1.101:8080/stream',
        status: Constants.cameraStatusOnline,
        latitude: 25.3548,
        longitude: 55.3643,
        recordingEnabled: true,
        resolutionWidth: 1920,
        resolutionHeight: 1080,
        frameRate: 30,
        lastSeen: DateTime.now(),
      ),
      Camera(
        id: 2,
        name: 'Processing Unit',
        location: 'Unit B',
        ipAddress: '192.168.1.102',
        port: 8080,
        streamUrl: 'rtsp://192.168.1.102:8080/stream',
        status: Constants.cameraStatusOnline,
        latitude: 25.3549,
        longitude: 55.3644,
        recordingEnabled: true,
        resolutionWidth: 1920,
        resolutionHeight: 1080,
        frameRate: 30,
        lastSeen: DateTime.now(),
      ),
      Camera(
        id: 3,
        name: 'Storage Area',
        location: 'Zone C',
        ipAddress: '192.168.1.103',
        port: 8080,
        streamUrl: 'rtsp://192.168.1.103:8080/stream',
        status: Constants.cameraStatusOffline,
        latitude: 25.3550,
        longitude: 55.3645,
        recordingEnabled: true,
        resolutionWidth: 1920,
        resolutionHeight: 1080,
        frameRate: 30,
        lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Camera(
        id: 4,
        name: 'Equipment Room',
        location: 'Level 2',
        ipAddress: '192.168.1.104',
        port: 8080,
        streamUrl: 'rtsp://192.168.1.104:8080/stream',
        status: Constants.cameraStatusOnline,
        latitude: 25.3551,
        longitude: 55.3646,
        recordingEnabled: true,
        resolutionWidth: 1920,
        resolutionHeight: 1080,
        frameRate: 30,
        lastSeen: DateTime.now(),
      ),
    ];
  }

  static List<Sensor> getSensors() {
    return [
      Sensor(
        id: 1,
        name: 'Temperature Sensor A',
        type: 'Temperature',
        location: 'Zone A',
        currentValue: 34.5,
        minValue: 15.0,
        maxValue: 40.0,
        unit: '°C',
        lastUpdated: DateTime.now(),
        isHealthy: true,
      ),
      Sensor(
        id: 2,
        name: 'Humidity Sensor B',
        type: 'Humidity',
        location: 'Unit B',
        currentValue: 65.2,
        minValue: 30.0,
        maxValue: 80.0,
        unit: '%',
        lastUpdated: DateTime.now(),
        isHealthy: true,
      ),
      Sensor(
        id: 3,
        name: 'Smoke Detector C',
        type: 'Smoke',
        location: 'Zone C',
        currentValue: 0.1,
        minValue: 0.0,
        maxValue: 10.0,
        unit: 'ppm',
        lastUpdated: DateTime.now(),
        isHealthy: false,
      ),
      Sensor(
        id: 4,
        name: 'Gas Sensor D',
        type: 'Gas',
        location: 'Storage',
        currentValue: 2.3,
        minValue: 0.0,
        maxValue: 100.0,
        unit: 'ppm',
        lastUpdated: DateTime.now(),
        isHealthy: true,
      ),
      Sensor(
        id: 5,
        name: 'Pressure Monitor E',
        type: 'Pressure',
        location: 'Machinery',
        currentValue: 8.7,
        minValue: 0.0,
        maxValue: 10.0,
        unit: 'bar',
        lastUpdated: DateTime.now(),
        isHealthy: true,
      ),
    ];
  }

  static List<TrainingRun> getTrainingRuns() {
    return [
      TrainingRun(
        id: 'TRAIN-001',
        name: 'YOLOv8 - Fire Detection v1',
        status: Constants.statusOpen, // Using RUNNING
        epoch: 75,
        totalEpochs: 100,
        trainingLoss: 0.234,
        validationLoss: 0.267,
        accuracy: 0.962,
        mAP: 0.951,
        startedAt: DateTime.now().subtract(const Duration(hours: 4)),
        model: 'YOLOv8',
        confidence: 0.95,
      ),
      TrainingRun(
        id: 'TRAIN-002',
        name: 'YOLOv8 - PPE Detection v2',
        status: 'COMPLETED',
        epoch: 100,
        totalEpochs: 100,
        trainingLoss: 0.189,
        validationLoss: 0.201,
        accuracy: 0.978,
        mAP: 0.964,
        startedAt: DateTime.now().subtract(const Duration(days: 2)),
        completedAt: DateTime.now().subtract(const Duration(hours: 8)),
        bestModelCheckpoint: 'checkpoint_epoch_98.pt',
        model: 'YOLOv8',
        confidence: 0.97,
      ),
      TrainingRun(
        id: 'TRAIN-003',
        name: 'YOLOv8 - Smoke Detection v3',
        status: 'QUEUED',
        epoch: 0,
        totalEpochs: 100,
        trainingLoss: 0.0,
        validationLoss: 0.0,
        accuracy: 0.0,
        mAP: 0.0,
        startedAt: DateTime.now(),
        model: 'YOLOv8',
      ),
    ];
  }

  static ServiceStatus getServiceStatus() {
    return ServiceStatus(
      status: Constants.serviceStatusHealthy,
      cpuUsage: 42.5,
      memoryUsage: 68.3,
      gpuUsage: 87.6,
      storageUsage: 54.2,
      activeConnections: 156,
      uptime: '45d 12h 30m',
      logs: [
        '[2024-11-08 12:34:56] WebSocket client connected',
        '[2024-11-08 12:33:45] Training run TRAIN-002 completed',
        '[2024-11-08 12:32:10] Incident INC-2024-004 detected',
        '[2024-11-08 12:30:00] Service health check passed',
        '[2024-11-08 12:28:45] Camera 3 went offline',
      ],
      timestamp: DateTime.now(),
      diskSpace: {
        '/data': '250 GB',
        '/logs': '50 GB',
        '/models': '150 GB',
      },
    );
  }

  static Map<String, dynamic> getAnalytics() {
    return {
      'alert_trends': [
        {'date': 'Mon', 'critical': 2, 'major': 5, 'minor': 8},
        {'date': 'Tue', 'critical': 1, 'major': 4, 'minor': 6},
        {'date': 'Wed', 'critical': 3, 'major': 7, 'minor': 10},
        {'date': 'Thu', 'critical': 2, 'major': 5, 'minor': 9},
        {'date': 'Fri', 'critical': 4, 'major': 8, 'minor': 12},
        {'date': 'Sat', 'critical': 1, 'major': 3, 'minor': 5},
        {'date': 'Sun', 'critical': 0, 'major': 2, 'minor': 3},
      ],
      'ppe_compliance': [
        {'location': 'Zone A', 'compliance': 95},
        {'location': 'Zone B', 'compliance': 87},
        {'location': 'Zone C', 'compliance': 92},
        {'location': 'Zone D', 'compliance': 88},
      ],
      'camera_uptime': [
        {'camera': 'Cam 1', 'uptime': 99.8},
        {'camera': 'Cam 2', 'uptime': 99.9},
        {'camera': 'Cam 3', 'uptime': 85.2},
        {'camera': 'Cam 4', 'uptime': 99.7},
      ],
    };
  }
}
