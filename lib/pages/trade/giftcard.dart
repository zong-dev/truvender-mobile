import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:truvender/cubits/asset/asset_cubit.dart';
import 'package:truvender/cubits/trade/trade_cubit.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class TradeGiftcardPage extends StatefulWidget {
  final Giftcard? card;
  const TradeGiftcardPage({Key? key, this.card}) : super(key: key);

  @override
  _TradeGiftcardPageState createState() => _TradeGiftcardPageState();
}

class _TradeGiftcardPageState extends State<TradeGiftcardPage> {
  late User user;
  late Giftcard asset;
  bool loading = true;
  String type = '';
  List rates = [];

  @override
  void initState() {
    super.initState();
    user = BlocProvider.of<AppBloc>(context).authenticatedUser;
    BlocProvider.of<AssetCubit>(context).fetchCard(id: widget.card!.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssetCubit, AssetState>(
      listener: (context, state) {
        if (state is AssetLoaded) {
          setState(() {
            asset = state.data['giftcard'];
            rates = state.data['rates'];
            loading = false;
          });
        }
      },
      child: Wrapper(
        title: type.isEmpty
            ? "Trade Giftcard"
            : "${ucFirst(type)} ${ucFirst(widget.card!.name)}",
        child: !loading
            ? SingleChildScrollView(
                child: type.isNotEmpty
                    ? TradeForm(type: type, asset: asset, rates: rates)
                    : TypeModal(
                        label: ucFirst(asset.name),
                        onSelect: (value) {
                          setState(() => type = value);
                        },
                      ),
              )
            : const LoadingWidget(),
      ),
    );
  }
}

class TradeForm extends StatefulWidget {
  final String type;
  final Giftcard asset;
  final List rates;
  const TradeForm(
      {Key? key, required this.type, required this.asset, required this.rates})
      : super(key: key);

  @override
  State<TradeForm> createState() => _TradeFormState();
}

class _TradeFormState extends State<TradeForm> {
  late ValueNotifier<double> currentProgress;

  late Map type;
  // final TextEditingController _priceController = TextEditingController();
  final TextEditingController _valueController =
      TextEditingController(text: '0');
  final TextEditingController _amountController =
      TextEditingController(text: '0');
  final TextEditingController _currencyController = TextEditingController();

  Country selectedCountry = CountryPickerUtils.getCountryByIsoCode('US');

  List types = [];

  Map? selectedType;
  @override
  void initState() {
    super.initState();
    currentProgress = ValueNotifier(20.0);
    _currencyController.text = 'USD';

    setState(() {
      types = widget.asset.types!
          .where((cType) =>
              cType['isAvailable'] != null && cType['isAvailable'] == true)
          .toList();
    });
  }

  openCardValueModal() {
    openBottomSheet(
      context: context,
      child: CardValueModal(
        values: selectedType!['prices'] ?? [],
        asset: widget.asset,
        currentAmount: int.parse(_amountController.text),
        price: int.parse(_valueController.text),
        onSelect: (int amount, int price) {
          setState(() {
            _amountController.text = amount.toString();
            _valueController.text = price.toString();
            currentProgress.value = 60;
          });
        },
      ),
      height: MediaQuery.of(context).size.height / 1.6,
      label: "Giftcard Values",
      radius: 6,
    );
  }

