import 'package:bloc/bloc.dart';
import 'package:ecom/Core/UseCase/shared_service.dart';

import 'package:ecom/Features/auth/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../Core/core.dart';
import '../model/auth_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on(_onAuth);
  }

  _onAuth(ClickAuthEvent event, Emitter<AuthState> emit) async {
    print("start");
    emit(AuthLoadingState());

    try {

      var response = await authRepository.auth(event.email, event.password);

      SharedPrefService().setAuthToken(response.token);
      emit(AuthSuccessState(response));
      print("success");

    } on NetworkException catch (e) {

      print("Error: Network Exception");
      emit(AuthErrorState(e.message));

    } on ServerException catch (e) {

      print("Error: Server Exception");
      emit(AuthErrorState(e.message));

    } catch (e) {
      print("Error: Unknown Exception ${e.runtimeType}");
      emit(AuthErrorState("An unexpected error occurred. Please try again."));
    }
  }
}
