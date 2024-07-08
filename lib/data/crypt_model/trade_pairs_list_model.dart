import 'dart:convert';

TradePairsSpotModel tradePairsSpotModelFromJson(String str) => TradePairsSpotModel.fromJson(json.decode(str));

String tradePairsSpotModelToJson(TradePairsSpotModel data) => json.encode(data.toJson());

class TradePairsSpotModel {
  bool? success;
  List<TradePairsSpot>? result;
  String? message;

  TradePairsSpotModel({
    this.success,
    this.result,
    this.message,
  });

  factory TradePairsSpotModel.fromJson(Map<String, dynamic> json) => TradePairsSpotModel(
    success: json["success"],
    result: List<TradePairsSpot>.from(json["result"].map((x) => TradePairsSpot.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class TradePairsSpot {
  String? symbol;
  String? bid1Price;
  String? bid1Size;
  String? ask1Price;
  String? ask1Size;
  String? lastPrice;
  String? prevPrice24H;
  String? price24HPcnt;
  String? highPrice24H;
  String? lowPrice24H;
  String? turnover24H;
  String? volume24H;
  String? usdIndexPrice;

  TradePairsSpot({
    this.symbol,
    this.bid1Price,
    this.bid1Size,
    this.ask1Price,
    this.ask1Size,
    this.lastPrice,
    this.prevPrice24H,
    this.price24HPcnt,
    this.highPrice24H,
    this.lowPrice24H,
    this.turnover24H,
    this.volume24H,
    this.usdIndexPrice,
  });

  factory TradePairsSpot.fromJson(Map<String, dynamic> json) => TradePairsSpot(
    symbol: json["symbol"],
    bid1Price: json["bid1Price"],
    bid1Size: json["bid1Size"],
    ask1Price: json["ask1Price"],
    ask1Size: json["ask1Size"],
    lastPrice: json["lastPrice"],
    prevPrice24H: json["prevPrice24h"],
    price24HPcnt: json["price24hPcnt"],
    highPrice24H: json["highPrice24h"],
    lowPrice24H: json["lowPrice24h"],
    turnover24H: json["turnover24h"],
    volume24H: json["volume24h"],
    usdIndexPrice: json["usdIndexPrice"],
  );

  Map<String, dynamic> toJson() => {
    "symbol": symbol,
    "bid1Price": bid1Price,
    "bid1Size": bid1Size,
    "ask1Price": ask1Price,
    "ask1Size": ask1Size,
    "lastPrice": lastPrice,
    "prevPrice24h": prevPrice24H,
    "price24hPcnt": price24HPcnt,
    "highPrice24h": highPrice24H,
    "lowPrice24h": lowPrice24H,
    "turnover24h": turnover24H,
    "volume24h": volume24H,
    "usdIndexPrice": usdIndexPrice,
  };
}