  openTradeModal() {
    Map<String, dynamic> data = {
      "type": selectedType,
      "value": _valueController.text,
      "amount": _amountController.text,
      "currency": _currencyController.text,
    };
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return TradePreview(
            data: data,
            type: widget.type,
            rates: widget.rates,
            asset: widget.asset);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 26),
      child: SingleChildScrollView(
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
                      imageUrl: widget.asset.image,
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
            const InputLabel(text: "Select Country"),
            CountryPicker(
              triger: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.textFaded,
                    width: 1.4,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: _currencyController.text.isNotEmpty ? 14 : 18),
                child: _currencyController.text.isNotEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _currencyController.text.isNotEmpty
                                  ? CountryPickerUtils.getDefaultFlagImage(
                                      selectedCountry)
                                  : const SizedBox(),
                              horizontalSpacing(8),
                              Text(
                                _currencyController.text.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 22,
                            color: Theme.of(context).accentColor,
                          )
                        ],
                      )
                    : Text(
                        "Select Country",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.textFaded,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
              ),
              onPicked: (Country country) {
                setState(() {
                  selectedCountry = country;
                  _currencyController.text = country.iso3Code!.toUpperCase();
                  _currencyController.text =
                      country.currencyCode!.toUpperCase();
                });
              },
              selectedCountry: selectedCountry,
            ),
            verticalSpacing(28),
            const InputLabel(text: "Pick Card Type"),
            SizedBox(
              height: 50,
              child: ListView.builder(
                  itemCount: types.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var cardType = types[index];
                    return GestureDetector(
                      onTap: () => setState(() {
                        selectedType = cardType;
                        _amountController.text = '0';
                        _valueController.text = '0';
                        currentProgress.value = 40;
                      }),
                      child: Container(
                        margin: const EdgeInsets.only(
                          right: 12,
                        ),
                        alignment: Alignment.center,
                        width: 140,
                        height: 46,
                        padding: const EdgeInsets.only(right: 8, left: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.secoundaryLight,
                          border: Border.all(
                            color: AppColors.primary,
                            width:
                                selectedType != null && selectedType == cardType
                                    ? 2.6
                                    : 0,
                          ),
                          boxShadow:
                              selectedType != null && selectedType == cardType
                                  ? const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0.0, 1), //(x,y)
                                        blurRadius: .6,
                                        spreadRadius: -1,
                                      ),
                                    ]
                                  : [],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              CupertinoIcons.creditcard,
                              color: AppColors.primary,
                              size: 24,
                            ),
                            horizontalSpacing(4),
                            Text(
                              cardType['name'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: AppColors.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            selectedType != null && selectedType!['demo'].toString().isNotEmpty
                ? TextButton(
                    onPressed: () {
                      openBottomSheet(
                          context: context,
                          child: SizedBox(
                            height: 240,
                            width: double.maxFinite,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: "${selectedType!['demo']}",
                                placeholder: (context, url) => const SizedBox(
                                  height: 64,
                                  width: 64,
                                  child: LoadingWidget(),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                          radius: 12,
                          height: MediaQuery.of(context).size.height / 2.4);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 16,
                        ),
                        horizontalSpacing(4),
                        Text(
                          "Learn more about ${selectedType!['name']}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        )
                      ],
                    ),
                  )
                : const SizedBox(),
            verticalSpacing(12),
            selectedType != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const InputLabel(text: "Card Value"),
                      GestureDetector(
                        onTap: () => openCardValueModal(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.textFaded,
                              width: 1.4,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical:
                                  _valueController.text.isEmpty ? 16 : 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  _valueController.text.isNotEmpty
                                      ? SizedBox(
                                          height: 32,
                                          width: 58,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: widget.asset.image,
                                              placeholder: (context, url) =>
                                                  const SizedBox(
                                                height: 40,
                                                width: 40,
                                                child: LoadingWidget(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  horizontalSpacing(6),
                                  Text(
                                    _valueController.text.isNotEmpty
                                        ? "${selectedCountry.currencyCode} ${_valueController.text} x ${_amountController.text}"
                                        : "Select Giftcard Value",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                  )
                                ],
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 22,
                                color: Theme.of(context).accentColor,
                              )
                            ],
                          ),
                        ),
                      ).animate().fade(duration: 400.ms),
                    ],
                  )
                : const SizedBox(),
            verticalSpacing(34),
            currentProgress.value == 60
                ? Button.primary(
                    onPressed: () => openTradeModal(),
                    background: AppColors.primary,
                    foreground: AppColors.secoundaryLight,
                    title: "Continue",
                  ).animate().fade(duration: 300.ms)
                : const SizedBox(),
          ],
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

