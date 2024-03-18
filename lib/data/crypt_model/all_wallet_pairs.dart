import 'dart:convert';

GetWalletAllPairsModel getWalletAllPairsModelFromJson(String str) => GetWalletAllPairsModel.fromJson(json.decode(str));

String getWalletAllPairsModelToJson(GetWalletAllPairsModel data) => json.encode(data.toJson());

class GetWalletAllPairsModel {
  bool? success;
  List<GetWalletAll>? result;
  dynamic totalPriceInUsd;
  String? message;

  GetWalletAllPairsModel({
    this.success,
    this.result,
    this.totalPriceInUsd,
    this.message,
  });

  factory GetWalletAllPairsModel.fromJson(Map<String, dynamic> json) => GetWalletAllPairsModel(
    success: json["success"],
    result: json["result"]==null || json["result"]=="null"?[]:List<GetWalletAll>.from(json["result"].map((x) => GetWalletAll.fromJson(x))),
    totalPriceInUsd: json["total_price_in_usd"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "total_price_in_usd": totalPriceInUsd,
    "message": message,
  };
}

class GetWalletAll {
  dynamic balance;
  dynamic escrowBalance;
  String? symbol;
  String? entryBal;
  String? exitBal;
  List<MaxLoan>? maxLoan;
  List<Mugavari>? mugavari;
  String? id;
  UserId? userId;
  AssetId? assetId;
  DateTime? createdAt;
  DateTime? updatedAt;

  GetWalletAll({
    this.balance,
    this.escrowBalance,
    this.symbol,
    this.entryBal,
    this.exitBal,
    this.maxLoan,
    this.mugavari,
    this.id,
    this.userId,
    this.assetId,
    this.createdAt,
    this.updatedAt,
  });

  factory GetWalletAll.fromJson(Map<String, dynamic> json) => GetWalletAll(
    balance: json["balance"],
    escrowBalance: json["escrow_balance"],
    symbol: json["symbol"],
    entryBal: json["Entry_bal"],
    exitBal: json["Exit_bal"],
    maxLoan:json["max_loan"]==null|| json["max_loan"]=="null"?[]: List<MaxLoan>.from(json["max_loan"].map((x) => MaxLoan.fromJson(x))),
    mugavari:json["mugavari"]==null|| json["mugavari"]=="null"?[] :List<Mugavari>.from(json["mugavari"].map((x) => Mugavari.fromJson(x))),
    id: json["_id"],
    userId: userIdValues.map[json["user_id"]],
    assetId: AssetId.fromJson(json["asset_id"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "balance": balance,
    "escrow_balance": escrowBalance,
    "symbol": symbol,
    "Entry_bal": entryBal,
    "Exit_bal": exitBal,
    "max_loan": List<dynamic>.from(maxLoan!.map((x) => x.toJson())),
    "mugavari": List<dynamic>.from(mugavari!.map((x) => x.toJson())),
    "_id": id,
    "user_id": userIdValues.reverse[userId],
    "asset_id": assetId!.toJson(),
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
  };
}

class AssetId {
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
  Chain? chain;
  String? contractaddress;
  List<dynamic>? networkList;
  DateTime? createdAt;
  DateTime? updatedAt;

  AssetId({
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
    this.createdAt,
    this.updatedAt,
  });

  factory AssetId.fromJson(Map<String, dynamic> json) => AssetId(
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
    chain: chainValues.map[json["chain"]],
    contractaddress: json["contractaddress"],
    networkList: List<dynamic>.from(json["networkList"].map((x) => x)),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
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
    "chain": chainValues.reverse[chain],
    "contractaddress": contractaddress,
    "networkList": List<dynamic>.from(networkList!.map((x) => x)),
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
  };
}

enum Chain {
  COIN,
  FIAT
}

final chainValues = EnumValues({
  "coin": Chain.COIN,
  "fiat": Chain.FIAT
});

class MaxLoan {
  String? ccy;
  String? instId;
  String? maxLoan;
  MgnCcy? mgnCcy;
  MgnMode? mgnMode;
  Side? side;

  MaxLoan({
    this.ccy,
    this.instId,
    this.maxLoan,
    this.mgnCcy,
    this.mgnMode,
    this.side,
  });

  factory MaxLoan.fromJson(Map<String, dynamic> json) => MaxLoan(
    ccy: json["ccy"],
    instId: json["instId"],
    maxLoan: json["maxLoan"],
    mgnCcy: mgnCcyValues.map[json["mgnCcy"]],
    mgnMode: mgnModeValues.map[json["mgnMode"]],
    side: sideValues.map[json["side"]],
  );

  Map<String, dynamic> toJson() => {
    "ccy": ccy,
    "instId": instId,
    "maxLoan": maxLoan,
    "mgnCcy": mgnCcyValues.reverse[mgnCcy],
    "mgnMode": mgnModeValues.reverse[mgnMode],
    "side": sideValues.reverse[side],
  };
}

enum MgnCcy {
  USDT
}

final mgnCcyValues = EnumValues({
  "USDT": MgnCcy.USDT
});

enum MgnMode {
  CROSS
}

final mgnModeValues = EnumValues({
  "cross": MgnMode.CROSS
});

enum Side {
  BUY,
  SELL
}

final sideValues = EnumValues({
  "buy": Side.BUY,
  "sell": Side.SELL
});

class Mugavari {
  String? chain;
  String? ctAddr;
  String? ccy;
  String? to;
  String? addr;
  bool? selected;
  String? tag;
  String? memo;

  Mugavari({
    this.chain,
    this.ctAddr,
    this.ccy,
    this.to,
    this.addr,
    this.selected,
    this.tag,
    this.memo,
  });

  factory Mugavari.fromJson(Map<String, dynamic> json) => Mugavari(
    chain: json["chain"],
    ctAddr: json["ctAddr"],
    ccy: json["ccy"],
    to: json["to"],
    addr: json["addr"],
    selected: json["selected"],
    tag: json["tag"],
    memo: json["memo"],
  );

  Map<String, dynamic> toJson() => {
    "chain": chain,
    "ctAddr": ctAddr,
    "ccy": ccy,
    "to": to,
    "addr": addr,
    "selected": selected,
    "tag": tag,
    "memo": memo,
  };
}

enum UserId {
  THE_64_CA2_C9_BC7923_A34_BC463_B5_D
}

final userIdValues = EnumValues({
  "64ca2c9bc7923a34bc463b5d": UserId.THE_64_CA2_C9_BC7923_A34_BC463_B5_D
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
