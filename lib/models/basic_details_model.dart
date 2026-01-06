class User {
  final String userId;
  final String email;
  final String contact;
  final String status;
  final String packageStatus;
  final String role;

  User({
    required this.userId,
    required this.email,
    required this.contact,
    required this.status,
    required this.packageStatus,
    required this.role,
  });

  // Create User from API response 
  factory User.fromApiResponse(Map<String, dynamic> payload) {
    return User(
      userId: payload["userId"] ?? '',
      email: payload["email"] ?? '',
      contact: payload["contact"] ?? '',
      status: payload["status"] ?? '',
      packageStatus: payload["package_status"] ?? '',
      role: payload["role"] ?? '',
    );
  }
}