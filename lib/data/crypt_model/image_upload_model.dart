import 'dart:convert';

ImageUploadingModel imageUploadingModelFromJson(String str) => ImageUploadingModel.fromJson(json.decode(str));

String imageUploadingModelToJson(ImageUploadingModel data) => json.encode(data.toJson());

class ImageUploadingModel {
  bool? success;
  String? result;
  String? message;

  ImageUploadingModel({
    this.success,
    this.result,
    this.message,
  });

  factory ImageUploadingModel.fromJson(Map<String, dynamic> json) => ImageUploadingModel(
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
