import 'dart:io';

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

class SpendingCardTradePage extends StatefulWidget {
  final Spending? card;
  const SpendingCardTradePage({Key? key, this.card}) : super(key: key);

  @override
  _SpendingCardTradePageState createState() => _SpendingCardTradePageState();
}

class _SpendingCardTradePageState extends State<SpendingCardTradePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SupendingTradeForm extends StatefulWidget {
  final Spending? asset;
  const SupendingTradeForm({Key? key, required this.asset}) : super(key: key);

  @override
  _SupendingTradeFormState createState() => _SupendingTradeFormState();
}

class _SupendingTradeFormState extends State<SupendingTradeForm> {
  final TextEditingController _amountController =
      TextEditingController(text: '0');

  late ValueNotifier<double> currentProgress;
  final GlobalKey<FormState> tradeForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    currentProgress = ValueNotifier(20.0);
  }

  openPreview() {
    Map<String, dynamic> data = {
      // "value": _valueController.text,
      "amount": double.parse(_amountController.text),
    };
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SpendingTradePreview(
          data: data,
          asset: widget.asset,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    width: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: widget.asset!.image,
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
                rules: MultiValidator([
                  RequiredValidator(errorText: "Amount is required"),
                  MinValueValidator(double.parse(widget.asset!.min.toString()),
                      errorText:
                          "Amount must be at least ${widget.asset!.min}"),
                ]),
                onChange: (_) {
                  if (tradeForm.currentState!.validate()) {
                    setState(() => currentProgress.value = 60);
                  } else {
                    setState(() => currentProgress.value = 40);
                  }
                },
                iconPreffix: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  child: Text(
                    widget.asset!.country.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
    );
  }
}

class SpendingTradePreview extends StatefulWidget {
  final Spending? asset;
  final Map data;
  const SpendingTradePreview(
      {Key? key, required this.asset, required this.data})
      : super(key: key);

  @override
  _SpendingTradePreviewState createState() => _SpendingTradePreviewState();
}

class _SpendingTradePreviewState extends State<SpendingTradePreview> {
  bool loading = false;
  double convertedRate = 0;
  late User user;
  File? frontImage;
  File? reciept;
  File? backImage;

  convertRate() {
    BlocProvider.of<TradeCubit>(context).convertRateToLocalCurrency(rate: widget.data['amount'] * widget.asset!.rate);
  }

  @override
  void initState() {
    super.initState();
    convertRate();
    setState(() {
      user = BlocProvider.of<TradeCubit>(context).appBloc.authenticatedUser;
    });
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


  submitTrade() {}
  @override
  Widget build(BuildContext context) {
    return BlocListener<TradeCubit, TradeState>(
      listener: (context, state) {
        if(state is RateConverted){
          setState(() {
            loading = false;
            convertedRate = state.rate;
          }); 
        }else if (state is TradeSuccess) {
           setState(() {
            loading = false;
          }); 
          openStatusModal("success", "Trade was submitted successfully and awaiting confirmation");
        } else if (state is TradeFailed) {
          setState(() {
            loading = false;
          });
          openStatusModal("error", state.message);
        }
      },
      child: AppWrapper(
        child: loading
            ? const LoadingWidget(
                text: "Please wait...",
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 72,
                              width: 148,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: widget.asset!.image,
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "${widget.asset!.name} }",
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
                                    ucFirst(widget.asset!.country),
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
                            name: "Amount",
                            value:
                                "${widget.asset!.country} ${widget.data['amount']}"),
                        verticalSpacing(12),
                        KeyValue(
                            name: "Rate",
                            value:
                                "${user.currency} ${moneyFormat(convertedRate / widget.data['amount'])}"),
                      ]),
                    ),
                    verticalSpacing(26),
                    TradeValueTile(
                        title: "You Get",
                        value:
                            "${user.currency} ${moneyFormat(convertedRate)}"),
                    verticalSpacing(26),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                FileUploader(
                                  trigger: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 10.0),
                                    child: UploadButton(
                                        title: "Upload Card Front Image"),
                                  ),
                                  label: "Upload Card Front Image",
                                  isMultiple: false,
                                  onSelected: (List files) {
                                    setState(() {
                                      frontImage = File(files.first.path);
                                    });
                                  },
                                ),
                                FileUploader(
                                  trigger: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 10.0),
                                    child: UploadButton(
                                        title: "Upload Card Back Image"),
                                  ),
                                  label: "Upload Card Back Image",
                                  isMultiple: false,
                                  onSelected: (List files) {
                                    setState(() {
                                      frontImage = File(files.first.path);
                                    });
                                  },
                                ),
                                FileUploader(
                                  trigger: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 10.0),
                                    child: UploadButton(
                                        title: "Upload Card Reciept"),
                                  ),
                                  label: "Upload Card Reciept",
                                  isMultiple: false,
                                  onSelected: (List files) {
                                    setState(() {
                                      frontImage = File(files.first.path);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                    verticalSpacing(20),
                    frontImage != null && backImage != null && reciept != null
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
              ),
      ),
    );
  }
}
