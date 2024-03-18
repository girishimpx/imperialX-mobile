import 'dart:convert';

FutureTradePairListModel futureTradePairListModelFromJson(String str) => FutureTradePairListModel.fromJson(json.decode(str));

String futureTradePairListModelToJson(FutureTradePairListModel data) => json.encode(data.toJson());

class FutureTradePairListModel {
  bool? success;
  List<FutureTradePairList>? result;
  String? message;

  FutureTradePairListModel({
    this.success,
    this.result,
    this.message,
  });

  factory FutureTradePairListModel.fromJson(Map<String, dynamic> json) => FutureTradePairListModel(
    success: json["success"],
    result: List<FutureTradePairList>.from(json["result"].map((x) => FutureTradePairList.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class FutureTradePairList {
  String? id;
  List<FutureTradePair>? data;
  DateTime? createdAt;
  DateTime? updatedAt;

  FutureTradePairList({
    this.id,
    this.data,
    this.createdAt,
    this.updatedAt,
  });

  factory FutureTradePairList.fromJson(Map<String, dynamic> json) => FutureTradePairList(
    id: json["_id"],
    data: List<FutureTradePair>.from(json["data"].map((x) => FutureTradePair.fromJson(x))),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}

class FutureTradePair {
  String? id;
  dynamic instType;
  String? instId;
  String? last;
  dynamic alias;
  String? lever;
  dynamic instFamily;
  String? image;

  FutureTradePair({
    this.id,
    this.instType,
    this.instId,
    this.last,
    this.alias,
    this.lever,
    this.instFamily,
    this.image,
  });

  factory FutureTradePair.fromJson(Map<String, dynamic> json) => FutureTradePair(
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
    "instType":instType,
    "instId": instId,
    "last": last,
    "alias": alias,
    "lever": lever,
    "instFamily": instFamily,
    "image": image,
  };
}
