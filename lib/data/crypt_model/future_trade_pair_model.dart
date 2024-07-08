import 'dart:convert';

FutureTradePairListModel futureTradePairListModelFromJson(String str) => FutureTradePairListModel.fromJson(json.decode(str));

String futureTradePairListModelToJson(FutureTradePairListModel data) => json.encode(data.toJson());

class FutureTradePairListModel {
  bool? success;
  List<FutureTradePair>? result;
  String? message;

  FutureTradePairListModel({
    this.success,
    this.result,
    this.message,
  });

  factory FutureTradePairListModel.fromJson(Map<String, dynamic> json) => FutureTradePairListModel(
    success: json["success"],
    result: List<FutureTradePair>.from(json["result"].map((x) => FutureTradePair.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class FutureTradePair {
  String? symbol;
  String? lastPrice;
  String? indexPrice;
  String? markPrice;
  String? prevPrice24H;
  String? price24HPcnt;
  String? highPrice24H;
  String? lowPrice24H;
  String? prevPrice1H;
  String? openInterest;
  String? openInterestValue;
  String? turnover24H;
  String? volume24H;
  String? fundingRate;
  String? nextFundingTime;
  dynamic predictedDeliveryPrice;
  dynamic basisRate;
  String? deliveryFeeRate;
  String? deliveryTime;
  String? ask1Size;
  String? bid1Price;
  String? ask1Price;
  String? bid1Size;
  dynamic basis;

  FutureTradePair({
    this.symbol,
    this.lastPrice,
    this.indexPrice,
    this.markPrice,
    this.prevPrice24H,
    this.price24HPcnt,
    this.highPrice24H,
    this.lowPrice24H,
    this.prevPrice1H,
    this.openInterest,
    this.openInterestValue,
    this.turnover24H,
    this.volume24H,
    this.fundingRate,
    this.nextFundingTime,
    this.predictedDeliveryPrice,
    this.basisRate,
    this.deliveryFeeRate,
    this.deliveryTime,
    this.ask1Size,
    this.bid1Price,
    this.ask1Price,
    this.bid1Size,
    this.basis,
  });

  factory FutureTradePair.fromJson(Map<String, dynamic> json) => FutureTradePair(
    symbol: json["symbol"],
    lastPrice: json["lastPrice"],
    indexPrice: json["indexPrice"],
    markPrice: json["markPrice"],
    prevPrice24H: json["prevPrice24h"],
    price24HPcnt: json["price24hPcnt"],
    highPrice24H: json["highPrice24h"],
    lowPrice24H: json["lowPrice24h"],
    prevPrice1H: json["prevPrice1h"],
    openInterest: json["openInterest"],
    openInterestValue: json["openInterestValue"],
    turnover24H: json["turnover24h"],
    volume24H: json["volume24h"],
    fundingRate: json["fundingRate"],
    nextFundingTime: json["nextFundingTime"],
    predictedDeliveryPrice: json["predictedDeliveryPrice"],
    basisRate: json["basisRate"],
    deliveryFeeRate: json["deliveryFeeRate"],
    deliveryTime: json["deliveryTime"],
    ask1Size: json["ask1Size"],
    bid1Price: json["bid1Price"],
    ask1Price: json["ask1Price"],
    bid1Size: json["bid1Size"],
    basis: json["basis"],
  );

  Map<String, dynamic> toJson() => {
    "symbol": symbol,
    "lastPrice": lastPrice,
    "indexPrice": indexPrice,
    "markPrice": markPrice,
    "prevPrice24h": prevPrice24H,
    "price24hPcnt": price24HPcnt,
    "highPrice24h": highPrice24H,
    "lowPrice24h": lowPrice24H,
    "prevPrice1h": prevPrice1H,
    "openInterest": openInterest,
    "openInterestValue": openInterestValue,
    "turnover24h": turnover24H,
    "volume24h": volume24H,
    "fundingRate": fundingRate,
    "nextFundingTime": nextFundingTime,
    "predictedDeliveryPrice": predictedDeliveryPrice,
    "basisRate": basisRate,
    "deliveryFeeRate": deliveryFeeRate,
    "deliveryTime": deliveryTime,
    "ask1Size": ask1Size,
    "bid1Price": bid1Price,
    "ask1Price": ask1Price,
    "bid1Size": bid1Size,
    "basis": basis,
  };
}

