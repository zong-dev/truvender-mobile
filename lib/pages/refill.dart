import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:truvender/cubits/bills/bills_cubit.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class MobileRefillPage extends StatefulWidget {
  final String? refillType;
  const MobileRefillPage({Key? key, this.refillType}) : super(key: key);

  @override
  _MobileRefillPageState createState() => _MobileRefillPageState();
}

class _MobileRefillPageState extends State<MobileRefillPage> {
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FlutterContactPicker _contactPicker = FlutterContactPicker();
  Map variation = {};
  String type = 'airtime';
  late Wallet localWallet;
  bool processing = true;
  String variationTitle = "Please wait...";

  List<Map> serviceProviders = refillServiceProviders;
  late Map provider = serviceProviders[0];

  List billCategories = [];
  List dataBundles = [];
  late Map<String, dynamic> data;

  final GlobalKey<FormState> _refillKey = GlobalKey();


  _filterVariations() {
    String billCode = provider['billCode'];
    List filteredVariations = billCategories.where((element) => element['biller_code'] == billCode).toList();
    setState(() {
      dataBundles = filteredVariations;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.refillType != null) {
      type = widget.refillType!;
    }
    BlocProvider.of<BillsCubit>(context).getWallet();
    if(type != 'airtime'){
      BlocProvider.of<BillsCubit>(context).loadVariations();
    }
  }

  openVariationsModal(){
    if(!processing && billCategories.isNotEmpty){
      openBottomSheet(
        radius: 16,
        context: context,
        child: VarationPicker(variations: dataBundles, onChange: (value){
          setState(() {
            variation = value;
            _amountController.text = variation['amount'].toString();
          });
        }, currentState: variation, title: "Select Data Bundle"),
        label: "Select Data Bundle",
      );
    }
  }


  void _openRefillPreview() {
    if(localWallet.balance >= double.parse(_amountController.text)){
      if (type == 'data' && (variation == {} || variation['name'] == null)) {
        notify(context, "Select a data bundle to continue", "error");
        return;
      } else {
        if (_refillKey.currentState!.validate()) {
          setState(() {
            data = {
              "amount": _amountController.text,
              "customer": _customerController.text,
              "type": type,
              "provider": provider['name'],
              "fee": 0,
              "variation": variation['name'],
              "country":localWallet.currency,
              "item_code": variation['item_code'],
              "biller_code": variation['biller_code']
            };
          });
          openBottomSheet(
              context: context,
              height: 520,
              radius: 12,
              child: BillPreview(data: data, wallet: localWallet));
        }
      }
    }else {
      notify(context, "Insufficient Wallet Balance!", "error");
    }
  }

  void _pickFromContact() async {
    Contact? contact = await _contactPicker.selectContact();
    if (contact != null) {
      setState(() {
        _customerController.text = contact.phoneNumbers!.first.replaceAll(' ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BillsCubit, BillsState>(
      listener: (context, state) {
        if(state is WalletLoaded){
          setState(() {
            localWallet = state.wallet;
            processing = false;
          });
        }else if (state is VariationLoaded) {
          setState(() {
            billCategories = state.variations;
            processing = false;
            variationTitle = "Choose Data Bundle";
          });
          _filterVariations();
        } else if(state is RequestLoading){
           setState(() => processing = true ); 
        }
      },
      child: Wrapper(
        title: ucFirst(type),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 26),
            child: Form(
              key: _refillKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 12),
                    child: Text(
                      "Service Provider",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                              variation = {};
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
                            padding: const EdgeInsets.only(right: 8, left: 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: provider == serviceProvider
                                    ? const [
                                        BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0.0, 1), //(x,y)
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  serviceProvider['image'],
                                  height: 24,
                                  width: 24,
                                ),
                                horizontalSpacing(6),
                                Text(
                                  ucFirst(serviceProvider['name']),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        letterSpacing: .8,
                                        color: AppColors.accent,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  verticalSpacing(28),
                  widget.refillType == 'airtime'
                      ? AmountGrid(
                          controller: _amountController,
                          onChange: (value) {
                            setState(() {
                              _amountController.text = value;
                            });
                          },
                          currentState: _amountController.text,
                        )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 12),
                              child: Text(
                                "Data Bundles",
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
                                      variation != {} && variation['biller_name'] != null
                                          ? variation['biller_name']
                                          : variationTitle,
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
                    padding: const EdgeInsets.only(top: 10, bottom: 12),
                    child: Text(
                      "Phone Number",
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
                    type: TextInputType.phone,
                    bordered: true,
                    rules: MultiValidator(
                      [
                        RequiredValidator(
                            errorText: "Phone number is required"),
                      ],
                    ),
                    suffixIcon: GestureDetector(
                      onTap: _pickFromContact,
                      child: Icon(
                        Icons.contacts_rounded,
                        size: 28,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  verticalSpacing(38),
                  Button.primary(
                    onPressed: () => _openRefillPreview(),
                    background: processing ? Theme.of(context).colorScheme.primary.withOpacity(.8) :AppColors.primary,
                    foreground: AppColors.secoundaryLight,
                    title: processing ? "Please wait..." : "Continue",
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

class AmountGrid extends StatefulWidget {
  final Function onChange;
  final String currentState;
  final TextEditingController controller;
  AmountGrid(
      {Key? key,
      required this.onChange,
      required this.currentState,
      required this.controller})
      : super(key: key);

  @override
  State<AmountGrid> createState() => _AmountGridState();
}

class _AmountGridState extends State<AmountGrid> {
  late String pickedAmount;
  @override
  List<String> predefinedAmounts = ['50', '100', '200', '500', '1000', '2000'];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 12),
          child: Text(
            "Topup Amount",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
          ),
        ),
        SizedBox(
          child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              primary: true,
              itemCount: predefinedAmounts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 3,
              ),
              itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      widget.onChange(predefinedAmounts[index]);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                        right: 8,
                      ),
                      alignment: Alignment.center,
                      width: 130,
                      height: 54,
                      padding: const EdgeInsets.only(right: 8, left: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow:
                            widget.currentState == predefinedAmounts[index]
                                ? const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 1), //(x,y)
                                      blurRadius: .6,
                                      spreadRadius: -1,
                                    ),
                                  ]
                                : [],
                        color: AppColors.secoundaryLight,
                        border: Border.all(
                          color: widget.currentState == predefinedAmounts[index]
                              ? AppColors.primary
                              : AppColors.secoundaryLight,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        "NGN ${predefinedAmounts[index]}",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              color: AppColors.accent,
                            ),
                      ),
                    ),
                  )),
        ),
        verticalSpacing(30),
        TextInput(
          label: "Other Amount",
          controller: widget.controller,
          type: TextInputType.number,
          bordered: true,
          rules: MultiValidator(
            [
              RequiredValidator(errorText: "Amount is required"),
            ],
          ),
          onChange: () {
            setState(() {
              widget.onChange(widget.controller.text);
            });
          },
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        )
      ],
    );
  }
}
