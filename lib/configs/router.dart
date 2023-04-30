import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/cubits/asset/asset_cubit.dart';
import 'package:truvender/cubits/bills/bills_cubit.dart';
import 'package:truvender/cubits/profile/profile_cubit.dart';
import 'package:truvender/cubits/wallet/wallet_cubit.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/pages/pages.dart';
import 'package:truvender/screens/forgot-password.dart';
import 'package:truvender/screens/screens.dart';
import '../data/repositories/repositories.dart';

class AppRouter {
  final AppBloc appBloc;
  AppRouter(this.appBloc);

  late final GoRouter router = GoRouter(
    errorBuilder: (context, state) => const ErrorScreen(),
    refreshListenable: GoRouterRefreshStream(appBloc.stream),
    redirect: (BuildContext context, GoRouterState state) async {
      final blocstate = context.read<AppBloc>().state;
      final location = state.location;

      if (blocstate is Unauthenticated &&
          location != '/signin' &&
          location != '/forgotPassword' &&
          location != '/signup') {
        return "/signin";
      } else if (blocstate is Initialized && location != '/welcome') {
        return '/welcome';
      } else if (blocstate is Initializing) {
        return '/splash';
      } else if (blocstate is Loading) {
        return '/loading';
      } else if (blocstate is Authenticated &&
          (blocstate.user.email_verified_at == null ||
              blocstate.user.phone_verified_at == null)) {
        return '/verification';
      } else if(blocstate is OtpChallenge && location != '/otp-challenge') {
        return '/otp-challenge';
      }else {
        
      }
    },
    routes: <GoRoute>[
      GoRoute(
        path: '/splash',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const DashboardScreen();
        },
      ),
      GoRoute(
        path: '/loading',
        builder: (BuildContext context, GoRouterState state) {
          return const LoadingPage();
        },
      ),
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (BuildContext context, GoRouterState state) {
          return const WelcomeScreen();
        },
      ),

      /**
       * 
       * ========================== Authentication =======================
       */
      GoRoute(
          path: '/forgotPassword',
          name: 'forgot-password',
          builder: (BuildContext context, GoRouterState state) {
            final AuthRepository authRepository =
                BlocProvider.of<AppBloc>(context).authRepository;
            return ForgotPasswordScreen(authRepository: authRepository);
          }),
      GoRoute(
        path: '/signin',
        name: 'signIn',
        builder: (BuildContext context, GoRouterState state) {
          final AuthRepository authRepository =
              BlocProvider.of<AppBloc>(context).authRepository;
          return SigninScreen(authRepository: authRepository);
        },
      ),
      GoRoute(
        path: '/signup',
        name: 'signUp',
        builder: (BuildContext context, GoRouterState state) {
          final AuthRepository authRepository =
              BlocProvider.of<AppBloc>(context).authRepository;
          return RegisterScreen(authRepository: authRepository);
        },
      ),
      GoRoute(
        path: '/otp-challenge',
        name: 'OTP',
        builder: (BuildContext context, GoRouterState state) {
          return const OtpChallengeScreen();
        },
      ),

      /**
       * 
       * ========================== Account Verification =======================
       */
      GoRoute(
          path: '/verification',
          name: 'verification',
          builder: (BuildContext context, GoRouterState state) {
            var authenticatedUser =
                BlocProvider.of<AppBloc>(context).authenticatedUser;
            String verifyType = "email";
            if (authenticatedUser.phone_verified_at == null &&
                authenticatedUser.email_verified_at != null) {
              verifyType = "phone";
            }
            return VerificationScreen(
              vType: verifyType,
              email: authenticatedUser.email,
              phone: authenticatedUser.phone,
            );
          }),

      /**
       * 
       * ========================== Kyc Verification =======================
       */
      GoRoute(
        path: '/kyc',
        builder: (BuildContext context, GoRouterState state) =>
            const BvnKycPage(),
        routes: [
          GoRoute(
            path: 'id',
            builder: (BuildContext context, GoRouterState state) =>
                const IdKycPage(),
          ),
        ],
      ),

