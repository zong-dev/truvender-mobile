// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/blocs/login/login_bloc.dart';
import 'package:truvender/data/repositories/auth.dart';
import 'package:truvender/services/services.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/spacing.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../utils/notifier.dart';

class SigninScreen extends StatelessWidget {
  final AuthRepository authRepository;

  const SigninScreen({Key? key, required this.authRepository})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
  
    return BlocProvider<LoginBloc>(
      create: (context) {
        return LoginBloc(
          appBloc: BlocProvider.of<AppBloc>(context),
          authRepository: authRepository,
        );
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 60.0, 24.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthHeader(
                    description: 'Sign in to your account to continue.',
                    actionText: 'Welcome Back!',
                  ),
                  const SigninForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SigninForm extends StatefulWidget {
  const SigninForm({Key? key}) : super(key: key);

  @override
  _SigninFormState createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  StorageUtil localStore = StorageUtil();
  FlutterSecureStorage storage = const FlutterSecureStorage();

  final _loginFormKey = GlobalKey<FormState>();
  bool passwordInvisible = true;
  bool authenticated = false;
  bool biometricsEnabled = false;
  bool isLoading = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _authenticateWithBiometrics() async {
    final authenticate = await LocalAuth.authenticate();
    if (authenticate) {
      String? username = await storage.read(key: 'username');
      String? password = await storage.read(key: 'password');
      if (username != null && password != null) {
        _usernameController.text = username;
        _passwordController.text = password;
        _onLoginSubmitted();
        setState(() {
          authenticated = authenticate;
        });
      }
    }
  }

  void _canUseBiometrics() async {
    var biometricsIsEnabled = await localStore.getBoolVal('biometricsEnabled');
    if (biometricsIsEnabled) {
      setState(() {
        biometricsEnabled = biometricsIsEnabled == true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _canUseBiometrics();
  }

  setAsAuthenticated(token){
    BlocProvider.of<AppBloc>(context).add(SignedIn(token: token));
  }

  _onLoginSubmitted() async {
    BlocProvider.of<LoginBloc>(context).add(
      LoginFormSubmitted(
        username: _usernameController.text,
        password: _passwordController.text,
      ),
    );
  }

  void biometricsAlertHandler(String token) async {
    var alertOpen = await localStore.getBoolVal('openedBiometricsAlert');
    if (!alertOpen || alertOpen == null) {
      openModal(
        context: context, 
        child: BiometricsDialog(
          token: token,
          email: _usernameController.text,
          password: _passwordController.text
        )
      );
    }else {
      BlocProvider.of<AppBloc>(context).add(SignedIn(token: token));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state is LoginFailed) {
          notify(context, 'Invalid username or password!', 'error');
          setState(() {
            isLoading = false;
          });
        } else if (state is LoginLoading){
          setState(() {
            isLoading = true;
          });
        } else if(state is LoginSucess){
          biometricsAlertHandler(state.token);
          setState(() {
            isLoading = false;
          });
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        return Form(
          key: _loginFormKey,
          child: Column(
            children: [
              verticalSpacing(24),
              TextInput(
                label: 'Email or Username',
                type: TextInputType.text,
                controller: _usernameController,
                bordered: true,
                rules: MultiValidator(
                  [
                    RequiredValidator(errorText: "Username is required."),
                    MaxLengthValidator(100,
                        errorText:
                            "Username must be below 100 characters long"),
                  ],
                ),
              ),
              verticalSpacing(20),
              TextInput(
                label: 'Password',
                obsecureText: passwordInvisible,
                controller: _passwordController,
                bordered: true,
                rules: MultiValidator(
                  [
                    RequiredValidator(errorText: "Password is required"),
                    MinLengthValidator(6,
                        errorText: "Password must be at least 6 characters"),
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
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => context.push('/forgotPassword'),
                      child: Text(
                        'Forgot Password?',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpacing(30),
              Row(
                children: [
                  Expanded(
                    child: Button.primary(
                      onPressed: () async {
                        if (_loginFormKey.currentState!.validate() && !isLoading) {
                          _onLoginSubmitted();
                        }
                      },
                      title:!isLoading ? 'Sign in' : 'Please wait...',
                      background: !isLoading ? AppColors.primary: Theme.of(context).colorScheme.primary.withOpacity(.6) ,
                      foreground: AppColors.secoundaryLight,
                    ),
                  ),
                  horizontalSpacing(8),
                  biometricsEnabled
                      ? Button.light(
                          onPressed: () => _authenticateWithBiometrics(),
                          icon: Icons.fingerprint_rounded,
                          iconSize: 34,
                          width: 62.6,
                          height: 54,
                        )
                      : const SizedBox(),
                ],
              ),
              verticalSpacing(36),
              const Divider(
                height: 6,
                thickness: 2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: AppColors.textFaded,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/signup'),
                      child: Text(
                        'Sign up',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
