part of 'create_tweet_bloc.dart';

abstract class CreateTweetState extends Equatable {
  CreateTweetState([List props = const []]) : super();
}

class CreateTweetInitialState extends CreateTweetState {

  @override
  String toString() => 'CreateTweetInitialState';

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class CreateTweetLoadingState extends CreateTweetState {
  @override
  String toString() => 'CreateTweetLoadingState';
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class CreateTweetSuccessState extends CreateTweetState {
  @override
  String toString() => 'CreateTweetSuccessState';
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class CreateTweetFailureState extends CreateTweetState {
  final String error;

  CreateTweetFailureState({@required this.error}) : super([error]);

  @override
  String toString() => 'CreateTweetFailureState { error: $error }';
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

