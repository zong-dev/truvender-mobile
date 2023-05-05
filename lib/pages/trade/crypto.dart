import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:truvender/cubits/trade/trade_cubit.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class CryptoTradePage extends StatefulWidget {
  final Crypto? asset;
  const CryptoTradePage({Key? key, this.asset}) : super(key: key);

  @override
  _CryptoTradePageState createState() => _CryptoTradePageState();
}

class _CryptoTradePageState extends State<CryptoTradePage> {
  String type = '';

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      title: type.isEmpty ? "Trade Crypto" : "${ucFirst(type)} ${ucFirst(widget.asset!.name)}",
      child: SingleChildScrollView(
        child: type.isNotEmpty
            ? CryptoForm(
                asset: widget.asset,
                type: type,
              )
            : TypeModal(
                onSelect: (value) {
                  setState(() => type = value);
                },
                label: ucFirst(widget.asset!.name),
              ),
      ),
    );
  }
}

class CryptoForm extends StatefulWidget {
  final Crypto? asset;
  final String type;
  const CryptoForm({Key? key, required this.asset, required this.type})
      : super(key: key);

  @override
  _CryptoFormState createState() => _CryptoFormState();
}

class _CryptoFormState extends State<CryptoForm> {
  late ValueNotifier<double> currentProgress;

  final TextEditingController _valueController =
      TextEditingController(text: '0');
  final TextEditingController _amountController =
      TextEditingController(text: '0');
  bool loadingValue = false;


  @override
  void initState() {
    super.initState();
    currentProgress = ValueNotifier(20.0);
  }

  getCryptoValue() {
    setState(() {
      loadingValue = true;
      currentProgress.value = 40;
    });
    BlocProvider.of<TradeCubit>(context).cryptoValue(
        amount: double.parse(_amountController.text), asset: widget.asset!.id);
  }

  openPreview() {
    Map<String, dynamic> data = {
      "value": _valueController.text,
      "amount": _amountController.text,
    };
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Preview(
          data: data,
          type: widget.type,
          asset: widget.asset,
        );
      },
    );
  }

  final GlobalKey<FormState> cryptoForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<TradeCubit, TradeState>(
      listener: (context, state) {
        if (state is RateConverted) {
          if (state.isCryptoValue) {
            setState(() {
              _valueController.text = "${state.rate}";
              currentProgress.value = 60;
            });
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 26),
        child: SingleChildScrollView(
          child: Form(
            key: cryptoForm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 62,
                      width: 62,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          fit: BoxFit.contain,
                          imageUrl: widget.asset!.icon,
                          placeholder: (context, url) => const SizedBox(
                            height: 40,
                            width: 40,
                            child: LoadingWidget(),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                    SimpleCircularProgressBar(
                      progressStrokeWidth: 6,
                      backColor: AppColors.secoundaryLight,
                      valueNotifier: currentProgress,
                      mergeMode: true,
                      size: 40,
                      maxValue: 100,
                      backStrokeWidth: 6,
                      onGetText: (double value) {
                        return Text(
                          '${value.toInt()}%',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).accentColor),
                        );
                      },
                    ),
                  ],
                ),
                verticalSpacing(28),
                const InputLabel(text: "Amount"),
                TextInput(
                  label: "0.00",
                  controller: _amountController,
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                  type: TextInputType.number,
                  bordered: true,
                  onChange: (_) {
                    if (cryptoForm.currentState!.validate()) {
                      getCryptoValue();
                    }
                  },
                  rules: MultiValidator([
                      RequiredValidator(errorText: "Amount is required"),
                      MinValueValidator(10, errorText: "Amount must be at least 10"),
                    ]),
                  iconPreffix: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    child: Text(
                      "USD",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 14,
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                int.parse(_valueController.text) > 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 34),
                            child: Text(
                              _valueController.text,
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: .8,
                                  ),
                            ),
                          ),
                          Button.primary(
                            onPressed: () => openPreview(),
                            background: AppColors.primary,
                            foreground: AppColors.secoundaryLight,
                            title: "Continue",
                          ).animate().fade(duration: 300.ms)
                        ].animate(delay: 200.ms).fade(duration: 300.ms),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    currentProgress.dispose();
    super.dispose();
  }
}

