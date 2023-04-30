import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';
import '../blocs/register/register_bloc.dart';

class VerificationScreen extends StatelessWidget {
  final String? email;
  final String? phone;
  final String? vType;

  const VerificationScreen(
      {Key? key, required this.email, required this.phone, this.vType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthWrapper(
      child: VerificationForm(
        email: email,
        vType: vType,
        phone: phone,
      ),
    );
  }
}

class VerificationForm extends StatefulWidget {
  final String? email;
  final String? phone;
  final String? vType;
  const VerificationForm(
      {Key? key, required this.email, required this.phone, this.vType})
      : super(key: key);

  @override
  _VerificationFormState createState() => _VerificationFormState();
}

class _VerificationFormState extends State<VerificationForm> {
  final TextEditingController _tokenController = TextEditingController();
  final _verificationForm = GlobalKey<FormState>();
  String verify = "email";
  bool processing = false;

  @override
  void initState() {
    super.initState();
    if (widget.vType != null) {
      verify = widget.vType!;
    }
  }

  void _resendVerificationToken() {
    if (!processing) {
      BlocProvider.of<RegisterBloc>(context).add(
        SendVerificationCode(
          type: verify,
          sendTo: verify == 'email' ? widget.email : widget.phone,
        ),
      );
    }
  }

  void _verifyEmailOrPhone() {
    if (_verificationForm.currentState!.validate() && !processing) {
      BlocProvider.of<RegisterBloc>(context).add(
        AccountVerification(
          type: verify,
          token: _tokenController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is EmailVerified) {
          _tokenController.clear();
          setState(() {
            processing = false;
            verify = 'phone';
          });
        } else if (state is RegisterLoading) {
          setState(() {
            processing = true;
          });
        } else if (state is VerificationFailed) {
          notify(context, "Invalid or expired token!", 'error');
        } else if (state is PhoneVerified) {
          setState(() {
            processing = false;
          });
        } else if (state is ResentVerificationCode) {
          notify(context, "A new verification token was sent to your $verify",
              'successfully');
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Form(
            key: _verificationForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthHeader(
                    actionText: 'Account Verification',
                    description:
                        "Check ${verify == 'email' ? widget.email : widget.phone} for verification code."),
                verticalSpacing(30),
                TextInput(
                  label: '${ucFirst(verify)} Verification Token',
                  obsecureText: false,
                  controller: _tokenController,
                  bordered: true,
                  rules: MultiValidator(
                    [
                      RequiredValidator(errorText: "Token is required"),
                      MinLengthValidator(6,
                          errorText: "Token must be at least 6 characters"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => _resendVerificationToken(),
                        child: Text(
                          'Resend Code',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                verticalSpacing(30),
                Button.primary(
                  onPressed: () => _verifyEmailOrPhone(),
                  title: processing
                      ? "Please Wait..."
                      : "Verify ${ucFirst(verify)}",
                  background: processing
                      ? Theme.of(context).colorScheme.primary.withOpacity(.6)
                      : AppColors.primary,
                  foreground: AppColors.secoundaryLight,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
