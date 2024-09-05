class Notice {
  final int id;
  final String header;
  final String description;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Notice({
    required this.id,
    required this.header,
    required this.description,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a Notice from a JSON map
  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'],
      header: json['header'],
      description: json['description'],
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method to convert a Notice object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'header': header,
      'description': description,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
