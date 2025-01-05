class UserModel {
  final String userId;
  final String userName;
  final String email;
  final String profilePic;
  final String themePreferences;
  final DateTime? lastLogin;
  final DateTime createdAt;

  UserModel({
    required this.userId,
    required this.userName,
    required this.email,
    required this.profilePic,
    required this.themePreferences,
    this.lastLogin,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      userName: json['userName'],
      email: json['email'],
      profilePic: json['profilePic'],
      themePreferences: json['themePreferences'],
      lastLogin:
          json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'email': email,
      'profilePic': profilePic,
      'themePreferences': themePreferences,
      'lastLogin': lastLogin?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
