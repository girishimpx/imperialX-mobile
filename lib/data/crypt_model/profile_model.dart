import 'dart:convert';

GetProfileModel getProfileModelFromJson(String str) => GetProfileModel.fromJson(json.decode(str));

String getProfileModelToJson(GetProfileModel data) => json.encode(data.toJson());

class GetProfileModel {
  bool? success;
  GetProfileResult? result;
  String? message;

  GetProfileModel({
    this.success,
    this.result,
    this.message,
  });

  factory GetProfileModel.fromJson(Map<String, dynamic> json) => GetProfileModel(
    success: json["success"],
    result: json["result"]=="null"|| json["result"]==null?GetProfileResult():GetProfileResult.fromJson(json["result"]),
    message: json["message"],
  );


  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result!.toJson(),
    "message": message,
  };
}

class GetProfileResult {
  dynamic referalMoney;
  String? twofa;
  String? signupType;
  bool? kycVerify;
  String? f2AStatus;
  String? role;
  String? verified;
  String? isgoogle;
  String? ispaid;
  String? issubscribed;
  String? blockReason;
  String? emailVerify;
  String? emailOtp;
  String? forgotOtp;
  String? traderType;
  bool? suspend;
  String? id;
  String? name;
  String? email;
  String? referralCode;
  String? verification;
  DateTime? createdAt;
  DateTime? updatedAt;

  GetProfileResult({
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
    this.id,
    this.name,
    this.email,
    this.referralCode,
    this.verification,
    this.createdAt,
    this.updatedAt,
  });

  factory GetProfileResult.fromJson(Map<String, dynamic> json) => GetProfileResult(
    referalMoney: json["referal_money"],
    twofa: json["twofa"]=="null" || json["twofa"]== null ? "-":json["twofa"],
    signupType: json["signup_type"]== "null" || json["signup_type"]==null ? "-":json["signup_type"],
    kycVerify: json["kyc_verify"],
    f2AStatus: json["f2A_Status"],
    role: json["role"],
    verified: json["verified"],
    isgoogle: json["isgoogle"],
    ispaid: json["ispaid"],
    issubscribed: json["issubscribed"],
    blockReason: json["block_reason"],
    emailVerify: json["email_verify"],
    emailOtp: json["email_otp"],
    forgotOtp: json["forgotOtp"],
    traderType: json["trader_type"],
    suspend: json["suspend"],
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    referralCode: json["referral_code"],
    verification: json["verification"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "referal_money": referalMoney,
    "twofa": twofa,
    "signup_type": signupType,
    "kyc_verify": kycVerify,
    "f2A_Status": f2AStatus,
    "role": role,
    "verified": verified,
    "isgoogle": isgoogle,
    "ispaid": ispaid,
    "issubscribed": issubscribed,
    "block_reason": blockReason,
    "email_verify": emailVerify,
    "email_otp": emailOtp,
    "forgotOtp": forgotOtp,
    "trader_type": traderType,
    "suspend": suspend,
    "_id": id,
    "name": name,
    "email": email,
    "referral_code": referralCode,
    "verification": verification,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
  };
}
