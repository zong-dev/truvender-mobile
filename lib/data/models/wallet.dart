import 'package:equatable/equatable.dart';
import 'package:truvender/utils/utils.dart';

class Wallet extends Equatable {
  final String id;
  final int type;
  final double balance;
  final Asset? asset;
  final String currency;
  final String? address;

  const Wallet(
      {required this.id,
      required this.type,
      this.balance = 0,
      this.currency = "NGN",
      this.asset,
      this.address});

  @override
  List<Object?> get props => [
        id,
        type,
        balance,
        asset,
        address,
        currency,
      ];

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
        id: json['_id'],
        type: json['type'],
        balance: double.parse(json['balance'].toString()),
        asset: json['asset'],
        address: json['address'],
        currency: json['currency']);
  }

  String getFormattedAmount() {
      String currencySymbol = type == 0 ? getCurrencySymbol() : asset!.symbol;
      return "$currencySymbol $balance";
  }

  getCurrencySymbol() {
    Map<String, String> symbols = const {
      "NGN": "₦",
      "GHS": "₵",
      "ZAR": "R",
    };
    return symbols[currency];
  }
}

class Asset extends Equatable {
  final String name;
  final String symbol;
  final String icon;
  final String id;

  const Asset(
      {required this.id,
      required this.name,
      required this.symbol,
      required this.icon});

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
        name: json['name'],
        symbol: json['symbol'],
        icon: json['icon'],
        id: json['_id']);
  }

  @override
  List<Object?> get props => [name, symbol, icon];
}

class Transaction extends Equatable {
  final String id;
  final double amount;
  final String ref;
  final double fee;
  final String type;
  final String status;
  final String denomination;
  final String currency;
  final String createdAt;

  const Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.createdAt,
    required this.status,
    required this.ref,
    this.currency = "NGN",
    required this.fee,
    required this.denomination,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
        id: json['_id'],
        amount: double.parse(json['amount'].toString()),
        type: json['type'],
        createdAt: json['createdAt'],
        status: json['status'],
        ref: json['ref'],
        fee: double.parse(json['fee'].toString()),
        denomination: json['denomination']);
  }

  @override
  List<Object?> get props =>
      [id, amount, type, createdAt, status, fee, ref, denomination];
  get formatedAmount => "$currency ${moneyFormat(amount)}";
  get formatedFee => "$currency ${moneyFormat(fee)}";
  get date => formatDate(createdAt);
}
