import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:one_person_twitter/Utilities/app_strings.dart';
import '../../repository/authentication_repository.dart';
import 'models/username.dart';
import 'models/password.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    @required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LoginState());

  final AuthenticationRepository _authenticationRepository;

  @override
  Stream<LoginState> mapEventToState(
      LoginEvent event,
      ) async* {
    if (event is LoginUsernameChanged) {
      yield _mapUsernameChangedToState(event, state);
    } else if (event is LoginPasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is LoginSubmitted) {
      yield* _mapLoginSubmittedToState(event, state);
    }
  }

  LoginState _mapUsernameChangedToState(
      LoginUsernameChanged event,
      LoginState state,
      ) {
    final username = Username.dirty(event.username);
    return state.copyWith(
      username: username,
      status: Formz.validate([state.password, username]),
    );
  }

  LoginState _mapPasswordChangedToState(
      LoginPasswordChanged event,
      LoginState state,
      ) {
    final password = Password.dirty(event.password);
    return state.copyWith(
      password: password,
      status: Formz.validate([password, state.username]),
    );
  }

  Stream<LoginState> _mapLoginSubmittedToState(
      LoginSubmitted event,
      LoginState state,
      ) async* {
    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: state.username.value,
            password: state.password.value
        );
        if(userCredential.user != null){
          await _authenticationRepository.logIn(
            username: state.username.value,
            password: state.password.value,
          );
          yield state.copyWith(status: FormzStatus.submissionSuccess);
        }
      } on FirebaseAuthException catch (e) {
        print(e.message);
        print(e.code);
        if(e.code == AppStrings.error_email_already_inuse){
          yield* _autoSigninToState(event, state);
        } else {
          yield state.copyWith(status: FormzStatus.submissionFailure,failureDescription: e.message);
        }
      } catch (e) {
        yield state.copyWith(status: FormzStatus.submissionFailure,failureDescription: e.toString());
      }
    }
  }

  Stream<LoginState> _autoSigninToState(
      LoginSubmitted event,
      LoginState state,
      ) async* {
    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: state.username.value,
            password: state.password.value
        );
        if(userCredential.user != null){
          await _authenticationRepository.logIn(
            username: state.username.value,
            password: state.password.value,
          );
          yield state.copyWith(status: FormzStatus.submissionSuccess);
        }
      } on FirebaseAuthException catch (e) {
        yield state.copyWith(status: FormzStatus.submissionFailure,failureDescription: e.message);
      } catch (e) {
        print(e);
        yield state.copyWith(status: FormzStatus.submissionFailure,failureDescription: e.toString());
      }
    }
  }
}
