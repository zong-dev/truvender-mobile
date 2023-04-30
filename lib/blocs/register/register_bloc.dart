import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/blocs/login/login_bloc.dart';
import 'package:truvender/data/repositories/repositories.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;
  final AppBloc appBloc;

  
  RegisterBloc({ required this.authRepository, required this.appBloc }) : super(RegisterInitial()) {
    on<SignupFormSubmitted>(_onSignupSubmitted);
    on<AccountVerification>(_onAccountVerification);
    on<SendVerificationCode>(_onSendVerificationCode);
  }

  _onSendVerificationCode(event, emit) async {
    emit(RegisterLoading());
    try {
      await authRepository.resendVerificationToken(event.type);
      emit(ResentVerificationCode());
    } catch (e) {
      String message = e.toString();
      emit(VerificationFailed(message: message));
    }
  }

  _onAccountVerification(event, emit) async {
    emit(RegisterLoading());
    try {
      var request = await authRepository.verifyAccount(event.type, event.token);
      if (request.status == 200 && event.type == 'email') {
        emit(EmailVerified());
      } else if (request.status == 200 && event.type == 'phone') {
        emit(PhoneVerified());
      }
    } catch (e) {
      emit(VerificationFailed(message: e.toString()));
    }
  }

  _onSignupSubmitted(event, emit) async {
    emit(RegisterLoading());
    try {
      var recordValidation = await authRepository.checkDuplicateRecords(
          email: event.email, phone: event.phone, username: event.username);
      if (recordValidation.email == false &&
          recordValidation.phone == true &&
          recordValidation.username == true) {
        var request = await authRepository.signUp(
            email: event.email,
            phone: event.phone,
            username: event.username,
            password: event.password,
            referrer: event.referrer);
        if (request.status == 200) {
          Map<String, String> toBeVerified = {
            "email": event.email,
            "phone": event.phone
          };
          emit(RegisterSuccess(verifiableRecord: toBeVerified));
          LoginBloc loginBloc = LoginBloc(
              authRepository: appBloc.authRepository, appBloc: appBloc);
          loginBloc.add(LoginFormSubmitted(
              username: event.username, password: event.password));
        }
      } else {
        Map<String, dynamic> responseObject = recordValidation;
        String fieldName = '';
        if (responseObject['email'] == true) {
          fieldName = 'email';
        } else if (responseObject['phone'] == true) {
          fieldName = 'phone';
        } else if (responseObject['usernmae'] == true) {
          fieldName = 'username';
        }
        emit(RegistrationFailed(message: "$fieldName already exist!"));
      }
    } catch (e) {
      String message = e.toString();
      emit(RegistrationFailed(message: message));
    }
  }
}
