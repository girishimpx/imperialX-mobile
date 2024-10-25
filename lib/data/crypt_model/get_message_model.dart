// To parse this JSON data, do
//
//     final getMessageModel = getMessageModelFromJson(jsonString);

import 'dart:convert';

GetMessageModel getMessageModelFromJson(String str) => GetMessageModel.fromJson(json.decode(str));

String getMessageModelToJson(GetMessageModel data) => json.encode(data.toJson());

class GetMessageModel {
  bool? success;
  List<MessageLists>? MessageList;
  String? message;

  GetMessageModel({
    this.success,
    this.MessageList,
    this.message,
  });

  factory GetMessageModel.fromJson(Map<String, dynamic> json) => GetMessageModel(
    success: json["success"],
    MessageList: json["result"] == null ? [] : List<MessageLists>.from(json["result"]!.map((x) => MessageLists.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "MessageLists": MessageLists == null ? [] : List<dynamic>.from(MessageList!.map((x) => x.toJson())),
    "message": message,
  };
}

class MessageLists {
  String? id;
  String? admin;
  String? userId;
  List<Query>? query;
  DateTime? createdAt;
  DateTime? updatedAt;

  MessageLists({
    this.id,
    this.admin,
    this.userId,
    this.query,
    this.createdAt,
    this.updatedAt,
  });

  factory MessageLists.fromJson(Map<String, dynamic> json) => MessageLists(
    id: json["_id"],
    admin: json["admin"],
    userId: json["user_id"],
    query: json["Query"] == null ? [] : List<Query>.from(json["Query"]!.map((x) => Query.fromJson(x))),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "admin": admin,
    "user_id": userId,
    "Query": query == null ? [] : List<dynamic>.from(query!.map((x) => x.toJson())),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class Query {
  String? id;
  String? author;
  String? message;
  String? time;

  Query({
    this.id,
    this.author,
    this.message,
    this.time,
  });

  factory Query.fromJson(Map<String, dynamic> json) => Query(
    id: json["_id"],
    author: json["author"],
    message: json["message"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "author": author,
    "message": message,
    "time": time,
  };
}
