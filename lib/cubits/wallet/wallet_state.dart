part of 'wallet_cubit.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object> get props => [];
}

class WalletInitial extends WalletState {}

class TransactionCompleted extends WalletState {
  final Transaction transaction;
  const TransactionCompleted({ required this.transaction });

  @override
  List<Object> get props => [transaction];
}

class ProcessingTransaction extends WalletState {}

class TransactionFailed extends WalletState {
    final String message;
    
    const TransactionFailed({required this.message});

    @override
    List<Object> get props => [message];
}

class TransactionSuccess extends WalletState {
  final dynamic response;
  final bool isSubproccess;

  const TransactionSuccess({ this.response, this.isSubproccess = false });

  @override
  List<Object> get props => [ response ];
}


class GottenCryptoValue extends WalletState {
  final String value;
  const GottenCryptoValue({ required this.value });
  @override
  List<Object> get props => [value];
}
