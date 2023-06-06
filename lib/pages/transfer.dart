import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/cubits/wallet/wallet_cubit.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/services/local_auth.dart';
import 'package:truvender/services/storage.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class TransferPage extends StatefulWidget {
  final Wallet wallet;
  const TransferPage({Key? key, required this.wallet}) : super(key: key);

  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  bool processing = false;
  late User user;
  late AppBloc appBloc;
  StorageUtil localStore = StorageUtil();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();

  final GlobalKey<FormState> _transferForm = GlobalKey();
  @override
  void initState() {
    super.initState();
    user = BlocProvider.of<AppBloc>(context).authenticatedUser;
    appBloc = BlocProvider.of<AppBloc>(context);
  }

  _handleTransfer() async {
    var biometricsIsEnabled = await localStore.getBoolVal('biometricsEnabled');
    if (widget.wallet.balance > double.parse(_amountController.text) &&
        !processing) {
      bool authenticate = true;
      if (biometricsIsEnabled) {
        authenticate = await LocalAuth.authenticate();
        if (authenticate) {
          BlocProvider.of<WalletCubit>(context).transfer(
              email: _accountController.text,
              amount: double.parse(_amountController.text));
        }
      } else {
        // ignore: use_build_context_synchronously
        openModal(
          context: context,
          child: VerificationDialog(
            type: "pin",
            onSuccess: () {
              BlocProvider.of<WalletCubit>(context).transfer(
                  email: _accountController.text,
                  amount: double.parse(_amountController.text));
            },
          ),
        );
      }
    } else {
      notify(context, "Insufficient wallet balance", "error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletCubit, WalletState>(
      listener: (context, state) {
        if (state is TransactionFailed) {
          setState(() => processing = false);
          notify(
              context, "Opps! Something went wrong try again later", "error");
          context.pop();
        } else if (state is ProcessingTransaction) {
          setState(() => processing = true);
        } else if (state is TransactionCompleted) {
          appBloc.localNotificationService.showNotification(
              id: 1,
              title: "Transaction Successful!",
              body:
                  "Transfered  ${user.currency}${moneyFormat(state.transaction.amount)} to ${_accountController.text} successfully");
          context.pushNamed('transaction', extra: state.transaction);
        }
      },
      child: Wrapper(
        title: "Transfer",
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WalletCard(
                wallet: widget.wallet,
                withActions: false,
                isSelectable: false,
              ),
              verticalSpacing(28),
              Form(
                key: _transferForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 6,
                      ),
                      child: Text(
                        "Transfer funds to other user",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                      ),
                    ),
                    verticalSpacing(28),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 12),
                      child: Text(
                        "How much will you like to transfer?",
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 12),
                      type: TextInputType.number,
                      bordered: true,
                      rules: MultiValidator(
                        [
                          RequiredValidator(errorText: "Amount is required"),
                        ],
                      ),
                      iconPreffix: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 12),
                        child: Text(
                          "${user.currency}",
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
                    verticalSpacing(28),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 12),
                      child: Text(
                        "Username or Email",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                      ),
                    ),
                    TextInput(
                      label: "",
                      controller: _accountController,
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 12),
                      type: TextInputType.emailAddress,
                      bordered: true,
                      rules: MultiValidator([
                        RequiredValidator(errorText: "Username is required"),
                      ]),
                    ),
                    verticalSpacing(32),
                    Button.primary(
                      onPressed: () => !processing ? _handleTransfer() : () {},
                      title: processing ? "Processing..." : "Continue",
                      background: processing
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(.6)
                          : AppColors.primary,
                      foreground: AppColors.secoundaryLight,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
