import 'dart:convert';

InternalTransferModel internalTransferModelFromJson(String str) => InternalTransferModel.fromJson(json.decode(str));

String internalTransferModelToJson(InternalTransferModel data) => json.encode(data.toJson());

class InternalTransferModel {
  bool? success;
  List<InternalTransferResult>? result;
  String? message;

  InternalTransferModel({
    this.success,
    this.result,
    this.message,
  });

  factory InternalTransferModel.fromJson(Map<String, dynamic> json) => InternalTransferModel(
    success: json["success"],
    result: List<InternalTransferResult>.from(json["result"].map((x) => InternalTransferResult.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class InternalTransferResult {
  String? id;
  String? userId;
  String? amount;
  String? currency;
  String? from;
  String? to;
  DateTime? createdAt;
  DateTime? updatedAt;

  InternalTransferResult({
    this.id,
    this.userId,
    this.amount,
    this.currency,
    this.from,
    this.to,
    this.createdAt,
    this.updatedAt,
  });

  factory InternalTransferResult.fromJson(Map<String, dynamic> json) => InternalTransferResult(
    id: json["_id"],
    userId: json["user_id"],
    amount: json["Amount"],
    currency: json["Currency"],
    from: json["from"],
    to: json["to"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user_id": userId,
    "Amount": amount,
    "Currency": currency,
    "from": from,
    "to": to,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
  };
}
