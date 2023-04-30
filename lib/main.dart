// import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/data/repositories/auth.dart';
// import 'package:truvender/interceptors/dio_connectivity_request_retrier.dart';
// import 'package:truvender/interceptors/network_retry_interceptor.dart';
import 'package:truvender/services/services.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/configs/router.dart';


class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('${bloc.runtimeType} $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    // TODO: implement onError
    super.onError(bloc, error, stackTrace);
    print('${bloc.runtimeType} $error');
  }
}

void main() async {
  Bloc.observer = SimpleBlocObserver();
  await dotenv.load(fileName: ".env");
  runApp(const Truvender());
}

class Truvender extends StatefulWidget {
  const Truvender({Key? key}) : super(key: key);

  @override
  _TruvenderState createState() => _TruvenderState();
}

class _TruvenderState extends State<Truvender> {
  late AuthRepository authRepository;
  late Dio dio;
  final LocalNotification notificationService = LocalNotification();

  @override
  void initState() {
    super.initState();
    dio = Dio();
    // dio.interceptors.add(
  
    //   RetryOnConnectionChangeIterceptor(
    //     requestRetrier: DioConnectivityRequestRetrier(
    //       connectivity: Connectivity(),
    //       dio: Dio(),
    //     ),
    //   ),
    // );
    notificationService.initialize();
    _listenToNotification();
    authRepository = AuthRepository(dioInstance: dio);
  }

  void _listenToNotification() => notificationService.onNotificationClick.stream
      .listen(_onNotificationListener);

  void _onNotificationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      debugPrint('Payload $payload');
      context.push('/notifications');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return BlocProvider<AppBloc>(
      create: (context) {
        return AppBloc(
            authRepository: authRepository,
            dio: dio,
            localNotificationService: notificationService)
          ;
      },
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) => MaterialApp.router(
          title: 'Truvender',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          routerConfig: AppRouter(BlocProvider.of<AppBloc>(context)).router,
        ),
      ),
    );
  }
}
