import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:truvender/data/repositories/repositories.dart';

part 'password_event.dart';
part 'password_state.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final AuthRepository authRepository;
  PasswordBloc({ required this.authRepository}) : super(PasswordInitial()) {
    on<EmailSubmitted>((event, emit) async {
      emit(PasswordLoading());
      try {
        await authRepository.forgotPassword(event.email);
        emit(InstructionSent(sentTo: event.email));
      } catch (e) {
        emit(PasswordFailed(error: e.toString()));
      }
    });

    on<PasswordResetSubmitted>((event, emit) async {
      emit(PasswordLoading());
      try {
        await authRepository.resetPassword(email: event.email, token: event.token, password: event.password);
        emit(PasswordResetComplete());
      } catch (e) {
        emit(PasswordFailed(error: e.toString()));
      }
    });
  }
}
