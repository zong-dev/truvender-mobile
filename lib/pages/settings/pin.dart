// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

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

class PinSettingPage extends StatefulWidget {
  const PinSettingPage({Key? key}) : super(key: key);

  @override
  _PinSettingPageState createState() => _PinSettingPageState();
}

class _PinSettingPageState extends State<PinSettingPage> {
  bool showPin = true;
  bool updating = false;
  bool isCreate = false;

  final TextEditingController _cPinController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final GlobalKey<FormState> _pinForm = GlobalKey<FormState>();
  StorageUtil localStore = StorageUtil();

  var appBloc;

  @override
  void initState() {
    super.initState();
    appBloc = BlocProvider.of<AppBloc>(context);
    if (!appBloc.authenticatedUser.hasPin) {
      setState(() => isCreate = true);
    }
  }

  _resetPin() async {
    var biometricsIsEnabled = await localStore.getBoolVal('biometricsEnabled');
    if (_pinForm.currentState!.validate()) {
      bool authenticate = true;
      if (biometricsIsEnabled) {
        authenticate = await LocalAuth.authenticate();
      }
      if(authenticate){
        BlocProvider.of<ProfileCubit>(context).updatOrCreatePin(
            currentPin: _cPinController.text, newPin: _pinController.text);
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
          notify(context, "Request Failed: Pin does not match", "error");
        } else if (state is RequestSuccess) {
          setState(() => updating = false);
          
          notify(context, "Transaction pin updated!",
              "success");
          appBloc.localNotificationService.showNotification(
              id: 1,
              title: "Pin Updated!",
              body: "Transaction pin successfully updated");
          appBloc.add(UserChanged());
        }
      },
      child: Wrapper(
        title: "Transaction Pin",
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 26),
          child: Form(
            key: _pinForm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Change your transaction Pin",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).accentColor),
                ),
                !isCreate ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpacing(30),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 12),
                      child: Text(
                        "Current Pin",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                      ),
                    ),
                    TextInput(
                      label: "******",
                      controller: _cPinController,
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 12),
                      type: TextInputType.number,
                      bordered: true,
                      readOnly: false,
                      obsecureText: showPin,
                      suffixIcon: GestureDetector(
                        onTap: () => setState(() {
                          showPin = !showPin;
                        }),
                        child: Icon(
                          showPin
                              ? CupertinoIcons.eye_slash_fill
                              : CupertinoIcons.eye_fill,
                          size: 24,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      rules: MultiValidator([
                        RequiredValidator(
                            errorText: "Current pin is required"),
                        MaxLengthValidator(6,
                            errorText: "Pin must be at least 6 characters"),
                      ]),
                    ),
                  ],
                ) : const SizedBox(),
                verticalSpacing(28),
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 12),
                  child: Text(
                    "New Pin",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                  ),
                ),
                TextInput(
                  label: "******",
                  controller: _pinController,
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                  type: TextInputType.number,
                  bordered: true,
                  readOnly: false,
                  obsecureText: showPin,
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() {
                      showPin = !showPin;
                    }),
                    child: Icon(
                      showPin
                          ? CupertinoIcons.eye_slash_fill
                          : CupertinoIcons.eye_fill,
                      size: 24,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  rules: MultiValidator([
                    RequiredValidator(errorText: "Pin is required"),
                    MaxLengthValidator(6,
                        errorText: "Pin must be at least 6 characters"),
                  ]),
                ),
                verticalSpacing(38),
                Button.primary(
                  onPressed: () => _resetPin(),
                  title: 'Save Changes',
                  background: AppColors.primary,
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
