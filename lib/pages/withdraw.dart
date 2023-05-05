import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/cubits/wallet/wallet_cubit.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class WithdrawPage extends StatefulWidget {
  final Wallet wallet;
  const WithdrawPage({Key? key, required this.wallet}) : super(key: key);

  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  late User user;
  @override
  void initState() {
    super.initState();
    user = BlocProvider.of<AppBloc>(context).authenticatedUser;
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      title: "Withdraw",
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
                ? BankWithdraw(
                    wallet: widget.wallet,
                    user: user,
                  )
                : WalletWithdraw(
                    wallet: widget.wallet,
                    user: user,
                  ),
          ],
        ),
      ),
    );
  }
}

class BankWithdraw extends StatefulWidget {
  final User user;
  final Wallet wallet;
  const BankWithdraw({Key? key, required this.user, required this.wallet})
      : super(key: key);

  @override
  _BankWithdrawState createState() => _BankWithdrawState();
}

class _BankWithdrawState extends State<BankWithdraw> {
  bool processing = false;
  bool hasSetWithdrawAccount = false;
  late AppBloc appBloc;
  late User user;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final GlobalKey<FormState> _withdrawForm = GlobalKey();

  @override
  void initState() {
    super.initState();
    appBloc = BlocProvider.of<AppBloc>(context);
    user = widget.user;
    setState(() {
      hasSetWithdrawAccount =
          user.withdrawAccount != null && user.withdrawAccount!['name'] != null;
    });
  }

  handleWithdrawalForm() {
    BlocProvider.of<WalletCubit>(context)
        .withdraw(amount: double.parse(_amountController.text));
  }

  transactionPreview() {
    if (!processing && user.withdrawAccount!['account'] != null) {
      openBottomSheet(
        radius: 16,
        context: context,
        child: TransactionPreview(
          wallet: widget.wallet,
          data: {
            "type": "Debit",
            "amount": double.parse(_amountController.text),
            "fee": 0,
            "label": "Withdraw",
          },
          callBack: handleWithdrawalForm,
        ),
        label: "Transaction Preview",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletCubit, WalletState>(
      listener: (context, state) {
        if (state is TransactionFailed) {
          setState(() => processing = false);
          notify(
              context,
              "Service unavailable! Transaction failed. Try again later",
              "error");
        } else if (state is ProcessingTransaction) {
          setState(() => processing = true);
        } else if (state is TransactionCompleted) {
          appBloc.localNotificationService.showNotification(
              id: 1,
              title: "Transaction Successful!",
              body:
                  "${user.currency}${moneyFormat(state.transaction.amount)} withdrawal was successful");
          context.pushNamed('transaction',
              extra: {'transaction': state.transaction});
        }
      },
      child: Form(
        key: _withdrawForm,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Withdraw to Bank",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
            ),
            verticalSpacing(28),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 12),
              child: Text(
                "How much will you like to withdraw?",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
              ),
            ),
            TextInput(
              label: "0.00",
              iconPreffix: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                child: Text(
                  user.currency ?? "NGN",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor),
                ),
              ),
              controller: _amountController,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              type: TextInputType.number,
              bordered: true,
              rules: MultiValidator(
                [
                  RequiredValidator(errorText: "Amount is required"),
                  MinLengthValidator(500,
                      errorText: 'Amount must be more than 500'),
                ],
              ),
            ),
            verticalSpacing(28),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 12),
              child: Text(
                "Withdrawing to Account",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
              ),
            ),
            !hasSetWithdrawAccount
                ? GestureDetector(
                    onTap: () => context.pushNamed("settings",
                        queryParams: {"type": "banking"}),
                    child: Container(
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
                                "Notice!",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                    ),
                              ),
                              Text(
                                "You need to add an account for withdrawal. Click to add account",
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
                          )
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
            verticalSpacing(28),
            TextInput(
              label: "",
              controller: _accountController,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              type: TextInputType.number,
              readOnly: true,
              bordered: false,
            ),
            verticalSpacing(32),
            Button.primary(
              onPressed: () => transactionPreview(),
              title: processing ? "Processing Request..." : "Continue",
              background: processing
                  ? Theme.of(context).colorScheme.primary.withOpacity(.6)
                  : AppColors.primary,
              foreground: AppColors.secoundaryLight,
            )
          ],
        ),
      ),
    );
  }
}

