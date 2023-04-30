import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:truvender/cubits/asset/asset_cubit.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class TradeGiftcardPage extends StatefulWidget {
  final Giftcard card;
  const TradeGiftcardPage({Key? key, required this.card}) : super(key: key);

  @override
  _TradeGiftcardPageState createState() => _TradeGiftcardPageState();
}

class _TradeGiftcardPageState extends State<TradeGiftcardPage> {
  late User user;
  late Giftcard asset;
  bool loading = true;
  String type = 'sell';

  openTypeModal() {
    openBottomSheet(
      context: context,
      child: TypeModal(
        label: ucFirst(asset.name),
        onSelect: (value) {
          setState(() => type = value);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AssetCubit>(context).fetchCard(id: widget.card.id);
    openTypeModal();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssetCubit, AssetState>(
      listener: (context, state) {
        if (state is AssetLoaded) {
          setState(() {
            loading = false;
            asset = state.data;
          });
        }
      },
      child: AppWrapper(
        child: !loading
            ? TradeForm(asset: asset, user: user, type: type)
            : const LoadingWidget(),
      ),
    );
  }
}

class TradeForm extends StatefulWidget {
  final String type;
  final Giftcard asset;
  final User user;
  TradeForm(
      {Key? key, required this.type, required this.asset, required this.user})
      : super(key: key);

  @override
  State<TradeForm> createState() => _TradeFormState();
}

class _TradeFormState extends State<TradeForm> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _denominationController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
