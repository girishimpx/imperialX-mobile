import 'dart:convert';

CoinListModel coinListModelFromJson(String str) => CoinListModel.fromJson(json.decode(str));

String coinListModelToJson(CoinListModel data) => json.encode(data.toJson());

class CoinListModel {
  bool? success;
  List<CoinList>? result;
  String? message;

  CoinListModel({
    this.success,
    this.result,
    this.message,
  });

  factory CoinListModel.fromJson(Map<String, dynamic> json) => CoinListModel(
    success: json["success"],
    result: List<CoinList>.from(json["result"].map((x) => CoinList.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class CoinList {
  Id? id;
  CoinListData? data;
  DateTime? createdAt;
  DateTime? updatedAt;

  CoinList({
    this.id,
    this.data,
    this.createdAt,
    this.updatedAt,
  });

  factory CoinList.fromJson(Map<String, dynamic> json) => CoinList(
    id: idValues.map[json["_id"]],
    data: CoinListData.fromJson(json["data"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": idValues.reverse[id],
    "data": data!.toJson(),
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
  };
}

class CoinListData {
  String? id;
  InstType? instType;
  String? instId;
  String? last;
  Alias? alias;
  String? lever;
  InstFamily? instFamily;
  String? image;

  CoinListData({
    this.id,
    this.instType,
    this.instId,
    this.last,
    this.alias,
    this.lever,
    this.instFamily,
    this.image,
  });

  factory CoinListData.fromJson(Map<String, dynamic> json) => CoinListData(
    id: json["_id"],
    instType: instTypeValues.map[json["instType"]],
    instId: json["instId"],
    last: json["last"],
    alias: aliasValues.map[json["alias"]],
    lever: json["lever"],
    instFamily: instFamilyValues.map[json["instFamily"]],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "instType": instTypeValues.reverse[instType],
    "instId": instId,
    "last": last,
    "alias": aliasValues.reverse[alias],
    "lever": lever,
    "instFamily": instFamilyValues.reverse[instFamily],
    "image": image,
  };
}

enum Alias {
  EMPTY,
  NEXT_QUARTER,
  NEXT_WEEK,
  QUARTER,
  THIS_WEEK
}

final aliasValues = EnumValues({
  "": Alias.EMPTY,
  "next_quarter": Alias.NEXT_QUARTER,
  "next_week": Alias.NEXT_WEEK,
  "quarter": Alias.QUARTER,
  "this_week": Alias.THIS_WEEK
});

enum InstFamily {
  BTC_USDT,
  EMPTY,
  EOS_USDT,
  ETC_USDT,
  ETH_USDT,
  LTC_USDT,
  TRX_USDT,
  XRP_USDT
}

final instFamilyValues = EnumValues({
  "BTC-USDT": InstFamily.BTC_USDT,
  "": InstFamily.EMPTY,
  "EOS-USDT": InstFamily.EOS_USDT,
  "ETC-USDT": InstFamily.ETC_USDT,
  "ETH-USDT": InstFamily.ETH_USDT,
  "LTC-USDT": InstFamily.LTC_USDT,
  "TRX-USDT": InstFamily.TRX_USDT,
  "XRP-USDT": InstFamily.XRP_USDT
});

enum InstType {
  FUTURES,
  SPOT,
  SWAP
}

final instTypeValues = EnumValues({
  "FUTURES": InstType.FUTURES,
  "SPOT": InstType.SPOT,
  "SWAP": InstType.SWAP
});

enum Id {
  THE_64_C0_AEC1301409326_CAAA05_B
}

final idValues = EnumValues({
  "64c0aec1301409326caaa05b": Id.THE_64_C0_AEC1301409326_CAAA05_B
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
