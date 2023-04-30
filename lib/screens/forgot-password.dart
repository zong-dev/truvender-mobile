import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:truvender/blocs/password/password_bloc.dart';
import 'package:truvender/data/repositories/repositories.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/notifier.dart';
import 'package:truvender/utils/spacing.dart';
import 'package:truvender/widgets/widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final AuthRepository authRepository;
  const ForgotPasswordScreen({Key? key, required this.authRepository})
      : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool sentInstruction = false;
  late String email;

  _onStateChanged(String sentTo) {
    setState(() {
      sentInstruction = true;
    });
    email = sentTo;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PasswordBloc>(
      create: (context) => PasswordBloc(authRepository: widget.authRepository),
      child: AuthWrapper(
        child: !sentInstruction
            ? ForgetForm(onChanged: (sentTo) => _onStateChanged(sentTo))
            : ResetForm(
                sentTo: email,
              ),
      ),
    );
  }
}

/* 
|==============================================================
|------------------- Forgot Password ---------------------------
|==============================================================
*/

class ForgetForm extends StatefulWidget {
  final Function onChanged;
  const ForgetForm({Key? key, required this.onChanged}) : super(key: key);

  @override
  _ForgetFormState createState() => _ForgetFormState();
}

class _ForgetFormState extends State<ForgetForm> {
  bool processing = false;
  final GlobalKey<FormState> _passwordKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();

  _sendInstruction() {
    BlocProvider.of<PasswordBloc>(context)
        .add(EmailSubmitted(email: _emailController.text));
  }

  toggleProcessing() {
    setState(() {
      processing = !processing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PasswordBloc, PasswordState>(
      listener: (context, state) {
        if (state is InstructionSent) {
          toggleProcessing();
          notify(context, "Check your email for Password reset instruction",
              'success');
          widget.onChanged(_emailController.text);
        } else if (state is PasswordFailed) {
          toggleProcessing();
          notify(context, "Record does not exist", 'error');
        } else if (state is PasswordLoading) {
          toggleProcessing();
        }
      },
      child: Form(
        key: _passwordKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuthHeader(
              actionText: 'Forgot Password?',
              description: "Let’s help you get right back in!",
            ),
            verticalSpacing(30),
            TextInput(
              label: 'Email Address',
              type: TextInputType.text,
              controller: _emailController,
              bordered: true,
              rules: MultiValidator(
                [
                  RequiredValidator(errorText: "Email is required."),
                  MaxLengthValidator(
                    100,
                    errorText: "Email must not be aove 100 characters long",
                  ),
                  EmailValidator(
                    errorText: "Enter a valid email",
                  )
                ],
              ),
            ),
            verticalSpacing(30),
            Button.primary(
              onPressed: () async {
                if (_passwordKey.currentState!.validate()) {
                  _sendInstruction();
                }
              },
              title: processing ? 'Sending Code.....' : 'Send Reset Code',
              background: !processing
                  ? AppColors.primary
                  : Theme.of(context).colorScheme.primary.withOpacity(.6),
              foreground: AppColors.secoundaryLight,
            ),
            verticalSpacing(22),
            const Divider(
              height: 6,
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => context.go('/signin'),
                    child: Text(
                      'Sign In instead',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* 
|==============================================================
|------------------- Reset Password ---------------------------
|==============================================================
*/
class ResetForm extends StatefulWidget {
  final String sentTo;
  const ResetForm({Key? key, required this.sentTo}) : super(key: key);

  @override
  _ResetFormState createState() => _ResetFormState();
}

class _ResetFormState extends State<ResetForm> {
  final GlobalKey<FormState> _passwordKey = GlobalKey();
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool enterNewPassword = false;
  bool processing = false;
  bool passwordInvisible = true;

  _resend() {
    BlocProvider.of<PasswordBloc>(context)
        .add(EmailSubmitted(email: widget.sentTo));
  }

  _submitResetForm() async {
    BlocProvider.of<PasswordBloc>(context).add(
      PasswordResetSubmitted(
          password: _passwordController.text,
          email: widget.sentTo,
          token: _tokenController.text),
    );
  }

  toggleProcessing() {
    setState(() {
      processing = !processing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PasswordBloc, PasswordState>(
      listener: (context, state) async {
        if (state is PasswordResetComplete) {
          toggleProcessing();
          notify(context, "Password sucessfully updated", "success");
          context.go('/signin');
        } else if (state is PasswordLoading) {
          toggleProcessing();
        } else if (state is PasswordFailed) {
          toggleProcessing();
          notify(context, "Invalid or expire token", "error");
        }
      },
      child: BlocBuilder<PasswordBloc, PasswordState>(
        builder: (context, state) {
          return Form(
            key: _passwordKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthHeader(
                  actionText: 'Reset Password?',
                  description: "Let’s help you get right back in!",
                ),
                verticalSpacing(30),
                TextInput(
                  label: 'Token',
                  type: TextInputType.text,
                  controller: _tokenController,
                  bordered: true,
                  rules: MultiValidator(
                    [
                      RequiredValidator(errorText: "Token is required."),
                      MaxLengthValidator(
                        6,
                        errorText: "Token must be 6 characters long",
                      ),
                    ],
                  ),
                ),
                verticalSpacing(20),
                TextInput(
                  label: 'New Password',
                  obsecureText: passwordInvisible,
                  controller: _passwordController,
                  bordered: true,
                  rules: MultiValidator(
                    [
                      RequiredValidator(errorText: "Password is required"),
                      MinLengthValidator(8,
                          errorText: "Password must be at least 8 characters"),
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
                        passwordInvisible = passwordInvisible ? false : true;
                      })
                    },
                  ),
                ),
                verticalSpacing(30),
                Button.primary(
                  onPressed: () async {
                    if (_passwordKey.currentState!.validate() && !processing) {
                      _submitResetForm();
                    }
                  },
                  title: processing ? 'Please Wait...' : 'Reset My Password',
                  background: !processing
                      ? AppColors.primary
                      : Theme.of(context).colorScheme.primary.withOpacity(.6),
                  foreground: AppColors.secoundaryLight,
                ),
                verticalSpacing(22),
              ],
            ),
          );
        },
      ),
    );
  }
}
