import 'dart:convert';

AllHistoryModel allHistoryModelFromJson(String str) => AllHistoryModel.fromJson(json.decode(str));

String allHistoryModelToJson(AllHistoryModel data) => json.encode(data.toJson());

class AllHistoryModel {
  bool? success;
  List<AllHistory>? result;
  String? message;

  AllHistoryModel({
    this.success,
    this.result,
    this.message,
  });

  factory AllHistoryModel.fromJson(Map<String, dynamic> json) => AllHistoryModel(
    success: json["success"],
    result: List<AllHistory>.from(json["result"].map((x) => AllHistory.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class AllHistory {
  dynamic ouid;
  dynamic symbol;
  String? orderId;
  dynamic pair;
  dynamic orderType;
  dynamic price;
  dynamic volume;
  dynamic value;
  dynamic fees;
  dynamic commission;
  dynamic remaining;
  dynamic stoplimit;
  String? status;
  bool? completedStatus;
  String? posId;
  String? tradeId;
  String? posStatus;
  dynamic priceperunit;
  dynamic leverage;
  dynamic marginAmount;
  dynamic marginRatio;
  dynamic convertPrice;
  dynamic loanAmount;
  String? id;
  dynamic userId;
  dynamic loanUserId;
  dynamic tradePairId;
  dynamic assetId;
  dynamic tradeType;
  dynamic tradeAt;
  dynamic entryPrice;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic v;
  dynamic exitPrice;
  String? resultTradeIn;
  String? tradeIn;

  AllHistory({
    this.ouid,
    this.symbol,
    this.orderId,
    this.pair,
    this.orderType,
    this.price,
    this.volume,
    this.value,
    this.fees,
    this.commission,
    this.remaining,
    this.stoplimit,
    this.status,
    this.completedStatus,
    this.posId,
    this.tradeId,
    this.posStatus,
    this.priceperunit,
    this.leverage,
    this.marginAmount,
    this.marginRatio,
    this.convertPrice,
    this.loanAmount,
    this.id,
    this.userId,
    this.loanUserId,
    this.tradePairId,
    this.assetId,
    this.tradeType,
    this.tradeAt,
    this.entryPrice,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.exitPrice,
    this.resultTradeIn,
    this.tradeIn,
  });

  factory AllHistory.fromJson(Map<String, dynamic> json) => AllHistory(
    ouid: json["ouid"],
    symbol: json["symbol"],
    orderId: json["order_id"],
    pair: json["pair"],
    orderType: json["order_type"],
    price: json["price"],
    volume: json["volume"],
    value: json["value"],
    fees: json["fees"],
    commission: json["commission"],
    remaining: json["remaining"],
    stoplimit: json["stoplimit"],
    status: json["status"],
    completedStatus: json["completed_status"],
    posId: json["posId"],
    tradeId: json["tradeId"],
    posStatus: json["posStatus"],
    priceperunit: json["priceperunit"],
    leverage: json["leverage"],
    marginAmount: json["margin_amount"],
    marginRatio: json["margin_ratio"],
    convertPrice: json["convert_price"],
    loanAmount: json["loan_amount"],
    id: json["_id"],
    userId: json["user_id"],
    loanUserId: json["loan_user_id"],
    tradePairId: json["trade_pair_id"],
    assetId: json["asset_id"],
    tradeType: json["trade_type"],
    tradeAt: json["trade_at"],
    entryPrice: json["entry_price"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    exitPrice: json["exit_price"],
    resultTradeIn: json["trade_in:"],
    tradeIn: json["trade_in"],
  );

  Map<String, dynamic> toJson() => {
    "ouid": ouid,
    "symbol": symbol,
    "order_id": orderId,
    "pair": pair,
    "order_type": orderType,
    "price": price,
    "volume": volume,
    "value": value,
    "fees": fees,
    "commission": commission,
    "remaining": remaining,
    "stoplimit": stoplimit,
    "status": status,
    "completed_status": completedStatus,
    "posId": posId,
    "tradeId": tradeId,
    "posStatus": posStatus,
    "priceperunit": priceperunit,
    "leverage": leverage,
    "margin_amount": marginAmount,
    "margin_ratio": marginRatio,
    "convert_price": convertPrice,
    "loan_amount": loanAmount,
    "_id": id,
    "user_id": userId,
    "loan_user_id": loanUserId,
    "trade_pair_id": tradePairId,
    "asset_id": assetId,
    "trade_type": tradeType,
    "trade_at": tradeAt,
    "entry_price": entryPrice,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
    "exit_price": exitPrice,
    "trade_in:": resultTradeIn,
    "trade_in": tradeIn,
  };
}


