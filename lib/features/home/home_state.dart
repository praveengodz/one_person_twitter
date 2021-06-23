part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  HomeState([List props = const []]) : super();
}

class HomeInitialState extends HomeState {

  @override
  String toString() => 'HomeInitialState';

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
