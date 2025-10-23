part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

final class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}


class AuthLoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthSuccessState extends AuthState {
 final AuthModel authModel;
  const AuthSuccessState(this.authModel);
  @override
  List<Object> get props => [authModel];
}

class AuthErrorState extends AuthState {
  final String erMsg;
  const AuthErrorState(this.erMsg);
  @override
  List<Object> get props => [];
}

