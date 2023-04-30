import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/blocs/login/login_bloc.dart';
import 'package:truvender/cubits/otp/otp_cubit.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class OtpChallengeScreen extends StatefulWidget {
  const OtpChallengeScreen({Key? key}) : super(key: key);

  @override
  _OtpChallengeScreenState createState() => _OtpChallengeScreenState();
}

class _OtpChallengeScreenState extends State<OtpChallengeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<OtpCubit>(
      create: (context) => OtpCubit(appBloc: BlocProvider.of<AppBloc>(context)),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 60.0, 24.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthHeader(
                  description:
                      'Sign in sucessful, enter the code sent to your email to continue',
                  actionText: 'OTP',
                ),
                const OtpForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OtpForm extends StatefulWidget {
  const OtpForm({Key? key}) : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  bool isLoading = false;
  final TextEditingController _firstValueController = TextEditingController();
  final TextEditingController _secondValueController = TextEditingController();
  final TextEditingController _thirdValueController = TextEditingController();
  final TextEditingController _fourthValueController = TextEditingController();
  final TextEditingController _fifthValueController = TextEditingController();

  _handleSubmit() {
    String token =
        "${_firstValueController.text}${_secondValueController.text}${_thirdValueController.text}${_fourthValueController}${_fifthValueController}";
    if (token.length == 5) {
      BlocProvider.of<OtpCubit>(context).verifyToken(token: token,);
    }
  }

  _resendOtp() {
    BlocProvider.of<OtpCubit>(context).resendToken();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OtpCubit, OtpState>(
      listener: (context, state) {
        if(state is ProcessingOtpRequest){
          setState(() => isLoading = true);
        }else if(state is OtpRequestFailed){
          setState(() => isLoading = false);
          notify(context, "Invalid or expired token", "error");
        }else if(state is OtpVerified){
          setState(() => isLoading = false);
          BlocProvider.of<AppBloc>(context).add(UserChanged());
        }else if(state is OtpError){
          setState(() => isLoading = false);
        }else if(state is ResentOtp){
          setState(() => isLoading = false);
          notify(context, "Token was sent successfully to your email address", "success");
        }
      },
      child: Form(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OtpInput(
                  controller: _firstValueController,
                  autoFocus: true,
                ),
                OtpInput(
                  controller: _secondValueController,
                  autoFocus: false,
                ),
                OtpInput(
                  controller: _secondValueController,
                  autoFocus: false,
                ),
                OtpInput(
                  controller: _fourthValueController,
                  autoFocus: false,
                ),
                OtpInput(
                  controller: _fifthValueController,
                  autoFocus: false,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => _resendOtp(),
                    child: Text(
                      'Resend Otp',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            verticalSpacing(36),
            Button.primary(
              onPressed: () {
                if (!isLoading) {
                  _handleSubmit();
                }
              },
              title: !isLoading ? 'Continue' : 'Authenticating...',
              background: !isLoading
                  ? AppColors.primary
                  : Theme.of(context).colorScheme.primary.withOpacity(.6),
              foreground: AppColors.secoundaryLight,
            ),
          ],
        ),
      ),
    );
  }
}

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  const OtpInput({Key? key, required this.controller, this.autoFocus = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 50,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Theme.of(context).accentColor,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          counterText: '',
          hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: AppColors.textFaded,
              ),
          labelStyle: TextStyle(
            color: AppColors.textFaded,
            backgroundColor: Theme.of(context).cardColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
