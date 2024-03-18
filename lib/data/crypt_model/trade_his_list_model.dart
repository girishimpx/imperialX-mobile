import 'dart:convert';

TradeHistoryListModel tradeHistoryListModelFromJson(String str) => TradeHistoryListModel.fromJson(json.decode(str));

String tradeHistoryListModelToJson(TradeHistoryListModel data) => json.encode(data.toJson());

class TradeHistoryListModel {
  bool? success;
  List<TradeHistoryList>? result;
  String? message;

  TradeHistoryListModel({
    this.success,
    this.result,
    this.message,
  });

  factory TradeHistoryListModel.fromJson(Map<String, dynamic> json) => TradeHistoryListModel(
    success: json["success"],
    result: List<TradeHistoryList>.from(json["result"].map((x) => TradeHistoryList.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class TradeHistoryList {
  String? ouid;
  String? symbol;
  String? orderId;
  String? pair;
  String? orderType;
  dynamic price;
  dynamic volume;
  dynamic value;
  dynamic fees;
  dynamic commission;
  dynamic remaining;
  dynamic stoplimit;
  String? status;
  dynamic completedStatus;
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
  String? userId;
  String? loanUserId;
  String? tradePairId;
  String? assetId;
  String? tradeType;
  String? tradeAt;
  dynamic entryPrice;
  String? tradeIn;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic v;

  TradeHistoryList({
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
    this.tradeIn,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory TradeHistoryList.fromJson(Map<String, dynamic> json) => TradeHistoryList(
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
    entryPrice: json["entry_price"].toDouble(),
    tradeIn: json["trade_in"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
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
    "trade_in": tradeIn,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "__v": v,
  };
}
