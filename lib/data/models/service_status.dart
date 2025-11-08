import 'package:equatable/equatable.dart';

class ServiceStatus extends Equatable {
  final String status; // HEALTHY, DEGRADED, CRITICAL
  final double cpuUsage; // Percentage
  final double memoryUsage; // Percentage
  final double gpuUsage; // Percentage
  final double storageUsage; // Percentage
  final int activeConnections;
  final String uptime; // Human readable: "5d 3h 22m"
  final List<String> logs; // Recent logs
  final DateTime timestamp;
  final Map<String, dynamic>? diskSpace; // Path -> available space

  const ServiceStatus({
    required this.status,
    required this.cpuUsage,
    required this.memoryUsage,
    required this.gpuUsage,
    required this.storageUsage,
    required this.activeConnections,
    required this.uptime,
    required this.logs,
    required this.timestamp,
    this.diskSpace,
  });

  factory ServiceStatus.fromJson(Map<String, dynamic> json) {
    return ServiceStatus(
      status: json['status'] ?? 'HEALTHY',
      cpuUsage: (json['cpu_usage'] ?? 0.0).toDouble(),
      memoryUsage: (json['memory_usage'] ?? 0.0).toDouble(),
      gpuUsage: (json['gpu_usage'] ?? 0.0).toDouble(),
      storageUsage: (json['storage_usage'] ?? 0.0).toDouble(),
      activeConnections: json['active_connections'] ?? 0,
      uptime: json['uptime'] ?? '0d',
      logs: List<String>.from(json['logs'] ?? []),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      diskSpace: json['disk_space'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'cpu_usage': cpuUsage,
        'memory_usage': memoryUsage,
        'gpu_usage': gpuUsage,
        'storage_usage': storageUsage,
        'active_connections': activeConnections,
        'uptime': uptime,
        'logs': logs,
        'timestamp': timestamp.toIso8601String(),
        'disk_space': diskSpace,
      };

  @override
  List<Object?> get props => [
        status,
        cpuUsage,
        memoryUsage,
        gpuUsage,
        storageUsage,
        activeConnections,
        uptime,
        logs,
        timestamp,
        diskSpace,
      ];
}
