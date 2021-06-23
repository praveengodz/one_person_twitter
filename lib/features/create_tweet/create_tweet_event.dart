part of 'create_tweet_bloc.dart';

abstract class CreateTweetEvent extends Equatable{
  CreateTweetEvent([List props = const []]) : super();
}

class NewTweet extends CreateTweetEvent {
  final String tweet;

  NewTweet(this.tweet);

  @override
  String toString() => 'NewTweet';

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class EditTweet extends CreateTweetEvent {
  final Tweet tweet;
  final String tweetMessage;
  EditTweet(this.tweet,this.tweetMessage);

  @override
  String toString() => 'EditTweet';

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}