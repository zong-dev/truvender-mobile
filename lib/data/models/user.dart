// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

class User extends Equatable {
  String id;
  String? email;
  String? username;
  String? phone;
  String? avatar;
  List<dynamic>? role;
  String? email_verified_at;
  String? phone_verified_at;
  bool? has_verify_otp;
  bool requireOtp;
  String? currency;
  String country;

  int notifyType;

  double? txLimit;
  String? kycStatus;
  bool? verified;
  bool hasPin;
  String? lastLogin;
  Map<String, dynamic>? withdrawAccount;
  Map<String, dynamic>? banking;
  double dailyTxLimit;

  User({
    required this.id,
    this.email,
    this.username,
    this.phone,
    this.avatar,
    this.country = 'NG',
    this.role,
    this.notifyType = 2,
    this.email_verified_at,
    this.phone_verified_at,
    this.has_verify_otp,
    this.kycStatus,
    this.verified,
    this.lastLogin,
    this.txLimit,
    this.currency = "NGN",
    this.dailyTxLimit = 0.0,
    this.hasPin = false,
    this.requireOtp = false,
    this.withdrawAccount ,
    this.banking,
  });

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        avatar,
        phone,
        role,
        email_verified_at,
        phone_verified_at,
        has_verify_otp,
        kycStatus,
        verified,
        lastLogin,
        currency,
        txLimit,
        dailyTxLimit,
        requireOtp,
        hasPin,
        country,
        notifyType,
        withdrawAccount,
        banking,
      ];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      email: json['email'],
      username: json['username'],
      phone: json['phone'],
      role: json['role'],
      avatar: json['avatar'],
      txLimit: double.parse(json['txLimit'].toString()),
      dailyTxLimit: double.parse(json['dailyTxLimit'].toString()),
      email_verified_at: json['email_verified_at'],
      phone_verified_at: json['phone_verified_at'],
      has_verify_otp: json['has_verify_otp'],
      kycStatus: json['kycStatus'],
      verified: json['verified'],
      lastLogin: json['lastLogin'],
      currency: json['currency'],
      requireOtp: json['requireOtp'] ?? false,
      hasPin: json['hasPin'] ?? false,
      notifyType: json['notifyType'] ?? 2,
      withdrawAccount: json['withdrawAccount'],
      banking: json['banking'],
      country: json['country'] ?? 'NG',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['email'] = email;
    data['phone'] = phone;
    data['username'] = username;
    data['avatar'] = avatar;
    data['role'] = role;
    data['email_verified_at'] = email_verified_at;
    data['phone_verified_at'] = phone_verified_at;
    data['has_verify_otp'] = has_verify_otp;
    data['kycStatus'] = kycStatus;
    data['verified'] = verified;
    data['lastLogin'] = lastLogin;
    data['txLimit'] = txLimit;
    data['currency'] = currency;
    data['requireOtp'] = requireOtp;
    data['hasPin'] = hasPin;
    data['country'] = country;
    data['notifyType'] = notifyType;
    data['withdrawAccount'] = withdrawAccount;
    data['banking'] = banking;
    return data;
  }

  User copyWith({
    String? id,
    String? email,
    String? username,
    String? phone,
    String? avatar,
    List<String>? role,
    String? email_verified_at,
    String? phone_verified_at,
    bool? has_verify_otp,
    double? txLimit,
    String? kycStatus,
    bool? verified,
    bool? hasPin,
    String? lastLogin,
    int? notifyType,
    String? country,
    Map<String, dynamic>? withdrawAccount,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      email_verified_at: email_verified_at ?? this.email_verified_at,
      phone_verified_at: phone_verified_at ?? this.phone_verified_at,
      has_verify_otp: has_verify_otp ?? this.has_verify_otp,
      txLimit: txLimit ?? this.txLimit,
      dailyTxLimit: dailyTxLimit,
      country: country ?? this.country,
      kycStatus: kycStatus ?? this.kycStatus,
      verified: verified ?? this.verified,
      lastLogin: lastLogin ?? this.lastLogin,
      hasPin: hasPin ?? this.hasPin,
      notifyType: notifyType ?? this.notifyType,
      withdrawAccount: withdrawAccount ?? this.withdrawAccount,
      banking: banking ?? this.banking,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, username: $username, phone: $phone, avatar: $avatar, role: $role, email_verified_at: $email_verified_at, phone_verified_at: $phone_verified_at, has_verify_otp: $has_verify_otp, txLimit: $txLimit, kycStatus: $kycStatus, verified: $verified, lastLogin: $lastLogin, notifyType: $notifyType, withdrawAccount: $withdrawAccount)';
  }
}
