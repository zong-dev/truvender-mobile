part of 'asset_cubit.dart';

abstract class AssetState extends Equatable {
  const AssetState();

  @override
  List<Object> get props => [];
}

class AssetInitial extends AssetState {}


class AssetLoading extends AssetState {}

class AssetLoaded extends AssetState {
  final dynamic data;

  const AssetLoaded({required this.data});

  @override
  List<Object> get props => [data];
}

class AssetLoadingFialed extends AssetState {
  final dynamic error;

  const AssetLoadingFialed({required this.error});

  @override
  List<Object> get props => [ error ];

}