import 'package:equatable/equatable.dart';

class Sensor extends Equatable {
  final int id;
  final String name;
  final String type; // Temperature, Humidity, Smoke, Gas, etc.
  final String location;
  final double currentValue;
  final double minValue;
  final double maxValue;
  final String unit;
  final DateTime lastUpdated;
  final bool isHealthy;

  const Sensor({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.currentValue,
    required this.minValue,
    required this.maxValue,
    required this.unit,
    required this.lastUpdated,
    required this.isHealthy,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      location: json['location'] ?? '',
      currentValue: (json['current_value'] ?? 0.0).toDouble(),
      minValue: (json['min_value'] ?? 0.0).toDouble(),
      maxValue: (json['max_value'] ?? 100.0).toDouble(),
      unit: json['unit'] ?? '',
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'])
          : DateTime.now(),
      isHealthy: json['is_healthy'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'location': location,
        'current_value': currentValue,
        'min_value': minValue,
        'max_value': maxValue,
        'unit': unit,
        'last_updated': lastUpdated.toIso8601String(),
        'is_healthy': isHealthy,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        location,
        currentValue,
        minValue,
        maxValue,
        unit,
        lastUpdated,
        isHealthy,
      ];
}
