import 'dart:convert';

GetWalletAllPairsModel getWalletAllPairsModelFromJson(String str) => GetWalletAllPairsModel.fromJson(json.decode(str));

String getWalletAllPairsModelToJson(GetWalletAllPairsModel data) => json.encode(data.toJson());

class GetWalletAllPairsModel {
  bool? success;
  List<GetWalletAll>? result;
  dynamic totalPriceInUsd;
  String? message;

  GetWalletAllPairsModel({
    this.success,
    this.result,
    this.totalPriceInUsd,
    this.message,
  });

  factory GetWalletAllPairsModel.fromJson(Map<String, dynamic> json) => GetWalletAllPairsModel(
    success: json["success"],
    result: List<GetWalletAll>.from(json["result"].map((x) => GetWalletAll.fromJson(x))),
    totalPriceInUsd: json["total_price_in_usd"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "total_price_in_usd": totalPriceInUsd,
    "message": message,
  };
}

class GetWalletAll {
  dynamic balance;
  dynamic escrowBalance;
  String? symbol;
  String? entryBal;
  dynamic totalBalance;
  String? exitBal;
  String? marginLoan;
  List<dynamic>? maxLoan;
  List<Mugavari>? mugavari;
  String? id;
  String? coinname;
  String? assetId;
  dynamic userId;
  DateTime? createdAt;
  DateTime? updatedAt;

  GetWalletAll ({
    this.balance,
    this.escrowBalance,
    this.symbol,
    this.entryBal,
    this.totalBalance,
    this.exitBal,
    this.marginLoan,
    this.maxLoan,
    this.mugavari,
    this.id,
    this.coinname,
    this.assetId,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory GetWalletAll.fromJson(Map<String, dynamic> json) => GetWalletAll(
    balance: json["balance"],
    escrowBalance: json["escrow_balance"],
    symbol: json["symbol"],
    entryBal: json["Entry_bal"],
    totalBalance: json["total_balance"],
    exitBal: json["Exit_bal"],
    marginLoan: json["margin_loan"],
    maxLoan: List<dynamic>.from(json["max_loan"].map((x) => x)),
    mugavari: List<Mugavari>.from(json["mugavari"].map((x) => Mugavari.fromJson(x))),
    id: json["_id"],
    coinname: json["coinname"],
    assetId: json["asset_id"],
    userId:json["user_id"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "balance": balance,
    "escrow_balance": escrowBalance,
    "symbol": symbol,
    "Entry_bal": entryBal,
    "total_balance": totalBalance,
    "Exit_bal": exitBal,
    "margin_loan": marginLoan,
    "max_loan": List<dynamic>.from(maxLoan!.map((x) => x)),
    "mugavari": List<dynamic>.from(mugavari!.map((x) => x.toJson())),
    "_id": id,
    "coinname": coinname,
    "asset_id": assetId,
    "user_id": userId,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
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

