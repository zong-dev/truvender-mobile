import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/data/repositories/auth.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  final AppBloc appBloc;

  LoginBloc({required this.authRepository, required this.appBloc})
      : super(LoginInitial()) {
    on<LoginFormSubmitted>(
      (event, emit) async {
        emit(LoginLoading());
        try {
          final request = await authRepository.signIn(event.username, event.password);
          var token = request.data['token'];
          emit(LoginSucess(token: token));
        } catch (e) {
          emit(LoginFailed(message: e.toString()));
        }
      },
    );
  }
}
