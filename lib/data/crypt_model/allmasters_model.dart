import 'dart:convert';

GetAllMastersModel getAllMastersModelFromJson(String str) => GetAllMastersModel.fromJson(json.decode(str));

String getAllMastersModelToJson(GetAllMastersModel data) => json.encode(data.toJson());

class GetAllMastersModel {
  bool? success;
  List<GetAllMasters>? result;
  String? message;

  GetAllMastersModel({
    this.success,
    this.result,
    this.message,
  });

  factory GetAllMastersModel.fromJson(Map<String, dynamic> json) => GetAllMastersModel(
    success: json["success"],
    result: List<GetAllMasters>.from(json["result"].map((x) => GetAllMasters.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class GetAllMasters {
  Master? master;
  LastTrade? lastTrade;
  dynamic tradeList;

  GetAllMasters({
    this.master,
    this.lastTrade,
    this.tradeList,
  });

  factory GetAllMasters.fromJson(Map<String, dynamic> json) => GetAllMasters(
    master: json["master"]==null || json["master"]=="null" ? Master() : Master.fromJson(json["master"]),
    lastTrade: json["lastTrade"]==null|| json["lastTrade"]=="null" ? LastTrade() : LastTrade.fromJson(json["lastTrade"]),
    tradeList: json["tradeList"],
  );

  Map<String, dynamic> toJson() => {
    "master": master!.toJson(),
    "lastTrade": lastTrade!.toJson(),
    "tradeList": tradeList,
  };
}

class LastTrade {
  dynamic ouid;
  dynamic symbol;
  dynamic orderId;
  dynamic pair;
  dynamic orderType;
  dynamic price;
  dynamic volume;
  dynamic value;
  dynamic fees;
  dynamic commission;
  dynamic remaining;
  dynamic stoplimit;
  dynamic status;
  dynamic completedStatus;
  String? posId;
  String? tradeId;
  String? posStatus;
  String? priceperunit;
  dynamic leverage;
  String? marginAmount;
  String? marginRatio;
  dynamic convertPrice;
  dynamic loanAmount;
  dynamic id;
  dynamic userId;
  dynamic loanUserId;
  dynamic tradePairId;
  dynamic assetId;
  dynamic tradeType;
  dynamic tradeAt;
  dynamic entryPrice;
  dynamic tradeIn;
  String? createdAt;
  String? updatedAt;
  dynamic v;
  dynamic exitPrice;

  LastTrade({
    this.ouid,
    this.symbol,
    this.orderId,
    this.pair,
    this.orderType,
    this.price,
    this.volume,
    this.value,
    this.fees,
    this.commission,
    this.remaining,
    this.stoplimit,
    this.status,
    this.completedStatus,
    this.posId,
    this.tradeId,
    this.posStatus,
    this.priceperunit,
    this.leverage,
    this.marginAmount,
    this.marginRatio,
    this.convertPrice,
    this.loanAmount,
    this.id,
    this.userId,
    this.loanUserId,
    this.tradePairId,
    this.assetId,
    this.tradeType,
    this.tradeAt,
    this.entryPrice,
    this.tradeIn,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.exitPrice,
  });

  factory LastTrade.fromJson(Map<String, dynamic> json) => LastTrade(
    ouid: json["ouid"],
    symbol: json["symbol"],
    orderId: json["order_id"],
    pair: json["pair"],
    orderType: json["order_type"],
    price: json["price"],
    volume: json["volume"],
    value: json["value"],
    fees: json["fees"],
    commission: json["commission"],
    remaining: json["remaining"],
    stoplimit: json["stoplimit"],
    status: json["status"],
    completedStatus: json["completed_status"],
    posId: json["posId"],
    tradeId: json["tradeId"],
    posStatus: json["posStatus"],
    priceperunit: json["priceperunit"],
    leverage: json["leverage"],
    marginAmount: json["margin_amount"],
    marginRatio: json["margin_ratio"],
    convertPrice: json["convert_price"],
    loanAmount: json["loan_amount"],
    id: json["_id"],
    userId: json["user_id"],
    loanUserId: json["loan_user_id"],
    tradePairId: json["trade_pair_id"],
    assetId: json["asset_id"],
    tradeType: json["trade_type"],
    tradeAt: json["trade_at"],
    entryPrice: json["entry_price"],
    tradeIn:json["trade_in"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    v: json["__v"],
    exitPrice: json["exit_price"],
  );

  Map<String, dynamic> toJson() => {
    "ouid": ouid,
    "symbol": symbol,
    "order_id": orderId,
    "pair": pair,
    "order_type": orderType,
    "price": price,
    "volume": volume,
    "value": value,
    "fees": fees,
    "commission": commission,
    "remaining": remaining,
    "stoplimit": stoplimit,
    "status": status,
    "completed_status": completedStatus,
    "posId": posId,
    "tradeId": tradeId,
    "posStatus": posStatus,
    "priceperunit": priceperunit,
    "leverage": leverage,
    "margin_amount": marginAmount,
    "margin_ratio": marginRatio,
    "convert_price": convertPrice,
    "loan_amount": loanAmount,
    "_id": id,
    "user_id": userId,
    "loan_user_id": loanUserId,
    "trade_pair_id": tradePairId,
    "asset_id": assetId,
    "trade_type": tradeType,
    "trade_at": tradeAt,
    "entry_price": entryPrice,
    "trade_in": tradeIn,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "__v": v,
    "exit_price": exitPrice,
  };
}






class Master {
  dynamic referalMoney;
  SignupType? twofa;
  SignupType? signupType;
  bool? kycVerify;
  String? f2AStatus;
  Role? role;
  String? verified;
  String? isgoogle;
  String? ispaid;
  String? issubscribed;
  String? blockReason;
  String? emailVerify;
  String? emailOtp;
  String? forgotOtp;
  TraderType? traderType;
  bool? suspend;
  dynamic rating;
  String? id;
  String? email;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? referralCode;
  String? verification;

  Master({
    this.referalMoney,
    this.twofa,
    this.signupType,
    this.kycVerify,
    this.f2AStatus,
    this.role,
    this.verified,
    this.isgoogle,
    this.ispaid,
    this.issubscribed,
    this.blockReason,
    this.emailVerify,
    this.emailOtp,
    this.forgotOtp,
    this.traderType,
    this.suspend,
    this.rating,
    this.id,
    this.email,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.referralCode,
    this.verification,
  });

  factory Master.fromJson(Map<String, dynamic> json) => Master(
    referalMoney: json["referal_money"],
    twofa: signupTypeValues.map[json["twofa"]],
    signupType: signupTypeValues.map[json["signup_type"]],
    kycVerify: json["kyc_verify"],
    f2AStatus: json["f2A_Status"],
    role: roleValues.map[json["role"]],
    verified: json["verified"],
    isgoogle: json["isgoogle"],
    ispaid: json["ispaid"],
    issubscribed: json["issubscribed"],
    blockReason: json["block_reason"],
    emailVerify: json["email_verify"],
    emailOtp: json["email_otp"],
    forgotOtp: json["forgotOtp"],
    traderType: traderTypeValues.map[json["trader_type"]],
    suspend: json["suspend"],
    rating: json["rating"],
    id: json["_id"],
    email: json["email"],
    name: json["name"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    referralCode: json["referral_code"],
    verification: json["verification"],
  );

  Map<String, dynamic> toJson() => {
    "referal_money": referalMoney,
    "twofa": signupTypeValues.reverse[twofa],
    "signup_type": signupTypeValues.reverse[signupType],
    "kyc_verify": kycVerify,
    "f2A_Status": f2AStatus,
    "role": roleValues.reverse[role],
    "verified": verified,
    "isgoogle": isgoogle,
    "ispaid": ispaid,
    "issubscribed": issubscribed,
    "block_reason": blockReason,
    "email_verify": emailVerify,
    "email_otp": emailOtp,
    "forgotOtp": forgotOtp,
    "trader_type": traderTypeValues.reverse[traderType],
    "suspend": suspend,
    "rating": rating,
    "_id": id,
    "email": email,
    "name": name,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "referral_code": referralCode,
    "verification": verification,
  };
}

enum Role {
  USER
}

final roleValues = EnumValues({
  "user": Role.USER
});

enum SignupType {
  GMAIL,
  NULL
}

final signupTypeValues = EnumValues({
  "gmail": SignupType.GMAIL,
  "null": SignupType.NULL
});

enum TraderType {
  MASTER
}

final traderTypeValues = EnumValues({
  "master": TraderType.MASTER
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
