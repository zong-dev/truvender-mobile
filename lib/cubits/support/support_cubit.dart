import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:truvender/blocs/app/app_bloc.dart';

part 'support_state.dart';

class SupportCubit extends Cubit<SupportState> {
  final AppBloc appBloc;
  SupportCubit({ required this.appBloc }) : super(SupportInitial());

  Future<void> startChat()async {
    try {
      
    } catch (e) {
    }
  }

  Future<void> closeChat() async {
    try {} catch (e) {}
  }

  Future<void> sendMessage() async {
    try {} catch (e) {}
  }

  Future<void> getChat() async {
    try {} catch (e) {}
  }
}
