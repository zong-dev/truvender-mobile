part of 'bills_cubit.dart';

abstract class BillsState extends Equatable {
  const BillsState();

  @override
  List<Object> get props => [];
}

class BillsInitial extends BillsState {}


class WalletLoaded extends BillsState {
  final Wallet wallet;
  WalletLoaded({ required this.wallet});
  
  @override
  List<Object> get props => [wallet];
}

class RequestLoading extends BillsState {}

class BillRequestFailed extends BillsState {
  final String message;

  const BillRequestFailed({required this.message});

  @override
  List<Object> get props => [message];
}

class PaymentSuccess extends BillsState {
  final dynamic responseData;
  const PaymentSuccess({required this.responseData});

  @override
  List<Object> get props => [responseData];
}

class CustomerVerified extends BillsState {
  final Map customerData;

  const CustomerVerified({required this.customerData});

  @override
  List<Object> get props => [customerData];
}

class VerificationFailed extends BillsState {}


class VariationLoaded extends BillsState{
  final dynamic variations;

  VariationLoaded({required this.variations});

  @override
  // TODO: implement props
  List<Object> get props => [variations];

}