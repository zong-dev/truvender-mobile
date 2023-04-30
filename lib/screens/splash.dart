// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import '../services/services.dart';
import '../widgets/logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool authenticated = false;
  StorageUtil strUtl = StorageUtil();

  @override
  void initState() {
    super.initState();
    _delaySplash();
  }

  _delaySplash() async {
    Future.delayed(const Duration(seconds: 2), () {
      BlocProvider.of<AppBloc>(context).add(AppStarted());
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: LogoWidget(
          withText: true,
        ),
      ),
    );
  }
}
