import 'dart:convert';

TradePairListModel tradePairListModelFromJson(String str) => TradePairListModel.fromJson(json.decode(str));

String tradePairListModelToJson(TradePairListModel data) => json.encode(data.toJson());

class TradePairListModel {
  bool? success;
  List<TradePairList>? result;
  String? message;

  TradePairListModel({
    this.success,
    this.result,
    this.message,
  });

  factory TradePairListModel.fromJson(Map<String, dynamic> json) => TradePairListModel(
    success: json["success"],
    result: List<TradePairList>.from(json["result"].map((x) => TradePairList.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class TradePairList {
  dynamic withdraw;
  dynamic maxwithdraw;
  dynamic minwithdraw;
  List<dynamic>? abiarray;
  dynamic pointValue;
  dynamic decimalvalue;
  dynamic netfee;
  dynamic orderlist;
  String? url;
  String? coinimage1;
  String? coinimage2;
  bool? status;
  String? id;
  String? image;
  String? tradepair;
  dynamic coinname1;
  String? coinname2;
  dynamic chain;
  String? contractaddress;
  dynamic marketAsset;
  String? baseAsset;
  List<dynamic>? networkList;

  TradePairList({
    this.withdraw,
    this.maxwithdraw,
    this.minwithdraw,
    this.abiarray,
    this.pointValue,
    this.decimalvalue,
    this.netfee,
    this.orderlist,
    this.url,
    this.coinimage1,
    this.coinimage2,
    this.status,
    this.id,
    this.image,
    this.tradepair,
    this.coinname1,
    this.coinname2,
    this.chain,
    this.contractaddress,
    this.marketAsset,
    this.baseAsset,
    this.networkList,
  });

  factory TradePairList.fromJson(Map<String, dynamic> json) => TradePairList(
    withdraw: json["withdraw"],
    maxwithdraw: json["maxwithdraw"],
    minwithdraw: json["minwithdraw"],
    abiarray: List<dynamic>.from(json["abiarray"].map((x) => x)),
    pointValue: json["point_value"],
    decimalvalue: json["decimalvalue"],
    netfee: json["netfee"],
    orderlist: json["orderlist"],
    url: json["url"],
    coinimage1: json["coinimage1"],
    coinimage2: json["coinimage2"],
    status: json["status"],
    id: json["_id"],
    image: json["image"],
    tradepair: json["tradepair"],
    coinname1: json["coinname1"],
    coinname2: json["coinname2"],
    chain:json["chain"],
    contractaddress: json["contractaddress"],
    marketAsset: json["market_asset"],
    baseAsset: json["base_asset"],
    networkList: List<dynamic>.from(json["networkList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "withdraw": withdraw,
    "maxwithdraw": maxwithdraw,
    "minwithdraw": minwithdraw,
    "abiarray": List<dynamic>.from(abiarray!.map((x) => x)),
    "point_value": pointValue,
    "decimalvalue": decimalvalue,
    "netfee": netfee,
    "orderlist": orderlist,
    "url": url,
    "coinimage1": coinimage1,
    "coinimage2": coinimage2,
    "status": status,
    "_id": id,
    "image": image,
    "tradepair": tradepair,
    "coinname1": coinname1,
    "coinname2": coinname2,
    "chain":chain,
    "contractaddress": contractaddress,
    "market_asset": marketAsset,
    "base_asset": baseAsset,
    "networkList": List<dynamic>.from(networkList!.map((x) => x)),
  };
}

