import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  UserClass user;
  String accessToken;
  String refreshToken;

  User({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        user: UserClass.fromJson(json["user"]),
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "accessToken": accessToken,
        "refreshToken": refreshToken,
      };
}

class UserClass {
  String id;
  String userName;
  String name;
  String role;
  DateTime createdAt;
  DateTime updatedAt;

  UserClass({
    required this.id,
    required this.userName,
    required this.name,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
        id: json["_id"],
        userName: json["user_name"],
        name: json["name"],
        role: json["role"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user_name": userName,
        "name": name,
        "role": role,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
