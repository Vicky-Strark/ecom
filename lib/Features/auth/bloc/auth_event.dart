part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}


class ClickAuthEvent extends AuthEvent{
  final String email;
  final String password;

  ClickAuthEvent(this.email, this.password);

  @override
  // TODO: implement props
  List<Object?> get props => [email,password];


}