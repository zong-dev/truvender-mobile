import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class VerificationDialog extends StatefulWidget {
  final Function onSuccess;
  final String type;
  const VerificationDialog(
      {Key? key, required this.type, required this.onSuccess})
      : super(key: key);

  @override
  _VerificationDialogState createState() => _VerificationDialogState();
}

class _VerificationDialogState extends State<VerificationDialog> {
  final TextEditingController _valueController = TextEditingController();
  final _validationForm = GlobalKey<FormState>();
  bool isLoading = false;
  bool passwordInvisible = true;

  void validateOwner() {
    var pinLength = int.parse(_valueController.text.length.toString());
    if (widget.type == 'password' || (widget.type == 'pin' && pinLength == 4)) {
      BlocProvider.of<AppBloc>(context).add(
          VerifyAccountOwner(type: widget.type, value: _valueController.text));
    } else {
      String text = widget.type == 'pin' ? 'Transaction Pin' : 'Password';
      notify(context, "Validation Failed: Incorrect $text", "error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state is AccountVerified) {
          widget.onSuccess();
          BlocProvider.of<AppBloc>(context).add(UserChanged());
        } else if (state is ValidationFailed) {
          setState(() => isLoading = false);
          String text = widget.type == 'pin' ? 'Transaction Pin' : 'Password';
          notify(context, "Validation Failed: Incorrect $text", "error");
        } else if (state is Authenticating) {
          setState(() => isLoading = true);
        }
      },
      child: Dialog(
        alignment: Alignment.bottomCenter,
        insetPadding: const EdgeInsets.all(0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(40),
              topLeft: Radius.circular(40),
            ),
            color: Theme.of(context).colorScheme.background,
          ),
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height / 2.8,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Form(
                key: _validationForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Account Validation',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: Theme.of(context).accentColor),
                              ),
                              verticalSpacing(12),
                              Text(
                                "Enter your account's ${widget.type == 'pin' ? 'transaction pin' : 'password'} to continue",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                        color: Theme.of(context).accentColor),
                              )
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          icon: const SizedBox(
                            child: Icon(
                              CupertinoIcons.xmark,
                              size: 28,
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        verticalSpacing(40),
                        widget.type == 'pin'
                            ? PinInput(
                                controller: _valueController,
                                length: 4,
                              )
                            : TextInput(
                                label: 'Password',
                                obsecureText: passwordInvisible,
                                controller: _valueController,
                                bordered: true,
                                rules: MultiValidator(
                                  [
                                    RequiredValidator(
                                        errorText: "Password is required"),
                                    MinLengthValidator(6,
                                        errorText:
                                            "Password must be at least 6 characters"),
                                  ],
                                ),
                                suffixIcon: IconButton(
                                  color: AppColors.textFaded,
                                  splashRadius: 1,
                                  icon: Icon(!passwordInvisible
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined),
                                  onPressed: () => {
                                    setState(() {
                                      passwordInvisible =
                                          passwordInvisible ? false : true;
                                    })
                                  },
                                ),
                              ),
                        verticalSpacing(30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Button.primary(
                            onPressed: () async {
                              if (_validationForm.currentState!.validate() &&
                                  !isLoading) {
                                validateOwner();
                              }
                            },
                            title: !isLoading ? 'Continue' : 'Please wait...',
                            background: !isLoading
                                ? AppColors.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(.6),
                            foreground: AppColors.secoundaryLight,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
