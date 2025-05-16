class SignInResponse {
  final String email;
  final String id;
  final String role;
  final int exp;
  final String iss;
  final String aud;

  SignInResponse({
    required this.email,
    required this.id,
    required this.role,
    required this.exp,
    required this.iss,
    required this.aud,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      email: json['Email'] as String,
      id: json['Id'] as String,
      role: json['Role'] as String,
      exp: json['exp'] as int,
      iss: json['iss'] as String,
      aud: json['aud'] as String,
    );
  }
}
