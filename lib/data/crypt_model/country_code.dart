import 'dart:convert';

CountryCodeModelDetails countryCodeModelDetailsFromJson(String str) => CountryCodeModelDetails.fromJson(json.decode(str));

String countryCodeModelDetailsToJson(CountryCodeModelDetails data) => json.encode(data.toJson());

class CountryCodeModelDetails {
  bool? success;
  List<CountryCodeResult>? result;
  String? message;

  CountryCodeModelDetails({
    this.success,
    this.result,
    this.message,
  });

  factory CountryCodeModelDetails.fromJson(Map<String, dynamic> json) => CountryCodeModelDetails(
    success: json["success"],
    result: List<CountryCodeResult>.from(json["result"].map((x) => CountryCodeResult.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class CountryCodeResult {
  dynamic id;
  String? code;
  String? name;
  dynamic? createdAt;
  dynamic? updatedAt;

  CountryCodeResult({
    this.id,
    this.code,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory CountryCodeResult.fromJson(Map<String, dynamic> json) => CountryCodeResult(
    id: json["id"],
    code: json["code"],
    name: json["name"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "name": name,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
