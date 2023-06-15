import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/data/repositories/repositories.dart';
import 'package:truvender/services/services.dart';
// ignore: library_prefixes

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthRepository authRepository;
  final LocalNotification localNotificationService;
  final StorageUtil storage = StorageUtil();

  late String validationType;
  late Function onValidated;

  final Dio dio;
  User authenticatedUser = User(id: '');
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
    on<VerifyAccountOwner>(_verifyAccountOwner);
    // on<Initializedizing>();
  }

  _onAppStarted(event, emit) async {
    bool seen = await strUtl.getBoolVal('seen') ?? false;
    String? token = await authRepository.storage.read(key: "token");
    if (!seen) {
      await strUtl.setBoolVal('seen', true);
      emit(Initialized());
    } else if (seen) {
      if (token != null) {
        await authRepository.resetToken();
      }
      emit(Unauthenticated());
    }
  }

  _onSignedIn(event, emit) async {
    emit(Loading());
    await authRepository.persistToken(event.token);
    var userRequest = await authRepository.getUser();
    if (userRequest.statusCode == 200) {
      User user = User.fromJson(userRequest.data['user']);
      authenticatedUser = user;
      emit(Authenticated(user: user));
      _validateUserState(user, emit, false);
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
      await storage.setStrVal("variations", '');
      _validateUserState(user, emit, true);
    }
  }

  _validateUserState(User user, emit, bool refreshed) {
    if (user.requireOtp == true) {
      emit(OtpChallenge());
    } else if (user.email_verified_at == null ||
        user.phone_verified_at == null) {
      emit(AccountVerification(user: user));
    } else if (user.kycStatus == null || user.kycStatus == 'Tier1') {
      if (user.kycStatus == null) {
        emit(KycVerification(user: user, path: '/kyc'));
      } else if (user.kycStatus == 'Tier1') {
        emit(
          KycVerification(user: user, path: '/kyc/id'),
        );
      }
    }else{
      emit(Authenticated(user: user, refreshed: refreshed));
    }
  }

  _verifyAccountOwner(event, emit) async {
    emit(Authenticating());
    try {
      await authRepository.validateOwner(
        type: event.type,
        value: event.value,
      );
      emit(AccountVerified());
    } catch (e) {
      emit(ValidationFailed());
    }
  }
}
