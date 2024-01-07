class ProfilePhotoModel {
  ProfilePhotoModel({
    required this.name,
    required this.downloadUrl,
  });
  final String name;
  final String downloadUrl;

  ProfilePhotoModel copyWith({
    String? name,
    String? downloadUrl,
  }) {
    return ProfilePhotoModel(
      name: name ?? this.name,
      downloadUrl: downloadUrl ?? this.downloadUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'downloadUrl': downloadUrl,
    };
  }

  static ProfilePhotoModel fromMap(Map<String, dynamic> map) {
    return ProfilePhotoModel(
      name: map['name'] as String,
      downloadUrl: map['downloadUrl'] as String,
    );
  }
}
