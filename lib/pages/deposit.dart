import 'package:ade_flutterwave_working_version/core/ade_flutterwave.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/cubits/wallet/wallet_cubit.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class DepositPage extends StatefulWidget {
  final Wallet wallet;
  const DepositPage({Key? key, required this.wallet}) : super(key: key);

  @override
  _DepositPageState createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  @override
  Widget build(BuildContext context) {
    return Wrapper(
      title: "Deposit",
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 26),
          child: Column(
            children: [
              WalletCard(
                wallet: widget.wallet,
                withActions: false,
                isSelectable: false,
              ),
              verticalSpacing(26),
              widget.wallet.type == 0
                  ? const FiatDeposit()
                  : const CryptoDeposit(),
            ],
          ),
        ),
      ),
    );
  }
}

class FiatDeposit extends StatefulWidget {
  const FiatDeposit({Key? key}) : super(key: key);

  @override
  _FiatDepositState createState() => _FiatDepositState();
}

class _FiatDepositState extends State<FiatDeposit>
    with TickerProviderStateMixin {
  bool processing = false;
  late User user;
  late AppBloc appBloc;
  static String? publicKey = dotenv.get('FLW_PUBLIC_KEY');
  static String? secretKey = dotenv.get('FLW_SECRET_KEY');

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    appBloc = BlocProvider.of<AppBloc>(context);
    user = appBloc.authenticatedUser;
  }

  final TextEditingController _amountController = TextEditingController();

  void _submitCardDeposit() {
    BlocProvider.of<WalletCubit>(context)
        .initiateFunding(amount: double.parse(_amountController.text));
  }

  _handleCardPayment(Map fundingData) async {
    Map data = {
      'title': 'Fund Wallet',
      "name": fundingData['customer']['name'] ?? user.username,
      "phone": user.phone!,
      "email": user.email!,
      'options': 'card, banktransfer, ussd',
      'tx_ref': fundingData['trxn_ref'],
      // "description": 'Payment for items in cart',
      "icon":
          'https://res.cloudinary.com/dtjylm0hd/image/upload/v1678488667/uploads/truvender_grvykn.png',
      'public_key': publicKey,
      'sk_key': secretKey
    };
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdeFlutterWavePay(data),
      ),
    ).then((response) {
      BlocProvider.of<WalletCubit>(context)
          .completeFunding(ref: fundingData['ref']);
    });
  }

  openStatusModal(String type, String message, {dynamic extra}) {
    String title = type == 'success' ? 'Success' : "Failed";
    showStatus(
        type: type,
        title: title,
        context: context,
        subTitle: message,
        next: () {
          if (type == 'success') {
            context.pushNamed('transaction', extra: {'transaction': extra});
          } else {
            Navigator.pop(context);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletCubit, WalletState>(
      listener: (context, state) {
        if (state is TransactionSuccess) {
          setState(() {
            processing = false;
            if (state.isSubproccess) {
              _handleCardPayment(state.response);
            }
          });
        } else if (state is TransactionFailed) {
          setState(() => processing = false);
          notify(context, "Opps! Could not verify transaction try again later",
              "error");
          openStatusModal(
              "error", "Could not verify transaction try again late");
        } else if (state is ProcessingTransaction) {
          setState(() => processing = true);
        } else if (state is TransactionCompleted) {
          appBloc.localNotificationService.showNotification(
              id: 1,
              title: "Transaction Successful!",
              body:
                  "${user.currency}${moneyFormat(state.transaction.amount)} deposit to wallet was successful");
          openStatusModal("success",
              "${user.currency}${moneyFormat(state.transaction.amount)} deposit was successful",
              extra: state.transaction);
        }
      },
      child: Column(
        children: [
          SizedBox(
            child: Align(
              alignment: Alignment.center,
              child: TabBar(
                controller: _tabController,
                labelColor: Theme.of(context).accentColor,
                labelStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                labelPadding: const EdgeInsets.only(left: 20, right: 20),
                unselectedLabelColor: AppColors.textFaded,
                isScrollable: false,
                // indicator: CircleTabIndicator(
                //   color: Theme.of(context).accentColor,
                //   radius: 4,
                // ),
                tabs: const [
                  Tab(
                    text: "Card Deposit",
                  ),
                  Tab(
                    text: "Bank Deposit",
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.38,
            width: double.maxFinite,
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6, bottom: 12),
                        child: Text(
                          "How much will you like to add to your wallet?",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                        ),
                      ),
                      TextInput(
                        label: "0.00",
                        controller: _amountController,
                        padding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 12),
                        type: TextInputType.number,
                        bordered: true,
                        iconPreffix: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 18),
                          child: Text(
                            user.currency ?? "NGN",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).accentColor),
                          ),
                        ),
                        rules: MultiValidator(
                          [
                            RequiredValidator(errorText: "Amount is required"),
                            MinLengthValidator(500,
                                errorText: 'Amount must be more than 500'),
                          ],
                        ),
                      ),
                      verticalSpacing(28),
                      Button.primary(
                        onPressed: () => _submitCardDeposit(),
                        title: !processing ? "Continue" : "Please wait...",
                        background: !processing
                            ? AppColors.primary
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(.6),
                        foreground: AppColors.secoundaryLight,
                      ),
                    ],
                  ),
                ),
                user.banking != null
                    ? Container(
                        margin: const EdgeInsets.only(top: 26),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => copyToClipBoard(
                                  context, "Account Number to be copied"),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: KeyValue(
                                        name: "Account Number",
                                        value:
                                            user.withdrawAccount!['account'] ??
                                                ''),
                                  ),
                                  horizontalSpacing(6),
                                  Icon(
                                    Icons.copy_rounded,
                                    color: Theme.of(context).accentColor,
                                    size: 16,
                                  )
                                ],
                              ),
                            ),
                            verticalSpacing(26),
                            KeyValue(
                                name: "Account Name",
                                value: user.banking!['name'] ?? ''),
                            verticalSpacing(26),
                            KeyValue(
                                name: "Account Bank",
                                value: user.banking!['bank'] ?? ''),
                          ],
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CryptoDeposit extends StatefulWidget {
  const CryptoDeposit({Key? key}) : super(key: key);

  @override
  State<CryptoDeposit> createState() => _CryptoDepositState();
}

class _CryptoDepositState extends State<CryptoDeposit> {
  final TextEditingController _walletController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 6,
          ),
          child: Text(
            "Scan the QR code below to deposit to your wallet",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
          ),
        ),
        verticalSpacing(28),
        PrettyQr(
          image: AssetImage('assets/images/icon.png'),
          typeNumber: 3,
          size: MediaQuery.of(context).size.width - 140,
          elementColor: Theme.of(context).accentColor,
          data: 'Lorem ipsum dolor sit amet consectetur !',
          errorCorrectLevel: QrErrorCorrectLevel.M,
          roundEdges: true,
        ),
        verticalSpacing(28),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 12),
          child: Text(
            "Wallet Address",
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
          ),
        ),
        TextInput(
          label: "",
          readOnly: true,
          controller: _walletController,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          type: TextInputType.number,
          bordered: false,
          suffixIcon: GestureDetector(
            onTap: () => copyToClipBoard(context, _walletController.text),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Copy",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                ),
                horizontalSpacing(6),
                Icon(
                  Icons.copy_rounded,
                  size: 16,
                  color: Theme.of(context).accentColor,
                ),
                horizontalSpacing(10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
