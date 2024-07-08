import 'dart:convert';

KycDetailsUpdateModel kycDetailsUpdateModelFromJson(String str) => KycDetailsUpdateModel.fromJson(json.decode(str));

String kycDetailsUpdateModelToJson(KycDetailsUpdateModel data) => json.encode(data.toJson());

class KycDetailsUpdateModel {
  bool? success;
  KycDetailsUpdate? result;
  String? message;

  KycDetailsUpdateModel({
    this.success,
    this.result,
    this.message,
  });

  factory KycDetailsUpdateModel.fromJson(Map<String, dynamic> json) => KycDetailsUpdateModel(
    success: json["success"],
    result: json["result"]==null || json["result"]=="null"?KycDetailsUpdate():KycDetailsUpdate.fromJson(json["result"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result!.toJson(),
    "message": message,
  };
}

class KycDetailsUpdate {
  dynamic id;

  KycDetailsUpdate({
    this.id,
  });

  factory KycDetailsUpdate.fromJson(Map<String, dynamic> json) => KycDetailsUpdate(
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}
