class VisitorModel {
  final String id;
  final String? name;
  final String? email;
  final String? phone;
  final String source;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isVerified;

  VisitorModel({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.source = 'pwa',
    this.createdAt,
    this.updatedAt,
    this.isVerified = false,
  });

  factory VisitorModel.fromJson(Map<String, dynamic> json) {
    return VisitorModel(
      id: json['id'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      source: json['source'] as String? ?? 'pwa',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) : null,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }
}
