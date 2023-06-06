import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/blocs/register/register_bloc.dart';
import 'package:truvender/data/repositories/auth.dart';
import 'package:truvender/utils/notifier.dart';
import 'package:truvender/utils/spacing.dart';
import 'package:truvender/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme.dart';

class RegisterScreen extends StatelessWidget {
  final AuthRepository authRepository;
  const RegisterScreen({Key? key, required this.authRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
      create: (context) {
        return RegisterBloc(authRepository: authRepository, appBloc: BlocProvider.of<AppBloc>(context));
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
                    description:
                        'Open your trading account with just few touches.',
                    actionText: 'Create Account',
                  ),
                  const SignupForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _registerFormKey = GlobalKey<FormState>();
  bool passwordInvisible = true;
  bool processing = false;

  Future<void> _launchUrl() async {
    if (!await launchUrl(
        Uri.parse('https://truvender.com/company/legal/terms'))) {
      throw Exception(
          'Could not launch https://truvender.com/company/legal/terms');
    }
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _referrerController = TextEditingController();

  Map countryData = { "country": "NG", "currency": "NGN"};
  bool isValidPhoneNumber = false;

  _submitSignUpForm() async {
    BlocProvider.of<RegisterBloc>(context).add(SignupFormSubmitted(
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      phone: _phoneController.text.trim(),
      country: countryData['country'],
      currency: countryData['currency'],
    ));
  }

  _getCountryFromIso(String isoCode){
     Country country = CountryPickerUtils.getCountryByIsoCode(isoCode);
     setState(() {
       countryData = { "country": country.isoCode, "currency": country.currencyCode };
     });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegistrationFailed) {
          notify(context, state.message, 'error');
          setState(() {
            processing = false;
          });
        } else if (state is RegisterSuccess) {
          setState(() {
            processing = false;
          });
          notify(context, 'Account creation successful', 'success');
          // Redirect After Signup
          BlocProvider.of<AppBloc>(context).add(SignOut());
        } else if (state is RegisterLoading) {
          setState(() {
            processing = true;
          });
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Form(
            key: _registerFormKey,
            child: Column(
              children: [
                verticalSpacing(24),
                TextInput(
                  label: 'Username *',
                  type: TextInputType.text,
                  controller: _usernameController,
                  bordered: true,
                  rules: MultiValidator(
                    [
                      RequiredValidator(errorText: "Username is required."),
                      MaxLengthValidator(
                        100,
                        errorText: "Username must be below 100 characters long",
                      ),
                    ],
                  ),
                ),
                verticalSpacing(20),
                TextInput(
                  label: 'Email Address *',
                  type: TextInputType.emailAddress,
                  controller: _emailController,
                  bordered: true,
                  rules: MultiValidator(
                    [
                      RequiredValidator(errorText: "Email is required."),
                      MaxLengthValidator(
                        100,
                        errorText: "Email must be below 100 characters long",
                      ),
                      EmailValidator(
                        errorText: "Enter a valid email",
                      )
                    ],
                  ),
                ),
                verticalSpacing(20),
                PhoneInput(
                  controller: _phoneController,
                  bordered: true,
                  onChange: (String isoCode) => _getCountryFromIso(isoCode)
                ),
                // verticalSpacing(20),
                // TextInput(
                //   label: 'Referrer Username (optional)',
                //   type: TextInputType.text,
                //   controller: _referrerController,
                //   bordered: true,
                //   rules: MultiValidator(
                //     [
                //       MaxLengthValidator(
                //         100,
                //         errorText: "Username must be below 100 characters long",
                //       ),
                //     ],
                //   ),
                // ),
                verticalSpacing(20),
                TextInput(
                  label: 'Password *',
                  type: TextInputType.text,
                  obsecureText: passwordInvisible,
                  controller: _passwordController,
                  bordered: true,
                  rules: MultiValidator(
                    [
                      RequiredValidator(
                        errorText: "Password is required.",
                      ),
                      MinLengthValidator(8,
                          errorText: "Password must be atleast 8 characters"),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Checkbox(),
                    verticalSpacing(12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'By creating an account, you agree to our',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: AppColors.textFaded,
                                  ),
                        ),
                        horizontalSpacing(4),
                        GestureDetector(
                          onTap: _launchUrl,
                          child: Text(
                            'Terms & Conditions',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                verticalSpacing(40),
                Button.primary(
                  onPressed: () {
                    if (!processing) {
                      if (_registerFormKey.currentState!.validate()) {
                        _submitSignUpForm();
                      }
                    }
                  },
                  title: processing ? "Creating account..." : "Continue",
                  background: !processing ? AppColors.primary.withOpacity(.7) : Theme.of(context).colorScheme.primary.withOpacity(.6),
                  foreground: Colors.white,
                ),
                verticalSpacing(30),
                const Divider(
                  height: 6,
                  thickness: 2,
                ),
                verticalSpacing(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: AppColors.textFaded,
                          fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/signin'),
                      child: Text(
                        'Sign in',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
