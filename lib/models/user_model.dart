class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String profileImage;
  final String country;
  final String language;
  final String madhab;
  final bool isPremium;
  final bool isLoggedIn;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.profileImage,
    required this.country,
    required this.language,
    required this.madhab,
    this.isPremium = false,
    this.isLoggedIn = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profileImage: json['profileImage'] ?? '',
      country: json['country'] ?? '',
      language: json['language'] ?? 'bn',
      madhab: json['madhab'] ?? 'Hanafi',
      isPremium: json['isPremium'] ?? false,
      isLoggedIn: json['isLoggedIn'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'country': country,
      'language': language,
      'madhab': madhab,
      'isPremium': isPremium,
      'isLoggedIn': isLoggedIn,
    };
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? profileImage,
    String? country,
    String? language,
    String? madhab,
    bool? isPremium,
    bool? isLoggedIn,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      country: country ?? this.country,
      language: language ?? this.language,
      madhab: madhab ?? this.madhab,
      isPremium: isPremium ?? this.isPremium,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}
