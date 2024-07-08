import 'dart:convert';

DashImageModel dashImageModelFromJson(String str) => DashImageModel.fromJson(json.decode(str));

String dashImageModelToJson(DashImageModel data) => json.encode(data.toJson());

class DashImageModel {
  bool? success;
  List<DashImage>? result;
  String? message;

  DashImageModel({
    this.success,
    this.result,
    this.message,
  });

  factory DashImageModel.fromJson(Map<String, dynamic> json) => DashImageModel(
    success: json["success"],
    result: List<DashImage>.from(json["result"].map((x) => DashImage.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class DashImage {
  bool? status;
  String? id;
  String? name;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;

  DashImage({
    this.status,
    this.id,
    this.name,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory DashImage.fromJson(Map<String, dynamic> json) => DashImage(
    status: json["status"],
    id: json["_id"],
    name: json["name"],
    image: json["image"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "_id": id,
    "name": name,
    "image": image,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
  };
}
