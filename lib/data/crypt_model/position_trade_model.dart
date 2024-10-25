import 'dart:convert';

PositionHistoryModel positionHistoryModelFromJson(String str) => PositionHistoryModel.fromJson(json.decode(str));

String positionHistoryModelToJson(PositionHistoryModel data) => json.encode(data.toJson());

class PositionHistoryModel {
  bool? success;
  List<PositionTrade>? result;
  String? message;

  PositionHistoryModel({
    this.success,
    this.result,
    this.message,
  });

  factory PositionHistoryModel.fromJson(Map<String, dynamic> json) => PositionHistoryModel(
    success: json["success"],
    result: json["result"] == null ? [] : List<PositionTrade>.from(json["result"]!.map((x) => PositionTrade.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class PositionTrade {
  String? symbol;
  String? leverage;
  int? autoAddMargin;
  String? avgPrice;
  String? liqPrice;
  String? riskLimitValue;
  String? takeProfit;
  String? positionValue;
  bool? isReduceOnly;
  String? tpslMode;
  int? riskId;
  String? trailingStop;
  String? unrealisedPnl;
  String? markPrice;
  int? adlRankIndicator;
  String? cumRealisedPnl;
  String? positionMm;
  String? createdTime;
  int? positionIdx;
  String? positionIm;
  int? seq;
  String? updatedTime;
  String? side;
  String? bustPrice;
  String? positionBalance;
  String? leverageSysUpdatedTime;
  String? curRealisedPnl;
  String? size;
  String? positionStatus;
  String? mmrSysUpdatedTime;
  String? stopLoss;
  int? tradeMode;
  String? sessionAvgPrice;

  PositionTrade({
    this.symbol,
    this.leverage,
    this.autoAddMargin,
    this.avgPrice,
    this.liqPrice,
    this.riskLimitValue,
    this.takeProfit,
    this.positionValue,
    this.isReduceOnly,
    this.tpslMode,
    this.riskId,
    this.trailingStop,
    this.unrealisedPnl,
    this.markPrice,
    this.adlRankIndicator,
    this.cumRealisedPnl,
    this.positionMm,
    this.createdTime,
    this.positionIdx,
    this.positionIm,
    this.seq,
    this.updatedTime,
    this.side,
    this.bustPrice,
    this.positionBalance,
    this.leverageSysUpdatedTime,
    this.curRealisedPnl,
    this.size,
    this.positionStatus,
    this.mmrSysUpdatedTime,
    this.stopLoss,
    this.tradeMode,
    this.sessionAvgPrice,
  });

  factory PositionTrade.fromJson(Map<String, dynamic> json) => PositionTrade(
    symbol: json["symbol"],
    leverage: json["leverage"],
    autoAddMargin: json["autoAddMargin"],
    avgPrice: json["avgPrice"],
    liqPrice: json["liqPrice"],
    riskLimitValue: json["riskLimitValue"],
    takeProfit: json["takeProfit"],
    positionValue: json["positionValue"],
    isReduceOnly: json["isReduceOnly"],
    tpslMode: json["tpslMode"],
    riskId: json["riskId"],
    trailingStop: json["trailingStop"],
    unrealisedPnl: json["unrealisedPnl"],
    markPrice: json["markPrice"],
    adlRankIndicator: json["adlRankIndicator"],
    cumRealisedPnl: json["cumRealisedPnl"],
    positionMm: json["positionMM"],
    createdTime: json["createdTime"],
    positionIdx: json["positionIdx"],
    positionIm: json["positionIM"],
    seq: json["seq"],
    updatedTime: json["updatedTime"],
    side: json["side"],
    bustPrice: json["bustPrice"],
    positionBalance: json["positionBalance"],
    leverageSysUpdatedTime: json["leverageSysUpdatedTime"],
    curRealisedPnl: json["curRealisedPnl"],
    size: json["size"],
    positionStatus: json["positionStatus"],
    mmrSysUpdatedTime: json["mmrSysUpdatedTime"],
    stopLoss: json["stopLoss"],
    tradeMode: json["tradeMode"],
    sessionAvgPrice: json["sessionAvgPrice"],
  );

  Map<String, dynamic> toJson() => {
    "symbol": symbol,
    "leverage": leverage,
    "autoAddMargin": autoAddMargin,
    "avgPrice": avgPrice,
    "liqPrice": liqPrice,
    "riskLimitValue": riskLimitValue,
    "takeProfit": takeProfit,
    "positionValue": positionValue,
    "isReduceOnly": isReduceOnly,
    "tpslMode": tpslMode,
    "riskId": riskId,
    "trailingStop": trailingStop,
    "unrealisedPnl": unrealisedPnl,
    "markPrice": markPrice,
    "adlRankIndicator": adlRankIndicator,
    "cumRealisedPnl": cumRealisedPnl,
    "positionMM": positionMm,
    "createdTime": createdTime,
    "positionIdx": positionIdx,
    "positionIM": positionIm,
    "seq": seq,
    "updatedTime": updatedTime,
    "side": side,
    "bustPrice": bustPrice,
    "positionBalance": positionBalance,
    "leverageSysUpdatedTime": leverageSysUpdatedTime,
    "curRealisedPnl": curRealisedPnl,
    "size": size,
    "positionStatus": positionStatus,
    "mmrSysUpdatedTime": mmrSysUpdatedTime,
    "stopLoss": stopLoss,
    "tradeMode": tradeMode,
    "sessionAvgPrice": sessionAvgPrice,
  };
}
