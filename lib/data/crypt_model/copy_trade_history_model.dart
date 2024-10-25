// To parse this JSON data, do
//
//     final copyTradeHistoryModel = copyTradeHistoryModelFromJson(jsonString);

import 'dart:convert';

CopyTradeHistoryModel copyTradeHistoryModelFromJson(String str) => CopyTradeHistoryModel.fromJson(json.decode(str));

String copyTradeHistoryModelToJson(CopyTradeHistoryModel data) => json.encode(data.toJson());

class CopyTradeHistoryModel {
  bool? success;
  Result? result;
  String? message;

  CopyTradeHistoryModel({
    this.success,
    this.result,
    this.message,
  });

  factory CopyTradeHistoryModel.fromJson(Map<String, dynamic> json) => CopyTradeHistoryModel(
    success: json["success"],
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result?.toJson(),
    "message": message,
  };
}

class Result {
  List<Doc>? docs;
  int? totalDocs;
  int? limit;
  int? totalPages;
  int? page;
  int? pagingCounter;
  bool? hasPrevPage;
  bool? hasNextPage;
  dynamic prevPage;
  dynamic nextPage;

  Result({
    this.docs,
    this.totalDocs,
    this.limit,
    this.totalPages,
    this.page,
    this.pagingCounter,
    this.hasPrevPage,
    this.hasNextPage,
    this.prevPage,
    this.nextPage,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    docs: json["docs"] == null ? [] : List<Doc>.from(json["docs"]!.map((x) => Doc.fromJson(x))),
    totalDocs: json["totalDocs"],
    limit: json["limit"],
    totalPages: json["totalPages"],
    page: json["page"],
    pagingCounter: json["pagingCounter"],
    hasPrevPage: json["hasPrevPage"],
    hasNextPage: json["hasNextPage"],
    prevPage: json["prevPage"],
    nextPage: json["nextPage"],
  );

  Map<String, dynamic> toJson() => {
    "docs": docs == null ? [] : List<dynamic>.from(docs!.map((x) => x.toJson())),
    "totalDocs": totalDocs,
    "limit": limit,
    "totalPages": totalPages,
    "page": page,
    "pagingCounter": pagingCounter,
    "hasPrevPage": hasPrevPage,
    "hasNextPage": hasNextPage,
    "prevPage": prevPage,
    "nextPage": nextPage,
  };
}

class Doc {
  String? id;
  String? entryPrice;
  String? exitPrice;
  dynamic exchange;
  String? ouid;
  String? symbol;
  String? orderId;
  String? pair;
  String? orderType;
  dynamic price;
  double? volume;
  int? value;
  int? fees;
  int? commission;
  int? remaining;
  int? stoplimit;
  String? status;
  bool? completedStatus;
  dynamic priceperunit;
  int? leverage;
  dynamic marginAmount;
  dynamic marginRatio;
  int? convertPrice;
  int? loanAmount;
  String? userId;
  String? loanUserId;
  String? tradeType;
  String? tradeAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? docId;

  Doc({
    this.id,
    this.entryPrice,
    this.exitPrice,
    this.exchange,
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
    this.priceperunit,
    this.leverage,
    this.marginAmount,
    this.marginRatio,
    this.convertPrice,
    this.loanAmount,
    this.userId,
    this.loanUserId,
    this.tradeType,
    this.tradeAt,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.docId,
  });

  factory Doc.fromJson(Map<String, dynamic> json) => Doc(
    id: json["_id"],
    entryPrice: json["entry_price"],
    exitPrice: json["exit_price"],
    exchange: json["exchange"],
    ouid: json["ouid"],
    symbol: json["symbol"],
    orderId: json["order_id"],
    pair: json["pair"],
    orderType: json["order_type"],
    price: json["price"],
    volume: json["volume"]?.toDouble(),
    value: json["value"],
    fees: json["fees"],
    commission: json["commission"],
    remaining: json["remaining"],
    stoplimit: json["stoplimit"],
    status: json["status"],
    completedStatus: json["completed_status"],
    priceperunit: json["priceperunit"],
    leverage: json["leverage"],
    marginAmount: json["margin_amount"],
    marginRatio: json["margin_ratio"],
    convertPrice: json["convert_price"],
    loanAmount: json["loan_amount"],
    userId: json["user_id"],
    loanUserId: json["loan_user_id"],
    tradeType: json["trade_type"],
    tradeAt: json["trade_at"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    docId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "entry_price": entryPrice,
    "exit_price": exitPrice,
    "exchange": exchange,
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
    "priceperunit": priceperunit,
    "leverage": leverage,
    "margin_amount": marginAmount,
    "margin_ratio": marginRatio,
    "convert_price": convertPrice,
    "loan_amount": loanAmount,
    "user_id": userId,
    "loan_user_id": loanUserId,
    "trade_type": tradeType,
    "trade_at": tradeAt,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "id": docId,
  };
}
