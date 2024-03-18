import 'dart:convert';

SubscribeModel subscribeModelFromJson(String str) => SubscribeModel.fromJson(json.decode(str));

String subscribeModelToJson(SubscribeModel data) => json.encode(data.toJson());

class SubscribeModel {
  bool? success;
  String? result;
  String? message;

  SubscribeModel({
    this.success,
    this.result,
    this.message,
  });

  factory SubscribeModel.fromJson(Map<String, dynamic> json) => SubscribeModel(
    success: json["success"],
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result,
    "message": message,
  };
}
