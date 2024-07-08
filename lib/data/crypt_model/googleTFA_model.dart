import 'dart:convert';

GoogleAuthCodeModel googleAuthCodeModelFromJson(String str) => GoogleAuthCodeModel.fromJson(json.decode(str));

String googleAuthCodeModelToJson(GoogleAuthCodeModel data) => json.encode(data.toJson());

class GoogleAuthCodeModel {
  bool? success;
  GoogleAuthCode? result;
  String? message;

  GoogleAuthCodeModel({
    this.success,
    this.result,
    this.message,
  });

  factory GoogleAuthCodeModel.fromJson(Map<String, dynamic> json) => GoogleAuthCodeModel(
    success: json["success"],
    result: GoogleAuthCode.fromJson(json["result"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result!.toJson(),
    "message": message,
  };
}

class GoogleAuthCode {
  String? secret;
  String? otpauthUrl;

  GoogleAuthCode({
    this.secret,
    this.otpauthUrl,
  });

  factory GoogleAuthCode.fromJson(Map<String, dynamic> json) => GoogleAuthCode(
    secret: json["secret"],
    otpauthUrl: json["otpauth_url"],
  );

  Map<String, dynamic> toJson() => {
    "secret": secret,
    "otpauth_url": otpauthUrl,
  };
}
