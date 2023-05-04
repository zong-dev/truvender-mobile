part of 'trade_cubit.dart';

abstract class TradeState extends Equatable {
  const TradeState();

  @override
  List<Object> get props => [];
}

class TradeInitial extends TradeState {}

class ConvertingRate extends TradeState {}

class RateConverted extends TradeState {
  final double rate;
  final bool isCryptoValue;
  const RateConverted({ required this.rate, this.isCryptoValue = false});
}

class PerformingTrade extends TradeState {}

class ProcessFailed extends TradeState {
  final String message;
  const ProcessFailed({ required this.message });
}

class WalletLoaded extends TradeState {
  final Wallet wallet;
  const WalletLoaded({required this.wallet});
  
  @override
  List<Object> get props => [wallet];
}

class TradeSuccess extends TradeState {
  final String type;
  final Trade trade;
  const TradeSuccess({ required this.type, required this.trade });

  @override
  List<Object> get props => [
    type, trade
  ];
}

class TradeFailed extends TradeState {
  final String type;
  final String message;
  const TradeFailed({ required this.type, required this.message });

  @override
  List<Object> get props => [
    type
  ];
}
