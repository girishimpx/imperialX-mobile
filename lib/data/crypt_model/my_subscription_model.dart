import 'dart:convert';

SubscriptionDetailsModel subscriptionDetailsModelFromJson(String str) => SubscriptionDetailsModel.fromJson(json.decode(str));

String subscriptionDetailsModelToJson(SubscriptionDetailsModel data) => json.encode(data.toJson());

class SubscriptionDetailsModel {
  bool? success;
  List<SubscriptionDetails>? result;
  String? message;

  SubscriptionDetailsModel({
    this.success,
    this.result,
    this.message,
  });

  factory SubscriptionDetailsModel.fromJson(Map<String, dynamic> json) => SubscriptionDetailsModel(
    success: json["success"],
    result: List<SubscriptionDetails>.from(json["result"].map((x) => SubscriptionDetails.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class SubscriptionDetails {
  TradeBase? tradeBase;
  String? apikey;
  dynamic status;
  String? secretkey;
  String? apiName;
  String? permission;
  String? exchange;
  String? passphrase;
  dynamic subExpire;
  String? id;
  String? userId;
  List<FollowerUserId>? followerUserId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic v;

  SubscriptionDetails({
    this.tradeBase,
    this.apikey,
    this.status,
    this.secretkey,
    this.apiName,
    this.permission,
    this.exchange,
    this.passphrase,
    this.subExpire,
    this.id,
    this.userId,
    this.followerUserId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory SubscriptionDetails.fromJson(Map<String, dynamic> json) => SubscriptionDetails(
    tradeBase: TradeBase.fromJson(json["trade_base"]),
    apikey: json["apikey"],
    status: json["status"],
    secretkey: json["secretkey"],
    apiName: json["api_name"],
    permission: json["permission"],
    exchange: json["exchange"],
    passphrase: json["passphrase"],
    subExpire: json["sub_expire"],
    id: json["_id"],
    userId: json["user_id"],
    followerUserId: List<FollowerUserId>.from(json["follower_user_id"].map((x) => FollowerUserId.fromJson(x))),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "trade_base": tradeBase!.toJson(),
    "apikey": apikey,
    "status": status,
    "secretkey": secretkey,
    "api_name": apiName,
    "permission": permission,
    "exchange": exchange,
    "passphrase": passphrase,
    "sub_expire": subExpire,
    "_id": id,
    "user_id": userId,
    "follower_user_id": List<dynamic>.from(followerUserId!.map((x) => x.toJson())),
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
  };
}

class FollowerUserId {
  String? amount;
  String? id;
  String? followerId;

  FollowerUserId({
    this.amount,
    this.id,
    this.followerId,
  });

  factory FollowerUserId.fromJson(Map<String, dynamic> json) => FollowerUserId(
    amount: json["amount"],
    id: json["_id"],
    followerId: json["follower_id"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "_id": id,
    "follower_id": followerId,
  };
}

class TradeBase {
  bool? spot;
  bool? margin;
  bool? future;

  TradeBase({
    this.spot,
    this.margin,
    this.future,
  });

  factory TradeBase.fromJson(Map<String, dynamic> json) => TradeBase(
    spot: json["spot"],
    margin: json["margin"],
    future: json["future"],
  );

  Map<String, dynamic> toJson() => {
    "spot": spot,
    "margin": margin,
    "future": future,
  };
}
