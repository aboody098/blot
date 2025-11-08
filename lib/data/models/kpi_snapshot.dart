import 'package:equatable/equatable.dart';

class KpiSnapshot extends Equatable {
  final int totalIncidents;
  final int criticalIncidents;
  final int majorIncidents;
  final int minorIncidents;
  final int onlineCameras;
  final int offlineCameras;
  final double averageConfidence;
  final int ppeSensorsHealthy;
  final int ppeSensorsUnhealthy;
  final DateTime timestamp;
  final double systemUptime; // Percentage

  const KpiSnapshot({
    required this.totalIncidents,
    required this.criticalIncidents,
    required this.majorIncidents,
    required this.minorIncidents,
    required this.onlineCameras,
    required this.offlineCameras,
    required this.averageConfidence,
    required this.ppeSensorsHealthy,
    required this.ppeSensorsUnhealthy,
    required this.timestamp,
    required this.systemUptime,
  });

  factory KpiSnapshot.fromJson(Map<String, dynamic> json) {
    return KpiSnapshot(
      totalIncidents: json['total_incidents'] ?? 0,
      criticalIncidents: json['critical_incidents'] ?? 0,
      majorIncidents: json['major_incidents'] ?? 0,
      minorIncidents: json['minor_incidents'] ?? 0,
      onlineCameras: json['online_cameras'] ?? 0,
      offlineCameras: json['offline_cameras'] ?? 0,
      averageConfidence: (json['average_confidence'] ?? 0.0).toDouble(),
      ppeSensorsHealthy: json['ppe_sensors_healthy'] ?? 0,
      ppeSensorsUnhealthy: json['ppe_sensors_unhealthy'] ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      systemUptime: (json['system_uptime'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'total_incidents': totalIncidents,
        'critical_incidents': criticalIncidents,
        'major_incidents': majorIncidents,
        'minor_incidents': minorIncidents,
        'online_cameras': onlineCameras,
        'offline_cameras': offlineCameras,
        'average_confidence': averageConfidence,
        'ppe_sensors_healthy': ppeSensorsHealthy,
        'ppe_sensors_unhealthy': ppeSensorsUnhealthy,
        'timestamp': timestamp.toIso8601String(),
        'system_uptime': systemUptime,
      };

  @override
  List<Object?> get props => [
        totalIncidents,
        criticalIncidents,
        majorIncidents,
        minorIncidents,
        onlineCameras,
        offlineCameras,
        averageConfidence,
        ppeSensorsHealthy,
        ppeSensorsUnhealthy,
        timestamp,
        systemUptime,
      ];
}
