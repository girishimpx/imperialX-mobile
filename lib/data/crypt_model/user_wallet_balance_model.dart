import 'dart:convert';

UserWalletBalanceModel userWalletBalanceModelFromJson(String str) => UserWalletBalanceModel.fromJson(json.decode(str));

String userWalletBalanceModelToJson(UserWalletBalanceModel data) => json.encode(data.toJson());

class UserWalletBalanceModel {
  bool? success;
  List<UserWalletResult>? result;
  String? message;
  String? usdTotal;

  UserWalletBalanceModel({
    this.success,
    this.result,
    this.message,
    this.usdTotal,
  });

  factory UserWalletBalanceModel.fromJson(Map<String, dynamic> json) => UserWalletBalanceModel(
    success: json["success"],
    result: List<UserWalletResult>.from(json["result"].map((x) => UserWalletResult.fromJson(x))),
    message: json["message"],
    usdTotal: json["total_usdt"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
    "total_usdt": usdTotal,
  };
}

class UserWalletResult {
  String? asset;
  String? symbol;
  String? name;
  String? type;
  String? image;
  dynamic pointValue;
  dynamic perdayWithdraw;
  String? fee;
  String? commissionType;
  dynamic balance;
  dynamic escrow;
  dynamic total;
  dynamic usdtconvert;

  UserWalletResult({
    this.asset,
    this.symbol,
    this.name,
    this.type,
    this.image,
    this.pointValue,
    this.perdayWithdraw,
    this.fee,
    this.commissionType,
    this.balance,
    this.escrow,
    this.total,
    this.usdtconvert,
  });

  factory UserWalletResult.fromJson(Map<String, dynamic> json) => UserWalletResult(
    asset: json["asset"],
    symbol: json["symbol"],
    name: json["name"],
    type: json["type"],
    image: json["image"],
    pointValue: json["point_value"],
    perdayWithdraw: json["perday_withdraw"],
    fee: json["fee"],
    commissionType: json["commission_type"],
    balance: json["balance"],
    escrow: json["escrow"],
    total: json["total"],
    usdtconvert: json["usdtconvert"],
  );

  Map<String, dynamic> toJson() => {
    "asset": asset,
    "symbol": symbol,
    "name": name,
    "type": type,
    "image": image,
    "point_value": pointValue,
    "perday_withdraw": perdayWithdraw,
    "fee": fee,
    "commission_type": commissionType,
    "balance": balance,
    "escrow": escrow,
    "total": total,
    "usdtconvert": usdtconvert,
  };
}


class NetworkAddress {
  dynamic type;
  dynamic name;
  dynamic address;
  dynamic withdrawtype;
  dynamic withdrawcommission;


  NetworkAddress({
    this.type,
    this.name,
    this.address,
    this.withdrawtype,
    this.withdrawcommission,
  });

  factory NetworkAddress.fromJson(Map<String, dynamic> json) => NetworkAddress(
    type: json["type"],
    name: json["name"],
    address: json["address"],
    withdrawtype: json["withdrawtype"],
    withdrawcommission: json["withdrawcommission"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "name": name,
    "address": address,
    "withdrawtype": withdrawtype,
    "withdrawcommission": withdrawcommission,
  };
}