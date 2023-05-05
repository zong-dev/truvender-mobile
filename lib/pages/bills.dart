import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/cubits/bills/bills_cubit.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class BillPaymentPage extends StatefulWidget {
  final String? billType;
  const BillPaymentPage({Key? key, this.billType}) : super(key: key);

  @override
  _BillPaymentPageState createState() => _BillPaymentPageState();
}

class _BillPaymentPageState extends State<BillPaymentPage> {
  late Wallet localWallet;

  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String type = 'cable';
  String title = 'Cable Subscription';

  bool processing = false;

  List<Map> serviceProviders = billsServiceProviders;
  late Map provider = serviceProviders[0];
  String planTitle = "Please wait...";
  bool validated = false;

  List variations = [];
  List plans = [];
  Map<String, dynamic> plan = {};

  final GlobalKey<FormState> _billFormKey = GlobalKey();

  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    if (widget.billType != null) {
      type = widget.billType!;
      if (type != 'cable' && type == 'electric') {
        title = 'Electricity';
      }
    }
    BlocProvider.of<BillsCubit>(context).getWallet();
    BlocProvider.of<BillsCubit>(context).loadVariations();
  }

  _filterVariations() {
    String toFilterFor = provider['name'];
    List filtered = type != 'cable'
        ? variations
            .where((variation) => variation["name"]
                .toString()
                .toLowerCase()
                .contains("ELECTRICITY"))
            .toList()
        : variations
            .where((variation) => variation["name"]
                .toString()
                .toLowerCase()
                .contains(toFilterFor))
            .toList();
    setState(() => plans = filtered);
  }

  openVariationsModal() {
    if (!processing && variations.isNotEmpty) {
      openBottomSheet(
        radius: 16,
        context: context,
        child: VarationPicker(
            variations: plans,
            onChange: (value) {
              setState(() {
                plan = value;
                _amountController.text = plan['amount'].toString();
              });
            },
            currentState: plan,
            title: "Select Banquet Paln"),
        label: "Select Banquet Plan",
      );
    }
  }

  void _openRefillPreview() {
    if (localWallet.balance >= double.parse(_amountController.text)) {
      if (type == 'data' && (plan == {} || plan['name'] == null)) {
        toastMessage(
            message: "Select a data bundle to continue", context: context);
        return;
      } else {
        if (_billFormKey.currentState!.validate()) {
          setState(() {
            data = {
              "amount": _amountController.text,
              "customer": _customerController.text,
              "type":
                  type == 'cable' ? 'Cable Subscription' : 'Electricity Bill',
              "provider": provider['name'],
              "fee": plan['fee'],
              "variation": plan['biller_name'],
              "country": localWallet.currency,
              "item_code": plan['item_code'],
              "biller_code": plan['biller_code']
            };
          });
          openBottomSheet(
              context: context,
              height: 520,
              radius: 12,
              child: BlocProvider<BillsCubit>(
                create: (context) =>
                    BillsCubit(appBloc: BlocProvider.of<AppBloc>(context)),
                child: BillPreview(data: data, wallet: localWallet),
              ));
        }
      }
    } else {
      showStatus(
          type: "error",
          title: "Failed!",
          context: context,
          subTitle: "Insufficient Wallet Balance");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BillsCubit, BillsState>(
      listener: (context, state) {
        if (state is VariationLoaded) {
          setState(() {
            variations = state.variations;
            planTitle =
                type == 'cable' ? "Select Banquet Plan" : "Select Provider";
          });
          _filterVariations();
        } else if (state is CustomerVerified) {
          setState(() {
            validated = true;
          });
          _openRefillPreview();
        } else if (state is WalletLoaded) {
          setState(() {
            localWallet = state.wallet;
            processing = false;
          });
        } else if (state is RequestLoading) {
          setState(() => processing = true);
        } else if (state is VerificationFailed) {
          setState(() => processing = false);
          notify(context, "Vailed to verify smart card number", "error");
        }
      },
      child: Wrapper(
        title: title,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 26),
            child: Form(
              key: _billFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  type == 'cable'
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 12),
                              child: Text(
                                "Service Provider",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                              ),
                            ),
                            SizedBox(
                              height: 58,
                              child: ListView.builder(
                                itemCount: serviceProviders.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  var serviceProvider = serviceProviders[index];
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        provider = serviceProvider;
                                      });
                                      _filterVariations();
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        right: 12,
                                      ),
                                      alignment: Alignment.center,
                                      width: 130,
                                      height: 54,
                                      padding: const EdgeInsets.only(
                                          right: 8, left: 8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: provider == serviceProvider
                                              ? const [
                                                  BoxShadow(
                                                    color: Colors.grey,
                                                    offset:
                                                        Offset(0.0, 1), //(x,y)
                                                    blurRadius: .6,
                                                    spreadRadius: -1,
                                                  ),
                                                ]
                                              : [],
                                          color: AppColors.secoundaryLight,
                                          border: Border.all(
                                            color: provider == serviceProvider
                                                ? AppColors.primary
                                                : AppColors.secoundaryLight,
                                            width: 2,
                                          )),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            serviceProvider['image'],
                                            height: 44,
                                            width: 68,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  verticalSpacing(28),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 12),
                        child: Text(
                          type == 'cable'
                              ? "Banquet Plans"
                              : "Service Provider",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => openVariationsModal(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              border: Border.all(
                                  width: 1.4, color: AppColors.textFaded)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                plan != {} && plan['biller_name'] != null
                                    ? plan['biller_name']
                                    : planTitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 14,
                                    ),
                              ),
                              Icon(
                                Icons.arrow_drop_down_rounded,
                                size: 28,
                                color: Theme.of(context).accentColor,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  verticalSpacing(28),
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 12),
                    child: Text(
                      "Smart Card Number",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                    ),
                  ),
                  TextInput(
                    label: "",
                    controller: _customerController,
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 12),
                    type: TextInputType.number,
                    bordered: true,
                    rules: MultiValidator(
                      [
                        RequiredValidator(
                            errorText: "Smart Card Number is required"),
                      ],
                    ),
                  ),
                  verticalSpacing(28),
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 12),
                    child: Text(
                      "Amount",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                    ),
                  ),
                  TextInput(
                    label: "0.00",
                    readOnly: type == 'cable',
                    controller: _amountController,
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 12),
                    type: TextInputType.number,
                    bordered: true,
                    rules: MultiValidator(
                      [
                        RequiredValidator(errorText: "Amount is required"),
                      ],
                    ),
                  ),
                  verticalSpacing(38),
                  Button.primary(
                    onPressed: () => _openRefillPreview(),
                    background: AppColors.primary,
                    foreground: AppColors.secoundaryLight,
                    title: "Continue",
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
