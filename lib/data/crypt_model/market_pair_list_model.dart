import 'dart:convert';

MarketPairListModel marketPairListModelFromJson(String str) => MarketPairListModel.fromJson(json.decode(str));

String marketPairListModelToJson(MarketPairListModel data) => json.encode(data.toJson());

class MarketPairListModel {
  bool? success;
  List<MarketPairList>? result;
  String? message;

  MarketPairListModel({
    this.success,
    this.result,
    this.message,
  });

  factory MarketPairListModel.fromJson(Map<String, dynamic> json) => MarketPairListModel(
    success: json["success"],
    result: List<MarketPairList>.from(json["result"].map((x) => MarketPairList.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class MarketPairList {
  dynamic id;
  MarketPair? data;
  DateTime? createdAt;
  DateTime? updatedAt;

  MarketPairList({
    this.id,
    this.data,
    this.createdAt,
    this.updatedAt,
  });

  factory MarketPairList.fromJson(Map<String, dynamic> json) => MarketPairList(
    id: json["_id"],
    data: MarketPair.fromJson(json["data"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "data": data!.toJson(),
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}

class MarketPair {
  String? id;
  dynamic instType;
  String? instId;
  String? last;
  dynamic alias;
  String? lever;
  dynamic instFamily;
  String? image;

  MarketPair({
    this.id,
    this.instType,
    this.instId,
    this.last,
    this.alias,
    this.lever,
    this.instFamily,
    this.image,
  });

  factory MarketPair.fromJson(Map<String, dynamic> json) => MarketPair(
    id: json["_id"],
    instType: json["instType"],
    instId: json["instId"],
    last: json["last"],
    alias: json["alias"],
    lever: json["lever"],
    instFamily: json["instFamily"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "instType": instType,
    "instId": instId,
    "last": last,
    "alias": alias,
    "lever": lever,
    "instFamily":instFamily,
    "image": image,
  };
}



