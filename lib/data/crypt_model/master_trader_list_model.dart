import 'dart:convert';

MasterTraderListModel masterTraderListModelFromJson(String str) => MasterTraderListModel.fromJson(json.decode(str));

String masterTraderListModelToJson(MasterTraderListModel data) => json.encode(data.toJson());

class MasterTraderListModel {
  bool? success;
  List<MasterTraderList>? result;
  String? message;

  MasterTraderListModel({
    this.success,
    this.result,
    this.message,
  });

  factory MasterTraderListModel.fromJson(Map<String, dynamic> json) => MasterTraderListModel(
    success: json["success"],
    result: List<MasterTraderList>.from(json["result"].map((x) => MasterTraderList.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class MasterTraderList {
  User? user;
  int? tradeList;

  MasterTraderList({
    this.user,
    this.tradeList,
  });

  factory MasterTraderList.fromJson(Map<String, dynamic> json) => MasterTraderList(
    user: User.fromJson(json["user"]),
    tradeList: json["tradeList"],
  );

  Map<String, dynamic> toJson() => {
    "user": user!.toJson(),
    "tradeList": tradeList,
  };
}

class User {
  String? referalMoney;
  String? twofa;
  bool? kycVerify;
  String? f2AStatus;
  String? role;
  String? verified;
  String? blockReason;
  String? emailVerify;
  String? emailOtp;
  String? forgotOtp;
  String? traderType;
  bool? suspend;
  String? id;
  String? email;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? isgoogle;
  String? referralCode;
  String? verification;
  String? referredByCode;
  String? referredById;

  User({
    this.referalMoney,
    this.twofa,
    this.kycVerify,
    this.f2AStatus,
    this.role,
    this.verified,
    this.blockReason,
    this.emailVerify,
    this.emailOtp,
    this.forgotOtp,
    this.traderType,
    this.suspend,
    this.id,
    this.email,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.isgoogle,
    this.referralCode,
    this.verification,
    this.referredByCode,
    this.referredById,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    referalMoney: json["referal_money"],
    twofa: json["twofa"],
    kycVerify: json["kyc_verify"],
    f2AStatus: json["f2A_Status"],
    role: json["role"],
    verified: json["verified"],
    blockReason: json["block_reason"],
    emailVerify: json["email_verify"],
    emailOtp: json["email_otp"],
    forgotOtp: json["forgotOtp"],
    traderType: json["trader_type"],
    suspend: json["suspend"],
    id: json["_id"],
    email: json["email"],
    name: json["name"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    isgoogle: json["isgoogle"],
    referralCode: json["referral_code"],
    verification: json["verification"],
    referredByCode: json["referred_by_code"],
    referredById: json["referred_by_id"],
  );

  Map<String, dynamic> toJson() => {
    "referal_money": referalMoney,
    "twofa": twofa,
    "kyc_verify": kycVerify,
    "f2A_Status": f2AStatus,
    "role": role,
    "verified": verified,
    "block_reason": blockReason,
    "email_verify": emailVerify,
    "email_otp": emailOtp,
    "forgotOtp": forgotOtp,
    "trader_type": traderType,
    "suspend": suspend,
    "_id": id,
    "email": email,
    "name": name,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "isgoogle": isgoogle,
    "referral_code": referralCode,
    "verification": verification,
    "referred_by_code": referredByCode,
    "referred_by_id": referredById,
  };
}
