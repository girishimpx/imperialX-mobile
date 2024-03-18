import 'dart:convert';

WalletAddressModel walletAddressModelFromJson(String str) => WalletAddressModel.fromJson(json.decode(str));

String walletAddressModelToJson(WalletAddressModel data) => json.encode(data.toJson());

class WalletAddressModel {
  bool? success;
  List<WalletAddressResult>? result;
  String? message;

  WalletAddressModel({
    this.success,
    this.result,
    this.message,
  });

  factory WalletAddressModel.fromJson(Map<String, dynamic> json) => WalletAddressModel(
    success: json["success"],
    result: List<WalletAddressResult>.from(json["result"].map((x) => WalletAddressResult.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class WalletAddressResult {
  String? id;
  String? ccy;
  String? chain;
  String? subAcct;
  String? addr;
  String? userId;
  DateTime? createdAt;
  DateTime? updatedAt;

  WalletAddressResult({
    this.id,
    this.ccy,
    this.chain,
    this.subAcct,
    this.addr,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory WalletAddressResult.fromJson(Map<String, dynamic> json) => WalletAddressResult(
    id: json["_id"],
    ccy: json["ccy"],
    chain: json["chain"],
    subAcct: json["subAcct"],
    addr: json["addr"],
    userId: json["user_id"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "ccy": ccy,
    "chain": chain,
    "subAcct": subAcct,
    "addr": addr,
    "user_id": userId,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
  };
}
