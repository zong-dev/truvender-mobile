import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/data/repositories/repositories.dart';

part 'asset_state.dart';

class AssetCubit extends Cubit<AssetState> {
  final AppBloc appBloc;

  AssetCubit({required this.appBloc}) : super(AssetInitial());

  late AssetRepository assetRepository =
      AssetRepository(dioInstance: appBloc.dio);

  Future<void> loadGiftcards({int page = 1, String? query}) async {
    emit(AssetLoading());
    try {
      var giftcards =
          await assetRepository.getGiftcards(page: page, query: query ?? '');
      var data = giftcards.data;
      var records =
          data['docs'].map((card) => Giftcard.fromJson(card)).toList();
      data['docs'] = records;
      emit(AssetLoaded(data: data));
    } catch (e) {
      emit(AssetLoadingFialed(error: e));
    }
  }

  Future<void> loadCrypos({String? id}) async {
    emit(AssetLoading());
    try {
      var cryptos = await assetRepository.getCryptoAssets(id);
      if (cryptos.status == 200) {
        var records = cryptos.data.map((crypto) => Crypto.fromJson(crypto));
        emit(AssetLoaded(data: records));
      }
    } catch (e) {
      emit(AssetLoadingFialed(error: e));
    }
  }

  Future<void> loadTradableFunds({String? id}) async {
    emit(AssetLoading());
    try {
      var funds = await assetRepository.getTradableFunds(id);
      if (id == null) {
        var records = funds.data.map((crypto) => Fundz.fromJson(crypto));
        emit(AssetLoaded(data: records));
      } else {
        emit(AssetLoaded(data: Fundz.fromJson(funds.data)));
      }
    } catch (e) {
      emit(AssetLoadingFialed(error: e));
    }
  }

  Future<void> loadSpendingCards({String? query, int page = 0}) async {
    emit(AssetLoading());
    try {
      var spendingCards = await assetRepository.getSpendingCards(
          query: query ?? '', page: page);
      if (spendingCards.status == 200) {
        var data = spendingCards.data;
        var records = data['docs'].map((crypto) => Spending.fromJson(crypto));
        data['docs'] = records;
        emit(AssetLoaded(data: data));
      }
      emit(AssetInitial());
    } catch (e) {
      emit(AssetLoadingFialed(error: e));
    }
  }

  Future<void> fetchCard({required String id, String? type}) async {
    emit(AssetLoading());
    try {
      var card = await assetRepository.getCardData(id: id, type: type ?? '');
      if (card.status == 200) {
        dynamic record;
        if (type == 'spending') {
          record = Spending.fromJson(card.data);
        } else {
          var giftcard = Giftcard.fromJson(card.data['giftcard']);
          record = {
            "card": giftcard,
            "rate": card.data['rates'],
          };
        }
        emit(AssetLoaded(data: record));
      }
    } catch (e) {
      emit(AssetLoadingFialed(error: e));
    }
  }
}
