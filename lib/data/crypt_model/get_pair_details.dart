// To parse this JSON data, do
//
//     final pairDetailsModel = pairDetailsModelFromJson(jsonString);

import 'dart:convert';

PairDetailsModel pairDetailsModelFromJson(String str) => PairDetailsModel.fromJson(json.decode(str));

String pairDetailsModelToJson(PairDetailsModel data) => json.encode(data.toJson());

class PairDetailsModel {
  bool? success;
  List<Result>? result;
  String? message;

  PairDetailsModel({
    this.success,
    this.result,
    this.message,
  });

  factory PairDetailsModel.fromJson(Map<String, dynamic> json) => PairDetailsModel(
    success: json["success"],
    result: json["result"] == null ? [] : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class Result {
  String? symbol;
  String? contractType;
  String? status;
  String? baseCoin;
  String? quoteCoin;
  String? launchTime;
  String? deliveryTime;
  String? deliveryFeeRate;
  String? priceScale;
  LeverageFilter? leverageFilter;
  PriceFilter? priceFilter;
  LotSizeFilter? lotSizeFilter;
  bool? unifiedMarginTrade;
  int? fundingInterval;
  String? settleCoin;
  String? copyTrading;
  String? upperFundingRate;
  String? lowerFundingRate;
  bool? isPreListing;
  dynamic preListingInfo;

  Result({
    this.symbol,
    this.contractType,
    this.status,
    this.baseCoin,
    this.quoteCoin,
    this.launchTime,
    this.deliveryTime,
    this.deliveryFeeRate,
    this.priceScale,
    this.leverageFilter,
    this.priceFilter,
    this.lotSizeFilter,
    this.unifiedMarginTrade,
    this.fundingInterval,
    this.settleCoin,
    this.copyTrading,
    this.upperFundingRate,
    this.lowerFundingRate,
    this.isPreListing,
    this.preListingInfo,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    symbol: json["symbol"],
    contractType: json["contractType"],
    status: json["status"],
    baseCoin: json["baseCoin"],
    quoteCoin: json["quoteCoin"],
    launchTime: json["launchTime"],
    deliveryTime: json["deliveryTime"],
    deliveryFeeRate: json["deliveryFeeRate"],
    priceScale: json["priceScale"],
    leverageFilter: json["leverageFilter"] == null ? null : LeverageFilter.fromJson(json["leverageFilter"]),
    priceFilter: json["priceFilter"] == null ? null : PriceFilter.fromJson(json["priceFilter"]),
    lotSizeFilter: json["lotSizeFilter"] == null ? null : LotSizeFilter.fromJson(json["lotSizeFilter"]),
    unifiedMarginTrade: json["unifiedMarginTrade"],
    fundingInterval: json["fundingInterval"],
    settleCoin: json["settleCoin"],
    copyTrading: json["copyTrading"],
    upperFundingRate: json["upperFundingRate"],
    lowerFundingRate: json["lowerFundingRate"],
    isPreListing: json["isPreListing"],
    preListingInfo: json["preListingInfo"],
  );

  Map<String, dynamic> toJson() => {
    "symbol": symbol,
    "contractType": contractType,
    "status": status,
    "baseCoin": baseCoin,
    "quoteCoin": quoteCoin,
    "launchTime": launchTime,
    "deliveryTime": deliveryTime,
    "deliveryFeeRate": deliveryFeeRate,
    "priceScale": priceScale,
    "leverageFilter": leverageFilter?.toJson(),
    "priceFilter": priceFilter?.toJson(),
    "lotSizeFilter": lotSizeFilter?.toJson(),
    "unifiedMarginTrade": unifiedMarginTrade,
    "fundingInterval": fundingInterval,
    "settleCoin": settleCoin,
    "copyTrading": copyTrading,
    "upperFundingRate": upperFundingRate,
    "lowerFundingRate": lowerFundingRate,
    "isPreListing": isPreListing,
    "preListingInfo": preListingInfo,
  };
}

class LeverageFilter {
  String? minLeverage;
  String? maxLeverage;
  String? leverageStep;

  LeverageFilter({
    this.minLeverage,
    this.maxLeverage,
    this.leverageStep,
  });

  factory LeverageFilter.fromJson(Map<String, dynamic> json) => LeverageFilter(
    minLeverage: json["minLeverage"],
    maxLeverage: json["maxLeverage"],
    leverageStep: json["leverageStep"],
  );

  Map<String, dynamic> toJson() => {
    "minLeverage": minLeverage,
    "maxLeverage": maxLeverage,
    "leverageStep": leverageStep,
  };
}

class LotSizeFilter {
  String? basePrecision;
  String? quotePrecision;
  String? maxOrderQty;
  String? minOrderQty;
  String? qtyStep;
  String? postOnlyMaxOrderQty;
  String? maxMktOrderQty;
  String? minNotionalValue;

  LotSizeFilter({
    this.basePrecision,
    this.quotePrecision,
    this.maxOrderQty,
    this.minOrderQty,
    this.qtyStep,
    this.postOnlyMaxOrderQty,
    this.maxMktOrderQty,
    this.minNotionalValue,
  });

  factory LotSizeFilter.fromJson(Map<String, dynamic> json) => LotSizeFilter(
    basePrecision: json["basePrecision"],
    quotePrecision: json["quotePrecision"],
    maxOrderQty: json["maxOrderQty"],
    minOrderQty: json["minOrderQty"],
    qtyStep: json["qtyStep"],
    postOnlyMaxOrderQty: json["postOnlyMaxOrderQty"],
    maxMktOrderQty: json["maxMktOrderQty"],
    minNotionalValue: json["minNotionalValue"],
  );

  Map<String, dynamic> toJson() => {
    "maxOrderQty": maxOrderQty,
    "minOrderQty": minOrderQty,
    "qtyStep": qtyStep,
    "postOnlyMaxOrderQty": postOnlyMaxOrderQty,
    "maxMktOrderQty": maxMktOrderQty,
    "minNotionalValue": minNotionalValue,
  };
}

class PriceFilter {
  String? minPrice;
  String? maxPrice;
  String? tickSize;

  PriceFilter({
    this.minPrice,
    this.maxPrice,
    this.tickSize,
  });

  factory PriceFilter.fromJson(Map<String, dynamic> json) => PriceFilter(
    minPrice: json["minPrice"],
    maxPrice: json["maxPrice"],
    tickSize: json["tickSize"],
  );

  Map<String, dynamic> toJson() => {
    "minPrice": minPrice,
    "maxPrice": maxPrice,
    "tickSize": tickSize,
  };
}
