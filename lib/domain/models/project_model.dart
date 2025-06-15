class Project {
  final String id;
  final String name;
  final String description;
  final int progress;
  final Location? location;
  final List<String> imageUrls;
  final List<String> videoUrls;

  Project({
    required this.id,
    required this.name,
    required this.description,
    this.progress = 0,
    this.location,
    this.imageUrls = const [],
    this.videoUrls = const [],
  });

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      progress: map['progress'],
      location: map['location'] != null
          ? Location.fromMap(map['location'])
          : null,
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      videoUrls: List<String>.from(map['videoUrls'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'progress': progress,
      'location': location?.toMap(),
      'imageUrls': imageUrls,
      'videoUrls': videoUrls,
    };
  }
}

class Location {
  final double latitude;
  final double longitude;

  Location({required this.latitude, required this.longitude});

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}