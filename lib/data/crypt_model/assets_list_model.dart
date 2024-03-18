import 'dart:convert';

AssetsListModel assetsListModelFromJson(String str) => AssetsListModel.fromJson(json.decode(str));

String assetsListModelToJson(AssetsListModel data) => json.encode(data.toJson());

class AssetsListModel {
  bool? success;
  List<AssetsList>? result;
  String? message;

  AssetsListModel({
    this.success,
    this.result,
    this.message,
  });

  factory AssetsListModel.fromJson(Map<String, dynamic> json) => AssetsListModel(
    success: json["success"],
    result: List<AssetsList>.from(json["result"].map((x) => AssetsList.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class AssetsList {
  dynamic withdraw;
  dynamic maxwithdraw;
  dynamic minwithdraw;
  List<dynamic>? abiarray;
  dynamic pointValue;
  dynamic decimalvalue;
  dynamic netfee;
  dynamic orderlist;
  String? image;
  String? url;
  bool? status;
  String? id;
  String? symbol;
  String? coinname;
  dynamic chain;
  String? contractaddress;
  List<dynamic>? networkList;

  AssetsList({
    this.withdraw,
    this.maxwithdraw,
    this.minwithdraw,
    this.abiarray,
    this.pointValue,
    this.decimalvalue,
    this.netfee,
    this.orderlist,
    this.image,
    this.url,
    this.status,
    this.id,
    this.symbol,
    this.coinname,
    this.chain,
    this.contractaddress,
    this.networkList,
  });

  factory AssetsList.fromJson(Map<String, dynamic> json) => AssetsList(
    withdraw: json["withdraw"],
    maxwithdraw: json["maxwithdraw"],
    minwithdraw: json["minwithdraw"],
    abiarray: List<dynamic>.from(json["abiarray"].map((x) => x)),
    pointValue: json["point_value"],
    decimalvalue: json["decimalvalue"],
    netfee: json["netfee"],
    orderlist: json["orderlist"],
    image: json["image"],
    url: json["url"],
    status: json["status"],
    id: json["_id"],
    symbol: json["symbol"],
    coinname: json["coinname"],
    chain: json["chain"],
    contractaddress: json["contractaddress"],
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
    "image": image,
    "url": url,
    "status": status,
    "_id": id,
    "symbol": symbol,
    "coinname": coinname,
    "chain": chain,
    "contractaddress": contractaddress,
    "networkList": List<dynamic>.from(networkList!.map((x) => x)),
  };
}

