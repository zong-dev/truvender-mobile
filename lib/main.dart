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
import 'package:truvender/utils/utils.dart';

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
  String baseUri = "https://api.truvender.com/v1";
  runApp(Truvender(baseUri: baseUri));
}

class Truvender extends StatefulWidget {
  final String baseUri;
  const Truvender({
    Key? key,
    required this.baseUri,
  }) : super(key: key);

  @override
  _TruvenderState createState() => _TruvenderState();
}

class _TruvenderState extends State<Truvender> {
  late AuthRepository authRepository;
  late Dio dio;
  final LocalNotification notificationService = LocalNotification();

  // ignore: prefer_typing_uninitialized_variables
  static var baseUrl;
  
  initializeDio() {
    BaseOptions dioOptions = BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 60 * 1000), // 60 seconds
        receiveTimeout: const Duration(seconds: 60 * 1000) // 60 seconds
    );
    setState(() => dio = Dio(dioOptions));
  }

  @override
  void initState() {
    super.initState();
    setState(() => baseUrl = widget.baseUri);
    initializeDio();
    notificationService.initialize();
    _listenToNotification();
    // dio.interceptors.add(
    //   RetryOnConnectionChangeIterceptor(
    //     requestRetrier: DioConnectivityRequestRetrier(
    //       connectivity: Connectivity(),
    //       dio: Dio(),
    //     ),
    //   ),
    // );
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
            localNotificationService: notificationService);
      },
      child: BlocListener<AppBloc, AppState>(
        listener: (context, state) {
          if(state is Authenticated){
            // var socketClient = BlocProvider.of<AppBloc>(context).socket;
            // socketHandler(socketClient, context);
          }
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
      ),
    );
  }
}
