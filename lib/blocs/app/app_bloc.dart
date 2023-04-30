import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/data/repositories/repositories.dart';
import 'package:truvender/services/services.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthRepository authRepository;
  final LocalNotification localNotificationService;

  final Dio dio;
  User authenticatedUser = User(id:'');
  StorageUtil strUtl = StorageUtil();

  AppBloc(
      {required this.authRepository,
      required this.dio,
      required this.localNotificationService})
      : super(Initializing()) {
    on<AppStarted>(_onAppStarted);
    on<SignedIn>(_onSignedIn);
    on<SignOut>(_onSignOut);
    on<UserChanged>(_onUserChanged);
    // on<Initializedizing>();
  }

  _onAppStarted(event, emit) async {
    bool seen = await strUtl.getBoolVal('seen') ?? false;
    String? token = await authRepository.storage.read(key: "token");
    if (!seen) {
      await strUtl.setBoolVal('seen', true);
      emit(Initialized());
    } else if (seen) {
      if(token != null){
        await authRepository.resetToken();
      }
      emit(Unauthenticated());
    }
  }

  _onSignedIn(event, emit) async {
    emit(Loading());
    await authRepository.persistToken(event.token);
    var userRequest = await authRepository.getUser();
    if(userRequest.statusCode == 200){
      User user = User.fromJson(userRequest.data['user']);
      authenticatedUser = user;
      if(user.requireOtp == true){
        emit(OtpChallenge());
      }else {
        emit(Authenticated(user: user));
      }
    }
  }

  _onSignOut(event, emit) async {
    emit(Loading());
    await authRepository.resetToken();
    authenticatedUser = User(id: '');
    emit(Unauthenticated());
  }

  _onUserChanged(event, emit) async {
    emit(Loading());
    var userRequest = await authRepository.getUser();
    if (userRequest.statusCode == 200) {
      User user = User.fromJson(userRequest.data['user']);
      authenticatedUser = user;
      emit(Authenticated(user: user));
    }
  }
}
