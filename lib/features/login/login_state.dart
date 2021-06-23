part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = FormzStatus.pure,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.failureDescription = "",
  });

  final FormzStatus status;
  final Username username;
  final Password password;
  final String failureDescription;

  LoginState copyWith({
    FormzStatus status,
    Username username,
    Password password,
    String failureDescription,
  }) {
    return LoginState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      failureDescription: failureDescription ?? this.failureDescription,
    );
  }

  @override
  List<Object> get props => [status, username, password, failureDescription];
}