class Preview extends StatefulWidget {
  final Map<String, dynamic> data;
  final Crypto? asset;
  final String type;
  const Preview(
      {Key? key, required this.asset, required this.data, required this.type})
      : super(key: key);

  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  late Wallet wallet;
  late User user;
  double rate = 0;
  double convertedAmount = 0;
  bool loading = true;

  calculateRate() {
    setState(() {
      rate = widget.type == 'sell'
          ? double.parse(widget.asset!.sellerRate.toString())
          : double.parse(widget.asset!.buyerRate.toString());
    });
    if (rate > 0 && user.currency!.toLowerCase() != 'ngn') {
      BlocProvider.of<TradeCubit>(context).convertRateToLocalCurrency(
          rate: double.parse(widget.data['amount'] * rate));
    } else {
      setState(() {
        convertedAmount = rate * widget.data['amount'];
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    user = BlocProvider.of<TradeCubit>(context).appBloc.authenticatedUser;
    if (widget.type == 'sell') {
      BlocProvider.of<TradeCubit>(context).getWallet(id: widget.asset!.id);
    } else {
      BlocProvider.of<TradeCubit>(context).getWallet();
    }
    calculateRate();
  }

  submitTrade() {
    if ((wallet.balance < double.parse(widget.data['value']) && widget.type == 'sell') ||
        (wallet.balance < convertedAmount && widget.type == 'buy')) {
      showStatus(
          type: "error",
          title: "Failed",
          subTitle: "Insufficient wallet balance",
          context: context);
    } else {
      BlocProvider.of<TradeCubit>(context).submitCryptoTrade(
          asset: widget.asset!.id,
          amount: widget.data['amount'],
          type: widget.type,
          rate: convertedAmount,
          value: widget.data['value']);
    }
  }

  openStatusModal(
    String type,
    String message,
  ) {
    showStatus(
      type: type,
      title: type == "success" ? "Success" : "Failed",
      subTitle: message,
      context: context,
      next: () {
        if (type == 'success') {
          context.pushNamed('assets', queryParams: {"type": "spending-card"});
        } else {
          Navigator.pop(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TradeCubit, TradeState>(
      listener: (context, state) {
        if (state is RateConverted) {
          setState(() {
            rate = state.rate / widget.data['amount'];
            convertedAmount = state.rate;
            loading = false;
          });
        } else if (state is WalletLoaded) {
          setState(() {
            wallet = state.wallet;
            loading = false;
          });
        } else if (state is PerformingTrade) {
          setState(() => loading = true);
        }else if(state is TradeFailed){
          setState(() => loading = false);
           openStatusModal("error",
             state.message);
        } else if (state is TradeSuccess) {
          setState(() {
            loading = false;
          });
          openStatusModal("success",
              "Trade was submitted successfully and awaiting confirmation");
        }
      },
      child: AppWrapper(
        child: !loading
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Preview",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            CupertinoIcons.xmark,
                            color: Theme.of(context).accentColor,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    verticalSpacing(24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 62,
                                width: 62,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.contain,
                                    imageUrl: widget.asset!.icon,
                                    placeholder: (context, url) =>
                                        const SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: LoadingWidget(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      widget.asset!.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color:
                                                  Theme.of(context).accentColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                    ),
                                    verticalSpacing(6),
                                    Text(
                                      "${widget.data['amount']} USD",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color:
                                                  Theme.of(context).accentColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          verticalSpacing(18),
                          KeyValue(
                              name: "Value", value: "${widget.data['value']}"),
                          verticalSpacing(12),
                          KeyValue(
                              name: "Rate",
                              value: "${user.currency} ${moneyFormat(rate)}"),
                        ],
                      ),
                    ),
                    verticalSpacing(26),
                    TradeValueTile(
                      title: widget.type == 'sell' ? "You Get" : "You Pay",
                      value: "${user.currency} ${moneyFormat(convertedAmount)}",
                    ),
                    verticalSpacing(26),
                    rate > 0
                        ? Button.primary(
                            onPressed: () => submitTrade(),
                            background: AppColors.primary,
                            foreground: AppColors.secoundaryLight,
                            title: "Submit Trade",
                          ).animate().fade(duration: 300.ms)
                        : const SizedBox(),
                    verticalSpacing(30),
                  ],
                ),
              )
            : const LoadingWidget(),
      ),
    );
  }
}
