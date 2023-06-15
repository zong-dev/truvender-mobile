import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/data/repositories/repositories.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;
  final AppBloc appBloc;
  final List<String> availableIn = ['ZA', 'NG', 'GH', 'KE', 'CM'];

  RegisterBloc({required this.authRepository, required this.appBloc})
      : super(RegisterInitial()) {
    on<SignupFormSubmitted>(_onSignupSubmitted);
    on<SubmitAccountVerification>(_onAccountVerification);
    on<SendVerificationCode>(_onSendVerificationCode);
  }

  _onSendVerificationCode(event, emit) async {
    emit(RegisterLoading());
    try {
      await authRepository.resendVerificationToken(event.type);
      emit(ResentVerificationCode());
    } catch (e) {
      // String message = e.toString();
      emit(const VerificationFailed(message: "Connection Error"));
    }
  }

  _onAccountVerification(event, emit) async {
    emit(RegisterLoading());
    try {
      await authRepository.verifyAccount(event.type, event.token);
      if ( event.type == 'email') {
        emit(EmailVerified());
      } else if (event.type == 'phone') {
        emit(PhoneVerified());
      }
    } catch (e) {
      emit(const VerificationFailed(message: "Connection Error"));
    }
  }

  _onSignupSubmitted(event, emit) async {
    emit(RegisterLoading());
    try {
      bool countryIsSupported =
          availableIn.contains(event!.country.toString().toUpperCase());
      if (!countryIsSupported) {
        emit(const RegistrationFailed(
            message: "Application is not supported in your country"));
      } else {
        var recordValidation = await authRepository.checkDuplicateRecords(
          email: event.email,
          phone: event.phone,
          username: event.username,
        );

        if (recordValidation.data['email'] == false &&
            recordValidation.data['phone'] == false &&
            recordValidation.data['username'] == false) {
          var response = await authRepository.signUp(
            email: event.email,
            phone: event.phone,
            username: event.username,
            password: event.password,
            currency: event.currency,
            country: event.country,
            referrer: event.referrer,
          );
          // Map<String, String> toBeVerified = {
          //   "email": event.email,
          //   "phone": event.phone
          // };
          emit(RegisterSuccess(data: response.data));
        } else {
          var responseObject = recordValidation.data;
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
      }
    } catch (e) {
      String message = e.toString();
      emit(const RegistrationFailed(message: "Connection Error"));
    }
  }
}