class WalletWithdraw extends StatefulWidget {
  final Wallet wallet;
  final User user;
  const WalletWithdraw({Key? key, required this.wallet, required this.user})
      : super(key: key);

  @override
  _WalletWithdrawState createState() => _WalletWithdrawState();
}

class _WalletWithdrawState extends State<WalletWithdraw> {
  bool processing = false;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _walletAddressController =
      TextEditingController();
  final GlobalKey<FormState> _sendFormKey = GlobalKey();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  late AppBloc appBloc;
  String cryptoValue = "0";

  @override
  void initState() {
    super.initState();
    appBloc = BlocProvider.of<AppBloc>(context);
  }

  handleSendForm() {
    BlocProvider.of<WalletCubit>(context).sendCrypto(
        amount: double.parse(_amountController.text),
        wallet: widget.wallet.id,
        value: cryptoValue,
        address: _walletAddressController.text);
  }

  transactionPreview() {
    openBottomSheet(
      radius: 16,
      context: context,
      child: TransactionPreview(
        wallet: widget.wallet,
        data: {
          "type": "debit",
          "amount": double.parse(_amountController.text),
          "fee": 0,
          "label": "Withdraw",
        },
        callBack: handleSendForm,
      ),
      label: "Transaction Preview",
    );
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      debugPrint(result!.code.toString());
      context.pop();
    });
  }

  _scanQrCode() async {
    openBottomSheet(
        context: context,
        child: Expanded(
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
        ),
        height: MediaQuery.of(context).size.height / 1.8,
        label: "Scan Qrcode for wallet address",
        radius: 16);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletCubit, WalletState>(
      listener: (context, state) {
        if (state is TransactionFailed) {
          setState(() => processing = false);
          showStatus(
              type: "error",
              title: "Failed",
              subTitle:
                  "Service unavailable! Transaction failed. Try again later",
              context: context);
        } else if (state is ProcessingTransaction) {
          setState(() => processing = true);
        } else if (state is TransactionCompleted) {
          appBloc.localNotificationService.showNotification(
              id: 1,
              title: "Transaction Successful!",
              body:
                  "${widget.wallet.currency}${moneyFormat(state.transaction.amount)} withdrawal was successful");
          showStatus(
              type: "success",
              subTitle: "Trasfer successful!",
              title: "Weldone!",
              next: () {
                context.pushNamed('transaction',
                    extra: {'transaction': state.transaction});
              },
              context: context);
        }
      },
      child: Form(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Send ${widget.wallet.asset!.name}",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
          ),
          verticalSpacing(28),
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 12),
            child: Text(
              "How much will you like to send? (USD)",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
            ),
          ),
          TextInput(
            label: "0.00",
            controller: _amountController,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            type: TextInputType.number,
            iconPreffix: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
              child: Text(
                "USD",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor),
              ),
            ),
            bordered: true,
            rules: MultiValidator(
              [
                RequiredValidator(errorText: "Amount is required"),
                MinLengthValidator(500,
                    errorText: 'Amount must be more than 500'),
              ],
            ),
          ),
          verticalSpacing(28),
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 12),
            child: Text(
              "Wallet Address",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
            ),
          ),
          TextInput(
            label: "",
            controller: _walletAddressController,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            type: TextInputType.text,
            readOnly: false,
            rules: MultiValidator(
              [
                RequiredValidator(errorText: "Wallet address is required"),
              ],
            ),
            bordered: true,
            suffixIcon: GestureDetector(
              onTap: () => _scanQrCode(),
              child: Icon(
                CupertinoIcons.qrcode_viewfinder,
                size: 28,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          verticalSpacing(32),
          Button.primary(
            onPressed: () => transactionPreview(),
            title: processing ? "Processing Request..." : "Continue",
            background: processing
                ? Theme.of(context).colorScheme.primary.withOpacity(.6)
                : AppColors.primary,
            foreground: AppColors.secoundaryLight,
          )
        ],
      )),
    );
  }
}
