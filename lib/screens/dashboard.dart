import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/cubits/profile/profile_cubit.dart';
import 'package:truvender/pages/pages.dart';
import 'package:truvender/widgets/widgets.dart';

import '../utils/utils.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ValueNotifier<int> pageIndex = ValueNotifier(0);

  final ValueNotifier<String> title = ValueNotifier("Messages");

  final pageTitles = const ["Home", "Wallet", "Trades", "My Account"];

  void _onNavigationItemSelected(index) {
    currentNavPage = index;
    pageIndex.value = index;
    title.value = pageTitles[index];
  }

  DateTime pre_backpress = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (context) =>
          ProfileCubit(appBloc: BlocProvider.of<AppBloc>(context)),
      child: WillPopScope(
          child: Scaffold(
            body: ValueListenableBuilder(
              valueListenable: pageIndex,
              builder: (BuildContext context, int value, _) {
                final List pages = [
                  DashboardHomePage(
                    onPageSelected: _onNavigationItemSelected,
                  ),
                  DashboardWalletPage(
                      onPageSelected: _onNavigationItemSelected),
                  DashboardTradesPage(
                      onPageSelected: _onNavigationItemSelected),
                  DashboardAccountPage(
                      onPageSelected: _onNavigationItemSelected),
                ];
                return pages[value];
              },
            ),
            bottomNavigationBar: BottomNavigator(
              onItemSelected: _onNavigationItemSelected,
            ),
          ),
          onWillPop: () async {
            final timegap = DateTime.now().difference(pre_backpress);
            final cantExit = timegap >= const Duration(seconds: 3);
            pre_backpress = DateTime.now();
            if (cantExit) {
              toastMessage(message: "Press again to exit", context:  context);
              return false; // false will do nothing when back press
            } else {
              return true; // true will exit the app
            }
          }),
    );
  }
}
