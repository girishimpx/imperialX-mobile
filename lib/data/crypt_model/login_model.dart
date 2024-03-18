import 'dart:convert';
import 'dart:convert';

LoginDetailsModel loginDetailsModelFromJson(String str) => LoginDetailsModel.fromJson(json.decode(str));

String loginDetailsModelToJson(LoginDetailsModel data) => json.encode(data.toJson());


class LoginDetailsModel {
  bool? success;
  Result? result;
  String? message;

  LoginDetailsModel({
    this.success,
    this.result,
    this.message,
  });

  factory LoginDetailsModel.fromJson(Map<String, dynamic> json) => LoginDetailsModel(
    success: json["success"],
    result: json["result"]=="null"|| json["result"]==null?Result(): Result.fromJson(json["result"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result!.toJson(),
    "message": message,
  };
}

class Result {
  String? token;
  User? user;

  Result({
    this.token,
    this.user,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    token: json["token"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user!.toJson(),
  };
}

class User {
  String? id;
  String? name;
  String? email;
  String? role;
  String? traderType;
  bool? suspend;

  User({
    this.id,
    this.name,
    this.email,
    this.role,
    this.traderType,
    this.suspend,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    role: json["role"],
    traderType: json["trader_type"],
    suspend: json["suspend"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "role": role,
    "trader_type": traderType,
    "suspend": suspend,
  };
}

