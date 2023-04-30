// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/cubits/profile/profile_cubit.dart';
import 'package:truvender/services/services.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class NotificationSettingPage extends StatefulWidget {
  const NotificationSettingPage({Key? key}) : super(key: key);

  @override
  _NotificationSettingPageState createState() =>
      _NotificationSettingPageState();
}

class _NotificationSettingPageState extends State<NotificationSettingPage> {
  StorageUtil localStore = StorageUtil();
  bool emailNotify = false;
  bool appNotify = false;
  bool updating = false;
  var appBloc;

  _updateSetting() async {
    int notifyType = 0;
    if (emailNotify && appNotify) {
      notifyType = 2;
    } else if (emailNotify && !appNotify) {
      notifyType = 1;
    } else if (!emailNotify && appNotify) {
      notifyType = 0;
    }
    if (notifyType != appBloc.authenticatedUser.notifyType && !updating) {
      var biometricsIsEnabled =
          await localStore.getBoolVal('biometricsEnabled');
      bool authenticate = true;
      if (biometricsIsEnabled) {
        authenticate = await LocalAuth.authenticate();
      }
      if (authenticate) {
        // ignore: use_build_context_synchronously
        BlocProvider.of<ProfileCubit>(context).updateSetting(
            notifyType: notifyType,
            requireOtp: appBloc.authenticatedUser.requireOtp);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    appBloc = BlocProvider.of<AppBloc>(context);
    int notifyType = appBloc.authenticatedUser.notifyType;
    setState(() {
      appNotify = notifyType == 0 || notifyType == 2 ? true : false;
      emailNotify = notifyType == 1 || notifyType == 2 ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProcessingRequest) {
          setState(() => updating = true);
        } else if (state is RequestFailed) {
          setState(() => updating = false);
          notify(context, "Request Failed: Something went wrong, try again later.", "error");
        } else if (state is RequestSuccess) {
          setState(() => updating = false);
          notify(context, "Settings Updated Successfully!",
              "success");
          var appBloc = BlocProvider.of<AppBloc>(context);
          appBloc.localNotificationService.showNotification(
              id: 1,
              title: "Settings Updated!",
              body:
                  "Settings updated successfully");
          appBloc.add(UserChanged());
        }
      },
      child: Wrapper(
        title: "Notification",
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Choose account notification preference",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).accentColor),
                ),
              ),
              verticalSpacing(30),
              SettingTile(
                label: "Email Notification",
                iconLeft: CupertinoIcons.envelope_open_fill,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                iconRight: Switch(
                  activeColor:
                      Theme.of(context).colorScheme.primary.withGreen(32),
                  activeTrackColor: Colors.grey.shade300,
                  inactiveThumbColor: AppColors.errorLight,
                  inactiveTrackColor: Colors.grey.shade300,
                  splashRadius: 50.0,
                  // boolean variable value
                  value: emailNotify,
                  // changes the state of the switch
                  onChanged: (value) => setState(
                    () => emailNotify = value,
                  ),
                ),
              ),
              SettingTile(
                label: "App Notification",
                iconLeft: Icons.notifications_active_rounded,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                iconRight: Switch(
                  activeColor:
                      Theme.of(context).colorScheme.primary.withGreen(32),
                  activeTrackColor: Colors.grey.shade300,
                  inactiveThumbColor: AppColors.errorLight,
                  inactiveTrackColor: Colors.grey.shade300,
                  splashRadius: 50.0,
                  // boolean variable value
                  value: appNotify,
                  // changes the state of the switch
                  onChanged: (value) => setState(
                    () => appNotify = value,
                  ),
                ),
              ),
              verticalSpacing(38),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Button.primary(
                  onPressed: () => _updateSetting(),
                  title: 'Save Changes',
                  background: !updating ? AppColors.primary : Theme.of(context).colorScheme.primary.withOpacity(.6),
                  foreground: AppColors.secoundaryLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
