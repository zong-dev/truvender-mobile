import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:truvender/cubits/asset/asset_cubit.dart';
import 'package:truvender/cubits/trade/trade_cubit.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class FundTradePage extends StatefulWidget {
  final Fundz? asset;
  const FundTradePage({Key? key, this.asset}) : super(key: key);

  @override
  _FundTradePageState createState() => _FundTradePageState();
}

class _FundTradePageState extends State<FundTradePage> {
  String type = 'sell';

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      title: "${ucFirst(type)} ${ucFirst(widget.asset!.name)}",
      child: SingleChildScrollView(
        child: FundsTradeForm(
          asset: widget.asset,
          type: type,
        ),
      ),
    );
  }
}

class FundsTradeForm extends StatefulWidget {
  final String type;
  final Fundz? asset;
  const FundsTradeForm({Key? key, required this.type, required this.asset})
      : super(key: key);

  @override
  _FundsTradeFormState createState() => _FundsTradeFormState();
}

class _FundsTradeFormState extends State<FundsTradeForm> {
  late ValueNotifier<double> currentProgress;

  final TextEditingController _amountController =
      TextEditingController(text: '0');

  bool loading = true;

  openPreview() {
    Map<String, dynamic> data = {
      // "value": _valueController.text,
      "amount": double.parse(_amountController.text),
    };
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return FundsTradePreview(
          data: data,
          type: widget.type,
          asset: asset,
        );
      },
    );
  }

  getFundsData() {
    BlocProvider.of<AssetCubit>(context)
        .loadTradableFunds(id: widget.asset!.id);
  }

  late Fundz asset;
  final GlobalKey<FormState> tradeForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    currentProgress = ValueNotifier(20.0);
    setState(() => asset = widget.asset!);
    getFundsData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssetCubit, AssetState>(
      listener: (context, state) {
        if (state is AssetLoaded) {
          setState(() {
            asset = state.data;
            loading = false;
          });
        }
      },
      child: !loading
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 26),
              child: SingleChildScrollView(
                child: Form(
                  key: tradeForm,
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
                                imageUrl: asset.image,
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
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 12),
                        type: TextInputType.number,
                        bordered: true,
                        rules: MultiValidator([
                          RequiredValidator(errorText: "Amount is required"),
                          MinValueValidator(
                              double.parse(asset.minTradableAmount.toString()),
                              errorText:
                                  "Amount must be at least ${asset.minTradableAmount}"),
                          MaxValueValidator(
                              double.parse(asset.maxTradableAmount.toString()),
                              errorText:
                                  "Amount should not be more than ${asset.maxTradableAmount}"),
                        ]),
                        onChange: (_) {
                          if (tradeForm.currentState!.validate()) {
                            setState(() => currentProgress.value = 60);
                          }
                        },
                        iconPreffix: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 16),
                          child: Text(
                            asset.country!.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize: 14,
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      verticalSpacing(34),
                      currentProgress.value == 60
                          ? Button.primary(
                              onPressed: () => openPreview(),
                              background: AppColors.primary,
                              foreground: AppColors.secoundaryLight,
                              title: "Continue",
                            ).animate().fade(duration: 300.ms)
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            )
          : const LoadingWidget(),
    );
  }

  @override
  void dispose() {
    currentProgress.dispose();
    super.dispose();
  }
}

class FundsTradePreview extends StatefulWidget {
  final String type;
  final Fundz asset;
  final Map<String, dynamic> data;

  const FundsTradePreview(
      {Key? key, required this.type, required this.asset, required this.data})
      : super(key: key);

  @override
  _FundsTradePreviewState createState() => _FundsTradePreviewState();
}

class _FundsTradePreviewState extends State<FundsTradePreview> {
  double convertedAmount = 0;
  late String payableAccount;
  late User user;
  File? image;
  bool loading = false;
  submitTrade() {
    if (!loading) {
      BlocProvider.of<TradeCubit>(context).submitFundsTrade(
          asset: widget.asset.id,
          amount: widget.data['amount'],
          type: 'sell',
          rate: convertedAmount,
          country: widget.asset.country ?? "USD",
          payableAccount: payableAccount,
          image: image!);
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
            context.pushNamed('assets', queryParams: {"type": "funds"});
          } else {
            Navigator.pop(context);
          }
        });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      convertedAmount = widget.data['amount'] * widget.asset.rate;
      payableAccount = widget.asset.account!;
      user = BlocProvider.of<TradeCubit>(context).appBloc.authenticatedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TradeCubit, TradeState>(
      listener: (context, state) {
        if (state is PerformingTrade) {
          setState(() => loading = true);
        } else if (state is TradeSuccess) {
          setState(() {
            loading = false;
          });
          openStatusModal("success",
              "Trade was submitted successfully and awaiting confirmation ");
        } else if (state is TradeFailed) {
          setState(() {
            loading = false;
          });
          openStatusModal("error", state.message);
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
                                    imageUrl: widget.asset.image,
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
                                      widget.asset.name,
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
                              name: "Rate",
                              value:
                                  "${user.currency} ${moneyFormat(widget.asset.rate)} / ${widget.asset.country}"),
                          verticalSpacing(12),
                          KeyValue(
                              name: "Payable Account",
                              value: "${widget.asset.account}"),
                        ],
                      ),
                    ),
                    verticalSpacing(26),
                    TradeValueTile(
                      title: "You Get",
                      value: "${user.currency} ${moneyFormat(convertedAmount)}",
                    ),
                    verticalSpacing(26),
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color: AppColors.secoundaryLight,
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info,
                            color: AppColors.primary,
                            size: 30,
                          ),
                          horizontalSpacing(6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "To Continue, Transfer ${widget.asset.name} ${widget.asset.country} ${widget.data['amount']} to ${widget.asset.account} and upload a screenshot/reciept of your transaction below.",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    verticalSpacing(26),
                    Expanded(
                      child: FileUploader(
                        trigger: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10.0),
                          child:
                              UploadButton(title: "Upload Screenshot/Receipt"),
                        ),
                        label: "Upload Screenshot/Receipt",
                        isMultiple: false,
                        onSelected: (List files) {
                          setState(() {
                            image = File(files.first.path);
                          });
                        },
                      ),
                    ),
                    verticalSpacing(20),
                    image != null
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
