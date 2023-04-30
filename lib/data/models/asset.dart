import 'package:equatable/equatable.dart';

class Giftcard extends Equatable {
  String id;
  String name;
  String image;
  bool isAvailable;
  List? types;
  List? defaultRates;
  String? acceptedCode;

  Giftcard({
    required this.id,
    required this.name,
    required this.image,
    required this.isAvailable,
    required this.types,
    required this.defaultRates,
    required this.acceptedCode,
  });

  @override
  List<Object?> get props => [
        name,
        image,
        isAvailable,
        types,
        defaultRates,
        acceptedCode,
      ];

  factory Giftcard.fromJson(Map<String, dynamic> json) {
    return Giftcard(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
      isAvailable: json['isAvailable'],
      types: json['types'],
      defaultRates: json['defaultRates'],
      acceptedCode: json['acceptedCode'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['isAvailable'] = isAvailable;
    data['types'] = types;
    data['defaultRates'] = defaultRates;
    data['acceptedCode'] = acceptedCode;

    return data;
  }
}

class Crypto extends Equatable {
  String id;
  String name;
  String icon;
  String symbol;
  bool available;
  int? buyerRate;
  int? sellerRate;
  List<Map<String, dynamic>>? wallets;
  double? txFee;

  Crypto({
    required this.id,
    required this.name,
    required this.icon,
    required this.available,
    this.sellerRate,
    this.buyerRate,
    this.wallets,
    this.txFee,
    required this.symbol,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        icon,
        symbol,
        available,
        buyerRate,
        sellerRate,
        wallets,
      ];

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      id: json['_id'],
      name: json['name'],
      icon: json['icon'],
      symbol: json['symbol'],
      available: json['available'],
      buyerRate: json['buyerRate'],
      sellerRate: json['sellerRate'],
      wallets: json['wallets'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['icon'] = icon;
    data['symbol'] = symbol;
    data['available'] = available;
    data['buyerRate'] = buyerRate;
    data['sellerRate'] = sellerRate;
    data['wallets'] = wallets;
    return data;
  }
}

class Spending extends Equatable {
  String id;
  String name;
  String image;
  bool isAvailable;
  double min;
  double rate;
  String country;

  String? acceptableDigits;

  Spending(
      {required this.id,
      required this.name,
      required this.image,
      required this.isAvailable,
      required this.min,
      required this.rate,
      required this.country,
      this.acceptableDigits});

  @override
  List<Object?> get props =>
      [id, name, image, isAvailable, min, rate, country, acceptableDigits];

  factory Spending.fromJson(Map<String, dynamic> json) {
    return Spending(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
      isAvailable: json['isAvailble'],
      min: json['min'],
      rate: json['rate'],
      acceptableDigits: json['acceptableDigits'], country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['isAvailable'] = isAvailable;
    data['min'] = min;
    data['rate'] = rate;
    data['acceptableDigits'] = acceptableDigits;

    return data;
  }
}

class Fundz extends Equatable {
  String id;
  String name;
  String description;
  String image;
  bool isAvailable;
  double rate;
  double? minTradableAmount;
  double? maxTradableAmount;
  List<String>? countries;
  List<String>? accounts;

  Fundz(
      {required this.id,
      required this.name,
      required this.description,
      required this.image,
      required this.isAvailable,
      required this.rate,
      this.countries,
      this.accounts,
      this.minTradableAmount = 10,
      this.maxTradableAmount = 0});

  @override
  List<Object?> get props => [
        name,
        description,
        image,
        isAvailable,
        rate,
        countries,
        accounts,
        minTradableAmount
      ];

  factory Fundz.fromJson(Map<String, dynamic> json) {
    return Fundz(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
      isAvailable: json['isAvailble'],
      description: json['description'],
      rate: json['rate'],
      countries: json['countries'],
      accounts: json['accounts'],
      minTradableAmount: json['minTradableAmount'],
      maxTradableAmount: json['maxTradableAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['isAvailable'] = isAvailable;
    data['description'] = description;
    data['rate'] = rate;
    data['countries'] = countries;
    data['accounts'] = accounts;
    data['minTradableAmount'] = minTradableAmount;
    data['maxTradableAmount'] = maxTradableAmount;

    return data;
  }
}
