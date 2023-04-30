import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/data/repositories/auth.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final AppBloc appBloc;
  OtpCubit({ required this.appBloc }) : super(OtpInitial());

  late AuthRepository authRepository = appBloc.authRepository;

  Future<void> verifyToken({ required String token }) async {
    emit(ProcessingOtpRequest());
    try {
      var request = authRepository.verifyOTP(token);
      if(request.statusCode == 200){
        emit(OtpVerified());
      }else {
        emit(OtpRequestFailed());
      }
    } catch (e) {
       emit(OtpError(message: e.toString()));
    }
  }

  Future<void> resendToken() async {
    emit(ProcessingOtpRequest());
    try {
      await authRepository.sendOTP();
      emit(ResentOtp());
    } catch (e) {
      emit(OtpError(message: e.toString()));
    }
  }

}
