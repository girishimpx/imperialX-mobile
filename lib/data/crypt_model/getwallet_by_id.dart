// To parse this JSON data, do
//
//     final getWalltByIdModel = getWalltByIdModelFromJson(jsonString);

import 'dart:convert';

GetWalltByIdModel getWalltByIdModelFromJson(String str) => GetWalltByIdModel.fromJson(json.decode(str));

String getWalltByIdModelToJson(GetWalltByIdModel data) => json.encode(data.toJson());

class GetWalltByIdModel {
  bool? success;
  List<Result>? result;
  String? message;

  GetWalltByIdModel({
    this.success,
    this.result,
    this.message,
  });

  factory GetWalltByIdModel.fromJson(Map<String, dynamic> json) => GetWalltByIdModel(
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
  double? balance;
  int? escrowBalance;
  String? symbol;
  String? entryBal;
  int? totalBalance;
  String? exitBal;
  String? marginLoan;
  String? url;
  List<dynamic>? maxLoan;
  List<Mugavari>? mugavari;
  String? id;
  String? coinname;
  String? assetId;
  String? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? usdValue;

  Result({
    this.balance,
    this.escrowBalance,
    this.symbol,
    this.entryBal,
    this.totalBalance,
    this.exitBal,
    this.marginLoan,
    this.url,
    this.maxLoan,
    this.mugavari,
    this.id,
    this.coinname,
    this.assetId,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.usdValue,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    balance: json["balance"]?.toDouble(),
    escrowBalance: json["escrow_balance"],
    symbol: json["symbol"],
    entryBal: json["Entry_bal"],
    totalBalance: json["total_balance"],
    exitBal: json["Exit_bal"],
    marginLoan: json["margin_loan"],
    url: json["url"],
    maxLoan: json["max_loan"] == null ? [] : List<dynamic>.from(json["max_loan"]!.map((x) => x)),
    mugavari: json["mugavari"] == null ? [] : List<Mugavari>.from(json["mugavari"]!.map((x) => Mugavari.fromJson(x))),
    id: json["_id"],
    coinname: json["coinname"],
    assetId: json["asset_id"],
    userId: json["user_id"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    usdValue: json["usdValue"],
  );

  Map<String, dynamic> toJson() => {
    "balance": balance,
    "escrow_balance": escrowBalance,
    "symbol": symbol,
    "Entry_bal": entryBal,
    "total_balance": totalBalance,
    "Exit_bal": exitBal,
    "margin_loan": marginLoan,
    "url": url,
    "max_loan": maxLoan == null ? [] : List<dynamic>.from(maxLoan!.map((x) => x)),
    "mugavari": mugavari == null ? [] : List<dynamic>.from(mugavari!.map((x) => x.toJson())),
    "_id": id,
    "coinname": coinname,
    "asset_id": assetId,
    "user_id": userId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "usdValue": usdValue,
  };
}

class Mugavari {
  String? chain;
  String? address;

  Mugavari({
    this.chain,
    this.address,
  });

  factory Mugavari.fromJson(Map<String, dynamic> json) => Mugavari(
    chain: json["chain"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "chain": chain,
    "address": address,
  };
}
