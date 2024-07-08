import 'dart:convert';

GetAddressListCoinModel getAddressListCoinModelFromJson(String str) => GetAddressListCoinModel.fromJson(json.decode(str));

String getAddressListCoinModelToJson(GetAddressListCoinModel data) => json.encode(data.toJson());

class GetAddressListCoinModel {
  bool? success;
  List<GetAddressList>? result;
  String? message;

  GetAddressListCoinModel({
    this.success,
    this.result,
    this.message,
  });

  factory GetAddressListCoinModel.fromJson(Map<String, dynamic> json) => GetAddressListCoinModel(
    success: json["success"],
    result: List<GetAddressList>.from(json["result"].map((x) => GetAddressList.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class GetAddressList {
  dynamic balance;
  dynamic escrowBalance;
  String? symbol;
  String? entryBal;
  dynamic totalBalance;
  String? exitBal;
  String? marginLoan;
  List<dynamic>? maxLoan;
  List<AddressMugavari>? mugavari;
  String? id;
  String? coinname;
  String? assetId;
  String? userId;
  DateTime? createdAt;
  DateTime? updatedAt;

  GetAddressList ({
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

  factory GetAddressList.fromJson(Map<String, dynamic> json) => GetAddressList(
    balance: json["balance"],
    escrowBalance: json["escrow_balance"],
    symbol: json["symbol"],
    entryBal: json["Entry_bal"],
    totalBalance: json["total_balance"],
    exitBal: json["Exit_bal"],
    marginLoan: json["margin_loan"],
    maxLoan: List<dynamic>.from(json["max_loan"].map((x) => x)),
    mugavari: List<AddressMugavari>.from(json["mugavari"].map((x) => AddressMugavari.fromJson(x))),
    id: json["_id"],
    coinname: json["coinname"],
    assetId: json["asset_id"],
    userId: json["user_id"],
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

class AddressMugavari {
  String? chain;
  String? address;

  AddressMugavari({
    this.chain,
    this.address,
  });

  factory AddressMugavari.fromJson(Map<String, dynamic> json) => AddressMugavari(
    chain: json["chain"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "chain": chain,
    "address": address,
  };
}