class TradePreview extends StatefulWidget {
  final Map<String, dynamic> data;
  final String type;
  final Giftcard asset;
  final List rates;
  const TradePreview(
      {Key? key,
      required this.data,
      required this.type,
      required this.rates,
      required this.asset})
      : super(key: key);

  @override
  _TradePreviewState createState() => _TradePreviewState();
}

class _TradePreviewState extends State<TradePreview> {
  late Map tradeData;
  List images = [];
  late User user;
  late String secondaryImageLabel = "reciept";
  double rate = 0;
  bool isDefaultRate = false;
  bool isLoading = true;
  late String rateId;
  double convertedTotal = 0;
  late Wallet wallet;
  bool canUploadBackOrReciept = true;

  setRate() {
    var findRate = widget.rates
        .where((crate) =>
            crate['price'] == tradeData['price'] &&
            crate['type'] == tradeData['type']['name'] &&
            crate['country'] == tradeData['currency'])
        .toList()
        .first;

    if (findRate != null) {
      var itemRate = widget.type == 'sell'
          ? findRate['sellerRate']
          : findRate['buyerRate'];
      setState(() => rate = itemRate);
    } else {
      var tradeLimit = widget.asset.tradeLimits!
          .where((tlimit) =>
              tlimit['min'] <= tradeData['value'] &&
              tlimit['max'] >= tradeData['value'] &&
              tlimit.country.toLowerCase() ==
                  tradeData['currency'].toLowerCase())
          .toList()
          .first;
      if (tradeLimit != null) {
        var findDefaultRate = widget.asset.defaultRates!
            .where((drate) =>
                drate['range'] == tradeLimit['_id'] &&
                drate['country'].toLowerCase() ==
                    tradeData['currency'].toLowerCase() &&
                drate['type'].toLowerCase() ==
                    tradeData['type']['name'].toLowerCase())
            .toList()
            .first;
        if (findDefaultRate != null) {
          setState(() {
            isDefaultRate = true;
            rateId = findDefaultRate['_id'];
            rate = widget.type == 'sell'
                ? findDefaultRate['sellerRate']
                : findDefaultRate['buyerRate'];
          });
          if(user.currency!.toLowerCase() != 'ngn'){
            BlocProvider.of<TradeCubit>(context).convertRateToLocalCurrency(
                rate: rate * int.parse(tradeData['amount']));
          }else {
            setState(() {
              convertedTotal = rate * int.parse(tradeData['amount']);
            });
          }
        }
      }
    }
    if (rate == 0) {
      Future.delayed(const Duration(seconds: 2), () {
        toastMessage(
            message:
                "Giftcard type is not available for ${widget.type == 'sell' ? 'sell' : 'purchase'}",
            context: context);
      });
      setState(() => isLoading = false);
    }
  }

  submitTrade() {
    if (wallet.balance < convertedTotal && widget.type == 'buy') {
      notify(context, "Insufficient wallet balance", 'error');
      return;
    }
    BlocProvider.of<TradeCubit>(context).submitGiftcardTrade(
      asset: widget.asset.id,
      amount: convertedTotal,
      type: widget.type,
      rate: rateId,
      total: convertedTotal,
      denomination: tradeData['amount'],
      price: int.parse(tradeData['value']),
      isDefault: isDefaultRate,
      images: images,
    );
  }

  imagesCheck() {
    var requiredBack = tradeData['type']['requiredBackImage'];
    var requireReciept = tradeData['type']['requireReciept'];
    if (requiredBack == true) {
      setState(() => secondaryImageLabel = 'back');
    } else if (requireReciept == true) {
      setState(() => secondaryImageLabel = 'reciept');
    } else {
      setState(() => canUploadBackOrReciept = false);
    }
  }

