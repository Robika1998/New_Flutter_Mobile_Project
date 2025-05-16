class LoginType {
  final String login;
  final String password;

  LoginType({required this.login, required this.password});

  Map<String, dynamic> toJson() => {"login": login, "password": password};
}
