import 'dart:convert';

AmountTransferInternalModel amountTransferInternalModelFromJson(String str) => AmountTransferInternalModel.fromJson(json.decode(str));

String amountTransferInternalModelToJson(AmountTransferInternalModel data) => json.encode(data.toJson());

class AmountTransferInternalModel {
  bool? success;
  Result? result;
  String? message;

  AmountTransferInternalModel({
    this.success,
    this.result,
    this.message,
  });

  factory AmountTransferInternalModel.fromJson(Map<String, dynamic> json) => AmountTransferInternalModel(
    success: json["success"],
    result: Result.fromJson(json["result"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result!.toJson(),
    "message": message,
  };
}

class Result {
  String? coin;
  dynamic walletBalance;
  String? transferBalance;
  String? bonus;
  String? transferSafeAmount;
  String? ltvTransferSafeAmount;

  Result({
    this.coin,
    this.walletBalance,
    this.transferBalance,
    this.bonus,
    this.transferSafeAmount,
    this.ltvTransferSafeAmount,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    coin: json["coin"],
    walletBalance: json["walletBalance"],
    transferBalance: json["transferBalance"],
    bonus: json["bonus"],
    transferSafeAmount: json["transferSafeAmount"],
    ltvTransferSafeAmount: json["ltvTransferSafeAmount"],
  );

  Map<String, dynamic> toJson() => {
    "coin": coin,
    "walletBalance": walletBalance,
    "transferBalance": transferBalance,
    "bonus": bonus,
    "transferSafeAmount": transferSafeAmount,
    "ltvTransferSafeAmount": ltvTransferSafeAmount,
  };
}