      /**
       * 
       * ========================== Trade =======================
       */

      GoRoute(
        path: '/virtualNumber',
        name: 'virtualNumber',
        builder: (BuildContext context, GoRouterState state) =>
            const IdKycPage(),
      ),

      /**
       * 
       * ========================== Bill Payment =======================
       */
      GoRoute(
        path: '/bill',
        name: 'bill',
        builder: (BuildContext context, GoRouterState state) {
          buildView(){
            if(state.queryParams['view'] == 'mobile-refill'){
              return MobileRefillPage(
                refillType: state.queryParams['type'],
              );
            }else {
              return BillPaymentPage(
                billType: state.queryParams['type'],
              );
            }
          }
          return BlocProvider<BillsCubit>(
            create: (context) => BillsCubit(appBloc: BlocProvider.of<AppBloc>(context)),
            child: buildView(),
          );
        }
      ),

      /**
       * 
       * ========================== Activities =======================
       */
      GoRoute(
        path: '/transaction',
        name: "transaction",
        builder: (BuildContext context, GoRouterState state) {
          Transaction transaction = state.extra as Transaction;
          return TransactionPage(
            transaction: transaction,
          );
        },
      ),
      GoRoute(
        path: '/trade',
        name: "trade",
        builder: (BuildContext context, GoRouterState state) {
          Trade trade = state.extra as Trade;
          return TradePage(
            trade: trade,
          );
        },
      ),
      GoRoute(
        path: '/notification',
        name: 'notifications',
        builder: (BuildContext context, GoRouterState state) =>
            const NotificationScreen(),
      ),
      GoRoute(
        path: '/assets',
        name: 'assets',
        builder: (BuildContext context, GoRouterState state) {
          String? type = state.queryParams['type'];
          chooseView() {
            if (type != null && type == 'giftcard') {
              return const GiftcardAssetsPage();
            } else if (type != null && type == 'crypto') {
              return const CryptoAssetsPage();
            } else if (type != null && type == 'spending-card') {
              return const SpendingCardsPage();
            } else {
              return const FundsPage();
            }
          }

          return BlocProvider<AssetCubit>(
            create: (context) => AssetCubit(appBloc: appBloc),
            child: chooseView(),
          );
        },
      ),

      /**
       * 
       * ========================== Wallet =======================
       */
      GoRoute(
        path: '/wallet',
        name: 'wallet',
        builder: (BuildContext context, GoRouterState state) {
          Wallet wallet = state.extra as Wallet;
          var action = state.queryParams['action'];
          buildView() {
            if (action == 'withdraw') {
              return WithdrawPage(wallet: wallet);
            } else if (action == 'deposit') {
              return DepositPage(wallet: wallet);
            } else if (action == 'transfer') {
              return TransferPage(wallet: wallet);
            }
          }

          return BlocProvider<WalletCubit>(
            create: (context) => WalletCubit(appBloc: appBloc),
            child: buildView(),
          );
        },
      ),
      /**
       * 
       * ========================== Settings =======================
       */
      GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (BuildContext context, GoRouterState state) {
            var pane = state.queryParams['type'];
            chooseView() {
              if (pane == 'profile') {
                return const ProfileSettingPage();
              } else if (pane == 'password') {
                return const PasswordSettingPage();
              } else if (pane == 'pin') {
                return const PinSettingPage();
              } else if (pane == 'notification') {
                return const NotificationSettingPage();
              }else if(pane == 'banking'){
                return const BankSettingPage();
              }
          }

            return BlocProvider<ProfileCubit>(
                create: (context) =>
                    ProfileCubit(appBloc: BlocProvider.of<AppBloc>(context)),
                child: chooseView());
          }),
      GoRoute(
          path: '/support',
          name: 'support',
          builder: (BuildContext context, GoRouterState state) {
            return const SupportScreen();
          }),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
