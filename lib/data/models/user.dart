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

  int notifyType;

  num? txLimit;
  String? kycStatus;
  bool? verified;
  bool hasPin;
  String? lastLogin;
  Map<String, dynamic>? withdrawAccount;
  Map<String, dynamic>? banking;

  User({
    required this.id,
    this.email,
    this.username,
    this.phone,
    this.avatar,
    this.role,
    this.notifyType = 2,
    this.email_verified_at,
    this.phone_verified_at,
    this.has_verify_otp,
    this.kycStatus,
    this.verified,
    this.lastLogin,
    this.txLimit,
    this.currency,
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
        requireOtp,
        hasPin,
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
      email_verified_at: json['email_verified_at'],
      phone_verified_at: json['phone_verified_at'],
      has_verify_otp: json['has_verify_otp'],
      kycStatus: json['kycStatus'],
      verified: json['verified'],
      lastLogin: json['lastLogin'],
      txLimit: json['txLimit'],
      currency: json['currency'],
      requireOtp: json['requireOtp'],
      hasPin: json['hasPin'],
      notifyType: json['notifyType'],
      withdrawAccount: json['withdrawAccount'],
      banking: json['banking'],
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
    num? txLimit,
    String? kycStatus,
    bool? verified,
    bool? hasPin,
    String? lastLogin,
    int? notifyType,
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