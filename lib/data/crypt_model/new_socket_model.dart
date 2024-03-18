

class NewSocket {
  dynamic instType;
  dynamic instId;
  dynamic last;
  dynamic lastSz;
  dynamic askPx;
  dynamic askSz;
  dynamic bidPx;
  dynamic bidSz;
  dynamic open24H;
  dynamic high24H;
  dynamic low24H;
  dynamic sodUtc0;
  dynamic sodUtc8;
  dynamic volCcy24H;
  dynamic vol24H;
  dynamic ts;

  NewSocket({
    this.instType,
    this.instId,
    this.last,
    this.lastSz,
    this.askPx,
    this.askSz,
    this.bidPx,
    this.bidSz,
    this.open24H,
    this.high24H,
    this.low24H,
    this.sodUtc0,
    this.sodUtc8,
    this.volCcy24H,
    this.vol24H,
    this.ts,
  });

  factory NewSocket.fromJson(Map<String, dynamic> json) => NewSocket(
    instType: json["instType"],
    instId: json["instId"],
    last: json["last"],
    lastSz: json["lastSz"],
    askPx: json["askPx"],
    askSz: json["askSz"],
    bidPx: json["bidPx"],
    bidSz: json["bidSz"],
    open24H: json["open24h"],
    high24H: json["high24h"],
    low24H: json["low24h"],
    sodUtc0: json["sodUtc0"],
    sodUtc8: json["sodUtc8"],
    volCcy24H: json["volCcy24h"],
    vol24H: json["vol24h"],
    ts: json["ts"],
  );

  Map<String, dynamic> toJson() => {
    "instType": instType,
    "instId": instId,
    "last": last,
    "lastSz": lastSz,
    "askPx": askPx,
    "askSz": askSz,
    "bidPx": bidPx,
    "bidSz": bidSz,
    "open24h": open24H,
    "high24h": high24H,
    "low24h": low24H,
    "sodUtc0": sodUtc0,
    "sodUtc8": sodUtc8,
    "volCcy24h": volCcy24H,
    "vol24h": vol24H,
    "ts": ts,
  };
}
