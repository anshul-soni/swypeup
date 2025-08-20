import 'user.dart';

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: List<double>.from(json['coordinates']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}

class Activity {
  final String id;
  final String title;
  final String description;
  final Location location;
  final String address;
  final DateTime startTime;
  final DateTime endTime;
  final int maxParticipants;
  final User host;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.address,
    required this.startTime,
    required this.endTime,
    required this.maxParticipants,
    required this.host,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['_id'] ?? json['id'],
      title: json['title'],
      description: json['description'],
      location: Location.fromJson(json['location']),
      address: json['address'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      maxParticipants: json['maxParticipants'],
      host: User.fromJson(json['hostId']),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location.toJson(),
      'address': address,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'maxParticipants': maxParticipants,
      'hostId': host.id,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Activity copyWith({
    String? id,
    String? title,
    String? description,
    Location? location,
    String? address,
    DateTime? startTime,
    DateTime? endTime,
    int? maxParticipants,
    User? host,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Activity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      address: address ?? this.address,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      host: host ?? this.host,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
