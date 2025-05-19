// class Session {
//   static String? token;
//   static String? refreshToken;
//   static String? decodedUserId;
// }

class Session {
  static String? token;
  static String? refreshToken;
  static String? decodedUserId;

  static void clear() {
    token = null;
    refreshToken = null;
    decodedUserId = null;
  }
}
