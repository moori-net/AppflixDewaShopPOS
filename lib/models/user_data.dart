class UserData {
  String appUrl;
  String username;
  String password;
  bool rememberLogin;

  UserData({
    this.appUrl = '',
    this.username = '',
    this.password = '',
    this.rememberLogin = true,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      UserData(
          appUrl: json['appUrl'] as String,
          username: json['username'] as String,
          password: json['password'] as String,
          rememberLogin: json['rememberLogin'] as bool,
      );

  Map<String, dynamic> toJson() => {
    'appUrl': appUrl,
    'username': username,
    'password': password,
    'rememberLogin': rememberLogin,
  };

  @override
  String toString() => 'UserData($toJson())';
}
