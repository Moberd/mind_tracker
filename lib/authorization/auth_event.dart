part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {}

class AuthEventCheckAuth extends AuthEvent{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AuthEventLogin extends AuthEvent{
  final String email;
  final String password;
  AuthEventLogin(this.email, this.password);

  @override
  // TODO: implement props
  List<Object> get props => [email,password];
}
class AuthEventRegister extends AuthEvent{
  final String email;
  final String password;
  final String name;
  AuthEventRegister(this.email, this.password, this.name);
  @override
  // TODO: implement props
  List<Object> get props => [email,password,name];

}