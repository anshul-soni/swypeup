class User {
  final String id;
  final String name;
  final String email;
  final String? profilePictureUrl;
  final String? bio;
  final String authProvider;
  final String? authId;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profilePictureUrl,
    this.bio,
    required this.authProvider,
    this.authId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      email: json['email'],
      profilePictureUrl: json['profilePictureUrl'],
      bio: json['bio'],
      authProvider: json['authProvider'] ?? 'local',
      authId: json['authId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
      'bio': bio,
      'authProvider': authProvider,
      'authId': authId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? profilePictureUrl,
    String? bio,
    String? authProvider,
    String? authId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      bio: bio ?? this.bio,
      authProvider: authProvider ?? this.authProvider,
      authId: authId ?? this.authId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
