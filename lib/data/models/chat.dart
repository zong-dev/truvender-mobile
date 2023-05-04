import 'package:equatable/equatable.dart';
import 'package:truvender/utils/methods.dart';

class Message extends Equatable {
  final String id;
  final String type;
  final String chat;
  final String message;
  final String sender;
  final String createdAt;
  final bool isAnoucement;
  final int status;

  Message({
    required this.id,
    required this.type,
    required this.chat,
    required this.sender,
    required this.message,
    required this.createdAt,
    required this.isAnoucement,
    required this.status,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        id: json['_id'],
        type: json['type'],
        chat: json['chat'],
        sender: json['sender'],
        message: json['message'],
        createdAt: json['createdAt'],
        isAnoucement: json['isAnoucement'],
        status: json['status']);
  }

  @override
  List<Object?> get props => [
        id,
        type,
        chat,
        sender,
        message,
        createdAt,
        isAnoucement,
        status,
      ];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['type'] = type;
    data['chat'] = chat;
    data['sender'] = sender;
    data['message'] = message;
    data['createdAt'] = createdAt;
    data['isAnoucement'] = isAnoucement;
    data['status'] = status;
    return data;
  }


  get date => formatDate(createdAt);
}

class Chat extends Equatable {
  final String id;
  final String creator;
  final String member;
  final String topics;
  final bool isActive;

  Chat(
      {required this.id,
      required this.creator,
      required this.member,
      required this.topics,
      required this.isActive});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
        id: json['_id'],
        creator: json['creator'],
        member: json['member'],
        topics: json['topics'],
        isActive: json['isActive']);
  }

  @override
  List<Object?> get props => [
    id,
    creator,
    member,
    topics,
    isActive
  ];
}
