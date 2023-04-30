// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/cubits/profile/profile_cubit.dart';
import 'package:truvender/services/services.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class PasswordSettingPage extends StatefulWidget {
  const PasswordSettingPage({Key? key}) : super(key: key);

  @override
  _PasswordSettingPageState createState() => _PasswordSettingPageState();
}

class _PasswordSettingPageState extends State<PasswordSettingPage> {
  bool hidePassword = true;
  bool updating = false;
  StorageUtil localStore = StorageUtil();


  final TextEditingController _cPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _passwordForm = GlobalKey<FormState>();

  _resetPassword() async {
    var biometricsIsEnabled = await localStore.getBoolVal('biometricsEnabled');
    if (_passwordForm.currentState!.validate()) {
      bool authenticate = true;
      if(biometricsIsEnabled){
       authenticate = await LocalAuth.authenticate();
      }
      if(authenticate){
        BlocProvider.of<ProfileCubit>(context).updatePassword(
            currentPassword: _cPasswordController.text,
            newPassword: _passwordController.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProcessingRequest) {
          setState(() => updating = true);
        } else if (state is RequestFailed) {
          setState(() => updating = false);
          notify(context, "Request Failed: Password does not match", "error");
        } else if (state is RequestSuccess) {
          setState(() => updating = false);
          notify(context, "Password changed successfully! Sign in to continue",
              "success");
          var appBloc = BlocProvider.of<AppBloc>(context);
          appBloc.localNotificationService.showNotification(
              id: 1,
              title: "Password Updated!",
              body: "Password updated successfully, Sign in to continue with your account"
          );
          appBloc.add(SignOut());
        }
      },
      child: Wrapper(
        title: "Password",
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 26),
          child: Form(
            key: _passwordForm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Change your account password",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).accentColor),
                ),
                verticalSpacing(30),
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 12),
                  child: Text(
                    "Current Password",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                  ),
                ),
                TextInput(
                  label: "*********",
                  controller: _cPasswordController,
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                  type: TextInputType.text,
                  bordered: true,
                  readOnly: false,
                  obsecureText: hidePassword,
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() {
                      hidePassword = !hidePassword;
                    }),
                    child: Icon(
                      hidePassword
                          ? CupertinoIcons.eye_slash_fill
                          : CupertinoIcons.eye_fill,
                      size: 24,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  rules: MultiValidator([
                    RequiredValidator(errorText: "Current password is required")
                  ]),
                ),
                verticalSpacing(28),
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 12),
                  child: Text(
                    "New Password",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                  ),
                ),
                TextInput(
                  label: "*********",
                  controller: _passwordController,
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                  type: TextInputType.text,
                  bordered: true,
                  readOnly: false,
                  obsecureText: hidePassword,
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() {
                      hidePassword = !hidePassword;
                    }),
                    child: Icon(
                      hidePassword
                          ? CupertinoIcons.eye_slash_fill
                          : CupertinoIcons.eye_fill,
                      size: 24,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  rules: MultiValidator([
                    RequiredValidator(errorText: "Password is required"),
                    MinLengthValidator(6,
                        errorText: "Password must be at least 6 characters"),
                  ]),
                ),
                verticalSpacing(38),
                Button.primary(
                  onPressed: () => _resetPassword(),
                  title: 'Save Changes',
                  background: updating
                      ? Theme.of(context).colorScheme.primary.withOpacity(.6)
                      : AppColors.primary,
                  foreground: AppColors.secoundaryLight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
