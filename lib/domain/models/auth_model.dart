class AuthModel {
  final String? uid;
  final String? email;
  final String? password;
  final String? name;

  AuthModel({this.uid, this.email, this.password, this.name});

  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(
      uid: map['uid'] as String?,
      email: map['email'] as String?,
      password: map['password'] as String?,
      name: map['name'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email, 'password': password, 'name': name};
  }
}
