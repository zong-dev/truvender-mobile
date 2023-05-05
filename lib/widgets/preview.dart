import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:truvender/cubits/bills/bills_cubit.dart';
import 'package:truvender/cubits/wallet/wallet_cubit.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class BillPreview extends StatefulWidget {
  final Map<String, dynamic> data;
  final Wallet wallet;
  final String currency;
  const BillPreview(
      {Key? key,
      required this.data,
      this.currency = "NGN",
      required this.wallet})
      : super(key: key);

  @override
  State<BillPreview> createState() => _BillPreviewState();
}

class _BillPreviewState extends State<BillPreview> {
  bool validated = false;
  bool processing = true;

  String _getProductName() {
    if (widget.data['type'] == 'airtime') {
      return "Airtime";
    } else {
      return widget.data['variation'];
    }
  }

  validateCustommer() {
    BlocProvider.of<BillsCubit>(context).validateCustomer(
        itemCode: widget.data['item_code'],
        code: widget.data['item_code'],
        customer: widget.data['customer']);
  }

  @override
  void initState() {
    super.initState();
    validateCustommer();
  }

  void makePayment() {
    BlocProvider.of<BillsCubit>(context).makePayment(
        customer: widget.data['customer'],
        amount: double.parse(widget.data['amount']),
        type: widget.data['type'],
        country: widget.data['country'],
        varation: _getProductName(),
        fee: widget.data['fee']);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BillsCubit, BillsState>(
      listener: (context, state) {
        if (state is CustomerVerified) {
          setState(() {
            processing = false;
            validated = true;
          });
        } else if (state is VerificationFailed) {
          setState(() => processing = false);
          showStatus(type: "error", title: "Failed", subTitle: "Failed to verify customer", context: context);
        } else if (state is RequestLoading) {
          setState(() {
            processing = true;
          });
        }else if(state is BillRequestFailed){
          setState(() => processing = false);
          showStatus(
              type: "error",
              title: "Failed",
              subTitle: state.message,
              context: context);
        }
      },
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpacing(20),
            KeyValue(name: "Product Name", value: _getProductName()),
            verticalSpacing(12),
            KeyValue(
                name: "Provider",
                value: widget.data['provider'].toString().toUpperCase()),
            verticalSpacing(12),
            KeyValue(
                name: "Amount",
                value: "- ${widget.currency} ${widget.data['amount']}"),
            verticalSpacing(12),
            KeyValue(name: "Fee", value: "${widget.data['fee']}"),
            verticalSpacing(16),
            Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 12),
              child: Text(
                "Paying From",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).accentColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
            WalletBalanceTile(wallet: widget.wallet),
            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Button.primary(
                      onPressed: () => makePayment(),
                      title: processing ? "Processing..." : "Pay Now",
                      background: processing
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(.6)
                          : AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            verticalSpacing(24),
          ],
        ),
      ),
    );
  }
}

class TransactionPreview extends StatefulWidget {
  final Map<String, dynamic> data;
  final Wallet wallet;
  final Function callBack;
  const TransactionPreview({Key? key, required this.data, required this.wallet, required this.callBack})
      : super(key: key);

  @override
  _TransactionPreviewState createState() => _TransactionPreviewState();
}

class _TransactionPreviewState extends State<TransactionPreview> {
  String cryptoValue = "0";
  bool processing = false;
  getCryptoValue() {
    if (widget.data['type'] == 'debit' && widget.wallet.type != 0) {
      BlocProvider.of<WalletCubit>(context).cryptoValue(
          amount: widget.data['amount'], currency: widget.wallet.currency);
    }
  }

  late String label;

  @override
  void initState() {
    super.initState();
    getCryptoValue();
    label = widget.data['label']?? "Submit";
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletCubit, WalletState>(
      listener: (context, state) {
        if(state is ProcessingTransaction){
          setState(() => processing = true);
        }else if(state is GottenCryptoValue){
          setState(() {
            processing = false;
            cryptoValue = state.value;
          });
        }else if (state is TransactionFailed) {
          setState(() => processing = false);
           showStatus(
              type: "error",
              title: "Failed",
              subTitle: "Failed to process transaction, try again later",
              context: context);
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          if(processing){
            toastMessage(message: "Transaction Processing. Please wait...", context: context);
            return false;
          }else {
            return true;
          }
        },
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpacing(20),
              KeyValue(name: "Type", value: ucFirst(widget.data['type'] ?? 'Debit')),
              verticalSpacing(12),
              KeyValue(  name: "Amount",  value: "- ${widget.wallet.currency} ${widget.data['amount']}"),
              verticalSpacing(12),
              KeyValue(name: "Fee", value: "${widget.data['fee']}"),
              verticalSpacing(16),
              Padding(
                padding: const EdgeInsets.only(bottom: 12, top: 12),
                child: Text(
                  "$label From",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).accentColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              WalletBalanceTile(wallet: widget.wallet),
              Expanded(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Button.primary(
                        onPressed: () => widget.callBack(),
                        title: processing ? "Processing..." : label,
                        background: processing
                            ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(.6)
                            : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpacing(24),
            ],
          ),
        ),
      ),
    );
  }
}
