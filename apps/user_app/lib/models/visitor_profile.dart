class VisitorProfile {
  final String id;
  final List<String> interests;

  VisitorProfile({
    required this.id,
    this.interests = const [],
  });

  factory VisitorProfile.fromMap(Map<String, dynamic> data) {
    return VisitorProfile(
      id: data['id'] ?? data['uid'] ?? '',
      interests: List<String>.from(data['interests'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'interests': interests,
    };
  }
}