  @override
  void initState() {
    super.initState();
    user = BlocProvider.of<AppBloc>(context).authenticatedUser;
    setState(() {
      tradeData = widget.data;
    });
    setRate();
    imagesCheck();
    BlocProvider.of<TradeCubit>(context).getWallet();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TradeCubit, TradeState>(
      listener: (context, state) {
        if (state is RateConverted) {
          setState(() =>  convertedTotal = state.rate);
        } else if (state is WalletLoaded) {
          setState(() {
            wallet = state.wallet;
            isLoading = false;
          });
        } else if (state is PerformingTrade) {
          setState(() => isLoading = true);
        } else if (state is TradeSuccess) {
          setState(() => isLoading = false);
          BlocProvider.of<AppBloc>(context)
              .localNotificationService
              .showNotification(
                  id: 1,
                  title: "Trade Successful",
                  body: "Giftcard trade was successful");
          context.pushNamed("trade", extra: state.trade);
        } else if (state is TradeFailed) {
          setState(() => isLoading = false);
          notify(context, "Opps! somthing went wrong try again later", "error");
        }
      },
      child: AppWrapper(
        child: !isLoading
            ? Padding(
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
                                  imageUrl: widget.asset.image,
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
                                    "${widget.asset.name} ${widget.data['currency']}",
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
                                    "${ucFirst(widget.data['type']['name'])} Card",
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
                            name: "Card value",
                            value:
                                "${widget.data['currency']} ${widget.data['value']} x ${widget.data['amount']}"),
                        verticalSpacing(12),
                        KeyValue(name: "Rate", value: "${user.currency} ${moneyFormat(convertedTotal / widget.data['amount'])}"),
                      ]),
                    ),
                    verticalSpacing(26),
                    TradeValueTile(title: widget.type == 'sell' ? "You Get" : "You Pay", value: "${user.currency} ${moneyFormat(convertedTotal)}"),
                    verticalSpacing(26),
                    widget.type == 'sell'
                        ? Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  FileUploader(
                                    trigger: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10.0),
                                      child: DottedBorder(
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(10),
                                        dashPattern: const [10, 4],
                                        strokeCap: StrokeCap.round,
                                        color: Theme.of(context).accentColor,
                                        child: Container(
                                          width: double.infinity,
                                          height: 48,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).cardColor,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                CupertinoIcons
                                                    .cloud_upload_fill,
                                                color: Theme.of(context)
                                                    .accentColor,
                                                size: 26,
                                              ),
                                              horizontalSpacing(12),
                                              Text(
                                                "Upload images",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      fontSize: 15,
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    label: "Upload Card Images",
                                    isMultiple: true,
                                    onSelected: (List files) {
                                      setState(() {
                                        images = files
                                            .map((file) => {
                                                  "type": "main",
                                                  "file": file,
                                                })
                                            .toList();
                                      });
                                    },
                                  ),
                                  verticalSpacing(12),
                                  canUploadBackOrReciept
                                      ? FileUploader(
                                          trigger: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 10.0),
                                            child: DottedBorder(
                                              borderType: BorderType.RRect,
                                              radius: const Radius.circular(10),
                                              dashPattern: const [10, 4],
                                              strokeCap: StrokeCap.round,
                                              color:
                                                  Theme.of(context).accentColor,
                                              child: Container(
                                                width: double.infinity,
                                                height: 48,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .cardColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      CupertinoIcons
                                                          .cloud_upload_fill,
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                      size: 26,
                                                    ),
                                                    horizontalSpacing(12),
                                                    Text(
                                                      "Upload card $secondaryImageLabel images",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                            fontSize: 15,
                                                            color: Theme.of(
                                                                    context)
                                                                .accentColor,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          label:
                                              "Upload card $secondaryImageLabel images",
                                          isMultiple: true,
                                          onSelected: (List files) {
                                            setState(() {
                                              images = files
                                                  .map((file) => {
                                                        "type":
                                                            secondaryImageLabel,
                                                        "file": file,
                                                      })
                                                  .toList();
                                            });
                                          },
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    verticalSpacing(20),
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
