import 'dart:convert';

GetNotificationModel getNotificationModelFromJson(String str) => GetNotificationModel.fromJson(json.decode(str));

String getNotificationModelToJson(GetNotificationModel data) => json.encode(data.toJson());

class GetNotificationModel {
  bool? success;
  List<Notify>? result;
  String? message;

  GetNotificationModel({
    this.success,
    this.result,
    this.message,
  });

  factory GetNotificationModel.fromJson(Map<String, dynamic> json) => GetNotificationModel(
    success: json["success"],
    result: List<Notify>.from(json["result"].map((x) => Notify.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class Notify {
  bool? checked;
  String? id;
  String? resultFor;
  String? message;
  String? userId;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Notify({
    this.checked,
    this.id,
    this.resultFor,
    this.message,
    this.userId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Notify.fromJson(Map<String, dynamic> json) => Notify(
    checked: json["checked"],
    id: json["_id"],
    resultFor: json["for"],
    message: json["message"],
    userId: json["user_id"],
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "checked": checked,
    "_id": id,
    "for": resultFor,
    "message": message,
    "user_id": userId,
    "status": status,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
  };
}
