class User {
  User({required this.name,required this.password,required this.email,required this.token});

  final String name;
  final String password;
  final String email;
  final String token;

  factory User.fromMap(Map<dynamic, dynamic> map) {
    return User(name: map['name'] as String,password: map['password'] as String,email: map['email'] as String,token: map['token'] as String);
  }

}
