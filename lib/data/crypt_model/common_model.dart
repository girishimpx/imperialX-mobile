import 'dart:convert';

CommonModel commonModelFromJson(String str) => CommonModel.fromJson(json.decode(str));

String commonModelToJson(CommonModel data) => json.encode(data.toJson());

class CommonModel {
  CommonModel({
    this.status,
    this.message,
  });

  bool? status;
  String? message;

  factory CommonModel.fromJson(Map<String, dynamic> json) => CommonModel(
    status: json["success"],
    message: json["message"],
  );


  Map<String, dynamic> toJson() => {
    "status_code": status,
    "message": message,
  };
}
