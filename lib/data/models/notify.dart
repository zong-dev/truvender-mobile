import 'package:equatable/equatable.dart';

class Notify extends Equatable {
  final String id;
  final NotifyData data;
  final String createdAt;
  final String? readAt;

  const Notify({ required this.id, required this.data, required this.createdAt, required this.readAt});

  @override
  List<Object?> get props => [
    id, data, createdAt, readAt
  ];

}

class NotifyData extends Equatable {

  final String message;
  final String section;
  final String title;

  const NotifyData({required this.message, required this.section, required this.title});

  @override
  List<Object?> get props => [
    message, title, section
  ];
}