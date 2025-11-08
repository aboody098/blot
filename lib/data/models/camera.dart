import 'package:equatable/equatable.dart';

class Camera extends Equatable {
  final int id;
  final String name;
  final String location;
  final String ipAddress;
  final int port;
  final String streamUrl;
  final String status; // ONLINE, OFFLINE, MAINTENANCE
  final double latitude;
  final double longitude;
  final DateTime? lastSeen;
  final bool recordingEnabled;
  final int? resolutionWidth;
  final int? resolutionHeight;
  final double? frameRate;

  const Camera({
    required this.id,
    required this.name,
    required this.location,
    required this.ipAddress,
    required this.port,
    required this.streamUrl,
    required this.status,
    required this.latitude,
    required this.longitude,
    this.lastSeen,
    this.recordingEnabled = true,
    this.resolutionWidth,
    this.resolutionHeight,
    this.frameRate,
  });

  factory Camera.fromJson(Map<String, dynamic> json) {
    return Camera(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      ipAddress: json['ip_address'] ?? '',
      port: json['port'] ?? 80,
      streamUrl: json['stream_url'] ?? '',
      status: json['status'] ?? 'OFFLINE',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      lastSeen: json['last_seen'] != null
          ? DateTime.parse(json['last_seen'])
          : null,
      recordingEnabled: json['recording_enabled'] ?? true,
      resolutionWidth: json['resolution_width'],
      resolutionHeight: json['resolution_height'],
      frameRate: json['frame_rate']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'location': location,
        'ip_address': ipAddress,
        'port': port,
        'stream_url': streamUrl,
        'status': status,
        'latitude': latitude,
        'longitude': longitude,
        'last_seen': lastSeen?.toIso8601String(),
        'recording_enabled': recordingEnabled,
        'resolution_width': resolutionWidth,
        'resolution_height': resolutionHeight,
        'frame_rate': frameRate,
      };

  Camera copyWith({
    int? id,
    String? name,
    String? location,
    String? ipAddress,
    int? port,
    String? streamUrl,
    String? status,
    double? latitude,
    double? longitude,
    DateTime? lastSeen,
    bool? recordingEnabled,
    int? resolutionWidth,
    int? resolutionHeight,
    double? frameRate,
  }) {
    return Camera(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      ipAddress: ipAddress ?? this.ipAddress,
      port: port ?? this.port,
      streamUrl: streamUrl ?? this.streamUrl,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      lastSeen: lastSeen ?? this.lastSeen,
      recordingEnabled: recordingEnabled ?? this.recordingEnabled,
      resolutionWidth: resolutionWidth ?? this.resolutionWidth,
      resolutionHeight: resolutionHeight ?? this.resolutionHeight,
      frameRate: frameRate ?? this.frameRate,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        location,
        ipAddress,
        port,
        streamUrl,
        status,
        latitude,
        longitude,
        lastSeen,
        recordingEnabled,
        resolutionWidth,
        resolutionHeight,
        frameRate,
      ];
}
