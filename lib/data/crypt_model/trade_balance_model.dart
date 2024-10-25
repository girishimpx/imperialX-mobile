// To parse this JSON data, do
//
//     final getTradeBalanceModel = getTradeBalanceModelFromJson(jsonString);

import 'dart:convert';

GetTradeBalanceModel getTradeBalanceModelFromJson(String str) => GetTradeBalanceModel.fromJson(json.decode(str));

String getTradeBalanceModelToJson(GetTradeBalanceModel data) => json.encode(data.toJson());

class GetTradeBalanceModel {
  bool? success;
  GetTradeBalanceModelResult? result;
  String? message;

  GetTradeBalanceModel({
    this.success,
    this.result,
    this.message,
  });

  factory GetTradeBalanceModel.fromJson(Map<String, dynamic> json) => GetTradeBalanceModel(
    success: json["success"],
    result: json["result"] == null ? null : GetTradeBalanceModelResult.fromJson(json["result"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result?.toJson(),
    "message": message,
  };
}

class GetTradeBalanceModelResult {
  int? retCode;
  String? retMsg;
  ResultResult? result;
  RetExtInfo? retExtInfo;
  int? time;

  GetTradeBalanceModelResult({
    this.retCode,
    this.retMsg,
    this.result,
    this.retExtInfo,
    this.time,
  });

  factory GetTradeBalanceModelResult.fromJson(Map<String, dynamic> json) => GetTradeBalanceModelResult(
    retCode: json["retCode"],
    retMsg: json["retMsg"],
    result: json["result"] == null ? null : ResultResult.fromJson(json["result"]),
    retExtInfo: json["retExtInfo"] == null ? null : RetExtInfo.fromJson(json["retExtInfo"]),
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "retCode": retCode,
    "retMsg": retMsg,
    "result": result?.toJson(),
    "retExtInfo": retExtInfo?.toJson(),
    "time": time,
  };
}

class ResultResult {
  List<ListElement>? list;

  ResultResult({
    this.list,
  });

  factory ResultResult.fromJson(Map<String, dynamic> json) => ResultResult(
    list: json["list"] == null ? [] : List<ListElement>.from(json["list"]!.map((x) => ListElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class ListElement {
  String? totalEquity;
  String? accountImRate;
  String? totalMarginBalance;
  String? totalInitialMargin;
  String? accountType;
  String? totalAvailableBalance;
  String? accountMmRate;
  String? totalPerpUpl;
  String? totalWalletBalance;
  String? accountLtv;
  String? totalMaintenanceMargin;
  List<Coin>? coin;

  ListElement({
    this.totalEquity,
    this.accountImRate,
    this.totalMarginBalance,
    this.totalInitialMargin,
    this.accountType,
    this.totalAvailableBalance,
    this.accountMmRate,
    this.totalPerpUpl,
    this.totalWalletBalance,
    this.accountLtv,
    this.totalMaintenanceMargin,
    this.coin,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
    totalEquity: json["totalEquity"],
    accountImRate: json["accountIMRate"],
    totalMarginBalance: json["totalMarginBalance"],
    totalInitialMargin: json["totalInitialMargin"],
    accountType: json["accountType"],
    totalAvailableBalance: json["totalAvailableBalance"],
    accountMmRate: json["accountMMRate"],
    totalPerpUpl: json["totalPerpUPL"],
    totalWalletBalance: json["totalWalletBalance"],
    accountLtv: json["accountLTV"],
    totalMaintenanceMargin: json["totalMaintenanceMargin"],
    coin: json["coin"] == null ? [] : List<Coin>.from(json["coin"]!.map((x) => Coin.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalEquity": totalEquity,
    "accountIMRate": accountImRate,
    "totalMarginBalance": totalMarginBalance,
    "totalInitialMargin": totalInitialMargin,
    "accountType": accountType,
    "totalAvailableBalance": totalAvailableBalance,
    "accountMMRate": accountMmRate,
    "totalPerpUPL": totalPerpUpl,
    "totalWalletBalance": totalWalletBalance,
    "accountLTV": accountLtv,
    "totalMaintenanceMargin": totalMaintenanceMargin,
    "coin": coin == null ? [] : List<dynamic>.from(coin!.map((x) => x.toJson())),
  };
}

class Coin {
  String? availableToBorrow;
  String? bonus;
  String? accruedInterest;
  String? availableToWithdraw;
  String? totalOrderIm;
  String? equity;
  String? totalPositionMm;
  String? usdValue;
  String? unrealisedPnl;
  bool? collateralSwitch;
  String? spotHedgingQty;
  String? borrowAmount;
  String? totalPositionIm;
  String? walletBalance;
  String? cumRealisedPnl;
  String? locked;
  bool? marginCollateral;
  String? coin;

  Coin({
    this.availableToBorrow,
    this.bonus,
    this.accruedInterest,
    this.availableToWithdraw,
    this.totalOrderIm,
    this.equity,
    this.totalPositionMm,
    this.usdValue,
    this.unrealisedPnl,
    this.collateralSwitch,
    this.spotHedgingQty,
    this.borrowAmount,
    this.totalPositionIm,
    this.walletBalance,
    this.cumRealisedPnl,
    this.locked,
    this.marginCollateral,
    this.coin,
  });

  factory Coin.fromJson(Map<String, dynamic> json) => Coin(
    availableToBorrow: json["availableToBorrow"],
    bonus: json["bonus"],
    accruedInterest: json["accruedInterest"],
    availableToWithdraw: json["availableToWithdraw"],
    totalOrderIm: json["totalOrderIM"],
    equity: json["equity"],
    totalPositionMm: json["totalPositionMM"],
    usdValue: json["usdValue"],
    unrealisedPnl: json["unrealisedPnl"],
    collateralSwitch: json["collateralSwitch"],
    spotHedgingQty: json["spotHedgingQty"],
    borrowAmount: json["borrowAmount"],
    totalPositionIm: json["totalPositionIM"],
    walletBalance: json["walletBalance"],
    cumRealisedPnl: json["cumRealisedPnl"],
    locked: json["locked"],
    marginCollateral: json["marginCollateral"],
    coin: json["coin"],
  );

  Map<String, dynamic> toJson() => {
    "availableToBorrow": availableToBorrow,
    "bonus": bonus,
    "accruedInterest": accruedInterest,
    "availableToWithdraw": availableToWithdraw,
    "totalOrderIM": totalOrderIm,
    "equity": equity,
    "totalPositionMM": totalPositionMm,
    "usdValue": usdValue,
    "unrealisedPnl": unrealisedPnl,
    "collateralSwitch": collateralSwitch,
    "spotHedgingQty": spotHedgingQty,
    "borrowAmount": borrowAmount,
    "totalPositionIM": totalPositionIm,
    "walletBalance": walletBalance,
    "cumRealisedPnl": cumRealisedPnl,
    "locked": locked,
    "marginCollateral": marginCollateral,
    "coin": coin,
  };
}

class RetExtInfo {
  RetExtInfo();

  factory RetExtInfo.fromJson(Map<String, dynamic> json) => RetExtInfo(
  );

  Map<String, dynamic> toJson() => {
  };
}
