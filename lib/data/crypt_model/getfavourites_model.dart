// To parse this JSON data, do
//
//     final getFavouritesModel = getFavouritesModelFromJson(jsonString);

import 'dart:convert';

GetFavouritesModel getFavouritesModelFromJson(String str) => GetFavouritesModel.fromJson(json.decode(str));

String getFavouritesModelToJson(GetFavouritesModel data) => json.encode(data.toJson());

class GetFavouritesModel {
  bool? success;
  List<Result>? result;
  String? message;

  GetFavouritesModel({
    this.success,
    this.result,
    this.message,
  });

  factory GetFavouritesModel.fromJson(Map<String, dynamic> json) => GetFavouritesModel(
    success: json["success"],
    result: json["result"] == null ? [] : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class Result {
  String? imageurl;
  String? id;
  String? category;
  String? symbol;
  String? baseCoin;
  String? quoteCoin;
  String? status;
  String? marginTrading;
  DateTime? createdAt;
  DateTime? updatedAt;

  Result({
    this.imageurl,
    this.id,
    this.category,
    this.symbol,
    this.baseCoin,
    this.quoteCoin,
    this.status,
    this.marginTrading,
    this.createdAt,
    this.updatedAt,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    imageurl: json["imageurl"],
    id: json["_id"],
    category: json["category"],
    symbol: json["symbol"],
    baseCoin: json["baseCoin"],
    quoteCoin: json["quoteCoin"],
    status: json["status"],
    marginTrading: json["marginTrading"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "imageurl": imageurl,
    "_id": id,
    "category": category,
    "symbol": symbol,
    "baseCoin": baseCoin,
    "quoteCoin": quoteCoin,
    "status": status,
    "marginTrading": marginTrading,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
