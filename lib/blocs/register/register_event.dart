part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class SignupFormSubmitted extends RegisterEvent {
  final String username;
  final String email;
  final String password;
  final String referrer;
  final String phone;
  final String? country;
  final String? currency;

  const SignupFormSubmitted(
      {required this.username,
      required this.email,
      this.currency,
      this.country,
      required this.password,
      this.referrer = '',
      required this.phone});

  @override
  List<Object> get props => [username, email, password, referrer, phone];

  @override
  String toString() {
    return 'SignupSubmitted { username: $username, password: $password, email: $email, phone: $phone, referrer: $referrer, country: $country, currency: $currency }';
  }
}

class SendVerificationCode extends RegisterEvent {
  final String type;
  final String ?sendTo;

  const SendVerificationCode({
    required this.type,
    required this.sendTo,
  });

  @override
  List<Object> get props => [type];

  @override
  String toString() {
    return 'SendVerificationCode { email: $type, token: $sendTo }';
  }
}

class AccountVerification extends RegisterEvent {
  final String type;
  final String token;

  const AccountVerification(
      {required this.type,
      required this.token});

  @override
  List<Object> get props => [type, token];

  @override
  String toString() {
    return 'EmailVerificationFormSubmited { email: $type, token: $token }';
  }
}
