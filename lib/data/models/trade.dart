import 'package:equatable/equatable.dart';
import 'package:truvender/utils/utils.dart';

class Trade extends Equatable {
  final String id;
  final double amount;
  final double localAmount;
  final String type;
  final String assetType;
  final String itemName;
  final double rate;
  final double localRate;
  final String status;
  final Map? metadata;
  final String createdAt;
  final String? currency;

  const Trade({
    required this.id,
    required this.amount,
    required this.type,
    required this.assetType,
    required this.itemName,
    required this.rate,
    required this.localRate,
    required this.status,
    required this.localAmount,
    this.metadata,
    this.currency = "NGN",
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    amount, id, status, assetType,
    type, itemName, rate, metadata, createdAt,
    currency,
  ];

  factory Trade.fromJson(Map<String, dynamic> json) {
    return Trade(
        id: json['_id'],
        amount: double.parse(json['amount'].toString()),
        type: json['type'],
        localAmount: json['localAmount'],
        assetType: json['assetType'],
        itemName: json['itemName'],
        rate: double.parse(json['rate'].toString()),
        localRate: double.parse(json['localRate'].toString()),
        status: json['status'],
        currency: json['currency'],
        createdAt: json['createdAt']);
  }

  get formatedAmount => "$currency ${moneyFormat(localAmount)}";
  get formatedRate => "$currency ${moneyFormat(localRate)}";
  get date => formatDate(createdAt);
}
