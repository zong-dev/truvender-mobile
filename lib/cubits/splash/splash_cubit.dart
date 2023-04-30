import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:truvender/blocs/app/app_bloc.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final AppBloc appBloc;
  SplashCubit({required this.appBloc}) : super(SplashInitial());
  Future<void> start() async {
    emit(SplashLoading());
    try {
      final bool isAuthenticated = await appBloc.authRepository.isAuthenticated();
      if (isAuthenticated) {
        appBloc.add(SignOut());
      }
      emit(SplashFinished());
    } catch (e) {
      rethrow;
    }
  }
}
