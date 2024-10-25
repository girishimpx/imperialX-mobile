
import 'dart:convert';

OpenOrderHistoryModel openOrderHistoryModelFromJson(String str) => OpenOrderHistoryModel.fromJson(json.decode(str));

String openOrderHistoryModelToJson(OpenOrderHistoryModel data) => json.encode(data.toJson());

class OpenOrderHistoryModel {
  bool? success;
  List<openOrderList>? result;
  String? message;

  OpenOrderHistoryModel({
    this.success,
    this.result,
    this.message,
  });

  factory OpenOrderHistoryModel.fromJson(Map<String, dynamic> json) => OpenOrderHistoryModel(
    success: json["success"],
    result: json["result"] == null ? [] : List<openOrderList>.from(json["result"]!.map((x) => openOrderList.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class openOrderList {
  String? symbol;
  String? orderType;
  String? orderLinkId;
  String? slLimitPrice;
  String? orderId;
  String? cancelType;
  String? avgPrice;
  String? stopOrderType;
  String? lastPriceOnCreated;
  String? orderStatus;
  String? takeProfit;
  String? cumExecValue;
  String? smpType;
  int? triggerDirection;
  String? blockTradeId;
  String? isLeverage;
  String? rejectReason;
  String? price;
  String? orderIv;
  String? createdTime;
  String? tpTriggerBy;
  int? positionIdx;
  String? trailingPercentage;
  String? timeInForce;
  String? leavesValue;
  String? basePrice;
  String? updatedTime;
  String? side;
  int? smpGroup;
  String? triggerPrice;
  String? tpLimitPrice;
  String? trailingValue;
  String? cumExecFee;
  String? leavesQty;
  String? slTriggerBy;
  bool? closeOnTrigger;
  String? placeType;
  String? cumExecQty;
  bool? reduceOnly;
  String? activationPrice;
  String? qty;
  String? stopLoss;
  String? marketUnit;
  String? smpOrderId;
  String? triggerBy;

  openOrderList({
    this.symbol,
    this.orderType,
    this.orderLinkId,
    this.slLimitPrice,
    this.orderId,
    this.cancelType,
    this.avgPrice,
    this.stopOrderType,
    this.lastPriceOnCreated,
    this.orderStatus,
    this.takeProfit,
    this.cumExecValue,
    this.smpType,
    this.triggerDirection,
    this.blockTradeId,
    this.isLeverage,
    this.rejectReason,
    this.price,
    this.orderIv,
    this.createdTime,
    this.tpTriggerBy,
    this.positionIdx,
    this.trailingPercentage,
    this.timeInForce,
    this.leavesValue,
    this.basePrice,
    this.updatedTime,
    this.side,
    this.smpGroup,
    this.triggerPrice,
    this.tpLimitPrice,
    this.trailingValue,
    this.cumExecFee,
    this.leavesQty,
    this.slTriggerBy,
    this.closeOnTrigger,
    this.placeType,
    this.cumExecQty,
    this.reduceOnly,
    this.activationPrice,
    this.qty,
    this.stopLoss,
    this.marketUnit,
    this.smpOrderId,
    this.triggerBy,
  });

  factory openOrderList.fromJson(Map<String, dynamic> json) => openOrderList(
    symbol: json["symbol"],
    orderType: json["orderType"],
    orderLinkId: json["orderLinkId"],
    slLimitPrice: json["slLimitPrice"],
    orderId: json["orderId"],
    cancelType: json["cancelType"],
    avgPrice: json["avgPrice"],
    stopOrderType: json["stopOrderType"],
    lastPriceOnCreated: json["lastPriceOnCreated"],
    orderStatus: json["orderStatus"],
    takeProfit: json["takeProfit"],
    cumExecValue: json["cumExecValue"],
    smpType: json["smpType"],
    triggerDirection: json["triggerDirection"],
    blockTradeId: json["blockTradeId"],
    isLeverage: json["isLeverage"],
    rejectReason: json["rejectReason"],
    price: json["price"],
    orderIv: json["orderIv"],
    createdTime: json["createdTime"],
    tpTriggerBy: json["tpTriggerBy"],
    positionIdx: json["positionIdx"],
    trailingPercentage: json["trailingPercentage"],
    timeInForce: json["timeInForce"],
    leavesValue: json["leavesValue"],
    basePrice: json["basePrice"],
    updatedTime: json["updatedTime"],
    side: json["side"],
    smpGroup: json["smpGroup"],
    triggerPrice: json["triggerPrice"],
    tpLimitPrice: json["tpLimitPrice"],
    trailingValue: json["trailingValue"],
    cumExecFee: json["cumExecFee"],
    leavesQty: json["leavesQty"],
    slTriggerBy: json["slTriggerBy"],
    closeOnTrigger: json["closeOnTrigger"],
    placeType: json["placeType"],
    cumExecQty: json["cumExecQty"],
    reduceOnly: json["reduceOnly"],
    activationPrice: json["activationPrice"],
    qty: json["qty"],
    stopLoss: json["stopLoss"],
    marketUnit: json["marketUnit"],
    smpOrderId: json["smpOrderId"],
    triggerBy: json["triggerBy"],
  );

  Map<String, dynamic> toJson() => {
    "symbol": symbol,
    "orderType": orderType,
    "orderLinkId": orderLinkId,
    "slLimitPrice": slLimitPrice,
    "orderId": orderId,
    "cancelType": cancelType,
    "avgPrice": avgPrice,
    "stopOrderType": stopOrderType,
    "lastPriceOnCreated": lastPriceOnCreated,
    "orderStatus": orderStatus,
    "takeProfit": takeProfit,
    "cumExecValue": cumExecValue,
    "smpType": smpType,
    "triggerDirection": triggerDirection,
    "blockTradeId": blockTradeId,
    "isLeverage": isLeverage,
    "rejectReason": rejectReason,
    "price": price,
    "orderIv": orderIv,
    "createdTime": createdTime,
    "tpTriggerBy": tpTriggerBy,
    "positionIdx": positionIdx,
    "trailingPercentage": trailingPercentage,
    "timeInForce": timeInForce,
    "leavesValue": leavesValue,
    "basePrice": basePrice,
    "updatedTime": updatedTime,
    "side": side,
    "smpGroup": smpGroup,
    "triggerPrice": triggerPrice,
    "tpLimitPrice": tpLimitPrice,
    "trailingValue": trailingValue,
    "cumExecFee": cumExecFee,
    "leavesQty": leavesQty,
    "slTriggerBy": slTriggerBy,
    "closeOnTrigger": closeOnTrigger,
    "placeType": placeType,
    "cumExecQty": cumExecQty,
    "reduceOnly": reduceOnly,
    "activationPrice": activationPrice,
    "qty": qty,
    "stopLoss": stopLoss,
    "marketUnit": marketUnit,
    "smpOrderId": smpOrderId,
    "triggerBy": triggerBy,
  };
}
