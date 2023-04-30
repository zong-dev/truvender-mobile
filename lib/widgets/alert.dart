// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/services/services.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/spacing.dart';
import 'package:truvender/widgets/widgets.dart';

class BiometricsDialog extends StatefulWidget {
  final String token;
  final String email;
  final String password;
  const BiometricsDialog({Key? key, required this.token, required this.email, required this.password}) : super(key: key);

  @override
  State<BiometricsDialog> createState() => _BiometricsDialogState();
}

class _BiometricsDialogState extends State<BiometricsDialog> {
  StorageUtil localStore = StorageUtil();
  FlutterSecureStorage storage = const FlutterSecureStorage();
  

  void enableBiometrics() async {
    final authenticate = await LocalAuth.authenticate();
    if(authenticate){
      await localStore.setBoolVal("biometricsEnabled", true);
      await storage.write(key: "username", value: widget.email);
      await storage.write(key: "password", value: widget.password);
      _setAsOpened();
      // Navigator.pop(context);
    }
  }

  _setAsOpened() async {
    await localStore.setBoolVal("openedBiometricsAlert", true);
    BlocProvider.of<AppBloc>(context).add(SignedIn(token: widget.token));
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(14),
                ),
                color: Theme.of(context).colorScheme.background,
              ),
              height: 240,
              padding: const EdgeInsets.fromLTRB(30, 40, 30, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  verticalSpacing(8),
                  Text(
                    "Enable Biometrics",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  verticalSpacing(6),
                  Text(
                    "Enable biometrics for easy sign in",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  verticalSpacing(18),
                  Button.primary(
                    onPressed: () {
                      enableBiometrics();
                    },
                    title: 'Enable Biometrics',
                    height: 48,
                    radius: 12,
                    background: Theme.of(context).colorScheme.primary,
                  ),
                  verticalSpacing(16),
                  GestureDetector(
                    onTap: () {
                      _setAsOpened();
                    },
                    child: Text(
                      "Not now",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: Theme.of(context).accentColor),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: -40,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secoundaryLight,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.fingerprint_rounded,
                  size: 68.6,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      );
  }
}
