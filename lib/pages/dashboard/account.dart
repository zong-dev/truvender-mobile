import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/cubits/profile/profile_cubit.dart';
import 'package:truvender/services/services.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/widgets/widgets.dart';

class DashboardAccountPage extends StatefulWidget {
  final Function onPageSelected;
  const DashboardAccountPage({Key? key, required this.onPageSelected})
      : super(key: key);

  @override
  _DashboardAccountPageState createState() => _DashboardAccountPageState();
}

class _DashboardAccountPageState extends State<DashboardAccountPage> {
  bool enabled = false;
  bool updating = false;
  bool hasSetWithdrawAccount = false;
  StorageUtil localStore = StorageUtil();
  var appBloc;

  Map<String, bool> deviceConfig = {
    "hideBalance": false,
    "biometricsEnabled": false,
  };

  changeOtp(value) async {
    setState(() {
      enabled = value;
      updating = true;
    });
    if (!updating) {
      bool authenticate = true;
      if (deviceConfig['biometricsEnabled'] == true) {
        authenticate = await LocalAuth.authenticate();
      }
      if (authenticate) {
        // ignore: use_build_context_synchronously
        BlocProvider.of<ProfileCubit>(context).updateSetting(
            notifyType: appBloc.authenticatedUser.notifyType,
            requireOtp: enabled);
      }
    }
  }

  openSetting({required String pane, double paneHeight = 400}) {
    context.pushNamed("settings", queryParams: {"type": pane});
  }

  loadDeviceConfig() async {
    bool biometricsEnabled = await localStore.getBoolVal("biometricsEnabled");
    bool hideBalance = await localStore.getBoolVal("hideBalance");
    setState(() {
      deviceConfig = {
        "hideBalance": hideBalance,
        "biometricsEnabled": biometricsEnabled,
      };
      appBloc = BlocProvider.of<ProfileCubit>(context).appBloc;
      enabled = appBloc.authenticatedUser.requireOtp;
      
      hasSetWithdrawAccount = appBloc.authenticatedUser.withdrawAccount != null &&appBloc.authenticatedUser.withdrawAccount['name'] != null;
    });
  }

  updateDeviceConfig(String config, value) async {
    if (config == "biometricsEnabled") {
      await localStore.getBoolVal("biometricsEnabled");
      final authenticate = await LocalAuth.authenticate();
      if (authenticate) {
        await localStore.setBoolVal("biometricsEnabled", value);
      }
    } else {
      await localStore.setBoolVal("hideBalance", value);
    }
    setState(() {
      deviceConfig[config] = value;
    });
  }

  @override
  void initState() {
    super.initState();
    loadDeviceConfig();
  }

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      topSpace: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AccountHeader(),
          Padding(
            padding: const EdgeInsets.only(top: 22, bottom: 12, left: 24),
            child: Text(
              "My Account",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.w900, fontSize: 16),
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                SettingTile(
                  label: "Profile Info",
                  iconLeft: CupertinoIcons.person_crop_circle,
                  iconRight: const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: TileButton(),
                  ),
                  onTap: () {
                    openSetting(
                        pane: "profile",
                        paneHeight: MediaQuery.of(context).size.height - 200);
                  },
                ),
                !hasSetWithdrawAccount ? SettingTile(
                  label: "Account Withdrawal",
                  iconLeft: Icons.account_balance_outlined,
                  iconRight: const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: TileButton(),
                  ),
                  onTap: () {
                    openSetting(
                        pane: "banking",
                        paneHeight: MediaQuery.of(context).size.height - 200);
                  },
                ): const SizedBox(),
                SettingTile(
                  label: "Notification",
                  iconLeft: CupertinoIcons.bell,
                  iconRight: const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: TileButton(),
                  ),
                  onTap: () {
                    openSetting(
                        pane: "notification",
                        paneHeight: MediaQuery.of(context).size.height - 200);
                  },
                ),
                SettingTile(
                  label: "Transaction PIN",
                  iconLeft: CupertinoIcons.circle_grid_3x3,
                  iconRight: const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: TileButton(),
                  ),
                  onTap: () {
                    openSetting(
                        pane: "pin",
                        paneHeight: MediaQuery.of(context).size.height - 200);
                  },
                ),
                SettingTile(
                  label: "Change Password",
                  iconLeft: Icons.lock_open,
                  iconRight: const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: TileButton(),
                  ),
                  onTap: () {
                    openSetting(
                        pane: "password",
                        paneHeight: MediaQuery.of(context).size.height - 200);
                  },
                ),
                SettingTile(
                  label: "Enable OTP",
                  iconLeft: CupertinoIcons.lock_shield_fill,
                  iconRight: Switch(
                    activeColor:
                        Theme.of(context).colorScheme.primary.withGreen(32),
                    activeTrackColor: Colors.grey.shade300,
                    inactiveThumbColor: AppColors.errorLight,
                    inactiveTrackColor: Colors.grey.shade300,
                    splashRadius: 50.0,
                    // boolean variable value
                    value: enabled,
                    // changes the state of the switch
                    onChanged: (value) => changeOtp(value),
                  ),
                ),
                SettingTile(
                  label: "Biometics Authentication",
                  iconLeft: Icons.fingerprint_rounded,
                  iconRight: Switch(
                    activeColor:
                        Theme.of(context).colorScheme.primary.withGreen(32),
                    activeTrackColor: Colors.grey.shade300,
                    inactiveThumbColor: AppColors.errorLight,
                    inactiveTrackColor: Colors.grey.shade300,
                    splashRadius: 50.0,
                    // boolean variable value
                    value: deviceConfig['biometricsEnabled'] ?? false,
                    // changes the state of the switch
                    onChanged: (value) =>
                        updateDeviceConfig("biometricsEnabled", value),
                  ),
                ),
                SettingTile(
                  label: "Hide Balance",
                  iconLeft: CupertinoIcons.eye,
                  iconRight: Switch(
                    activeColor:
                        Theme.of(context).colorScheme.primary.withGreen(32),
                    activeTrackColor: Colors.grey.shade300,
                    inactiveThumbColor: AppColors.errorLight,
                    inactiveTrackColor: Colors.grey.shade300,
                    splashRadius: 50.0,
                    // boolean variable value
                    value: deviceConfig['hideBalance'] ?? false,
                    // changes the state of the switch
                    onChanged: (value) =>
                        updateDeviceConfig("hideBalance", value),
                  ),
                ),
                SettingTile(
                  label: "Sign Out",
                  iconLeft: Icons.logout_rounded,
                  onTap: () {
                    BlocProvider.of<AppBloc>(context).add(SignOut());
                  },
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
