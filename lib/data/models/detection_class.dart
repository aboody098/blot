import 'package:equatable/equatable.dart';

class DetectionClass extends Equatable {
  final int id;
  final String name;
  final bool enabled;
  final double confidenceThreshold;
  final String? description;
  final String? color; // Hex color for UI

  const DetectionClass({
    required this.id,
    required this.name,
    required this.enabled,
    required this.confidenceThreshold,
    this.description,
    this.color,
  });

  factory DetectionClass.fromJson(Map<String, dynamic> json) {
    return DetectionClass(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      enabled: json['enabled'] ?? true,
      confidenceThreshold: (json['confidence_threshold'] ?? 0.5).toDouble(),
      description: json['description'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'enabled': enabled,
        'confidence_threshold': confidenceThreshold,
        'description': description,
        'color': color,
      };

  @override
  List<Object?> get props => [id, name, enabled, confidenceThreshold, description, color];
}
