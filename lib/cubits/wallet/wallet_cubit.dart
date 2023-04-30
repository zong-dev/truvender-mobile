import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/data/repositories/repositories.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final AppBloc appBloc;
  WalletCubit({ required this.appBloc}) : super(WalletInitial());

  late WalletRepository walletRespository = WalletRepository(dioInstance: appBloc.dio);
  late ExchangeRepository exchangeRepository =  ExchangeRepository(dioInstance: appBloc.dio);

  Future<void> transfer({ required String email, required double amount }) async {
    emit(ProcessingTransaction());
    try {
      var request = await walletRespository.transfer(email: email, amount: amount);
      var transaction = Transaction.fromJson(request.data);
      emit(TransactionCompleted(transaction: transaction));
    } catch (e) {
      emit(TransactionFailed(message: e.toString()));
    }
  }

  Future<void> initiateFunding({ required double amount}) async {
    emit(ProcessingTransaction());
    try {
      var request = await walletRespository.initiateLocalFund(amount);
      emit(TransactionSuccess(response: request.data, isSubproccess: true));
    } catch (e) {
      emit(TransactionFailed(message: e.toString()));
    }
  }

  Future<void> completeFunding({ required String ref}) async {
    emit(ProcessingTransaction());
    try {
      var request = await walletRespository.completeLocalFund(ref);
      var transaction = Transaction.fromJson(request.data);
      emit(TransactionCompleted(transaction: transaction));
    } catch (e) {
      emit(const TransactionFailed(message: "Transaction failed"));
    }
  }

  Future<void> sendCrypto({
      required double amount,
      required String wallet,
      required String value,
      required String address
  }) async {
    emit(ProcessingTransaction());
    try {
      var request = await walletRespository.cryptoTransfer(amount: amount, value: value, wallet: wallet, address: address);
      emit(TransactionSuccess(response: request.data));
    } catch (e) {
      emit(TransactionFailed(message: e.toString()));
    }
  }

  Future<void> cryptoValue(
      {required double amount,
      required String currency,}) async {
    emit(ProcessingTransaction());
    try {
      var request = await exchangeRepository.getCryptoValue(
          amount: amount, currency: currency );
      emit(GottenCryptoValue(value: "${request.data}"));
    } catch (e) {
      emit(TransactionFailed(message: e.toString()));
    }
  }

  Future<void> withdraw({ required double amount}) async {
    emit(ProcessingTransaction());
    try {
      var request = await walletRespository.withdraw(amount: amount);
      emit(TransactionSuccess(response: request.data));
    } catch (e) {
      emit(TransactionFailed(message: e.toString()));
    }
  }

}
