import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_person_twitter/Utilities/app_strings.dart';
import 'package:one_person_twitter/features/home/models/Tweet.dart';

part 'create_tweet_event.dart';
part 'create_tweet_state.dart';

class CreateTweetBloc extends Bloc<CreateTweetEvent, CreateTweetState> {
  CreateTweetBloc(CreateTweetState initialState) : super(initialState);

  List<Tweet> tweetList = [];
  @override
  CreateTweetState get initialState => CreateTweetInitialState();

  @override
  Stream<CreateTweetState> mapEventToState(CreateTweetEvent event) async* {
    if (event is NewTweet) {
      yield CreateTweetLoadingState();
      if (event.tweet.length == 0) {
        yield CreateTweetFailureState(error: AppStrings.error_msg_empty_tweet);
      } else if (event.tweet.length > 280) {
        yield CreateTweetFailureState(
            error: AppStrings.error_msg_max_tweet_count);
      } else {
        CollectionReference collection =
            FirebaseFirestore.instance.collection(AppStrings.collection_name);
        try {
          var docRef = collection.add({
            AppStrings.tweet: event.tweet,
            AppStrings.tweet_date: FieldValue.serverTimestamp(),
            AppStrings.tweet_email: FirebaseAuth.instance.currentUser.email
          });
          if (docRef != null) {
            yield CreateTweetSuccessState();
          } else {
            yield CreateTweetFailureState(
                error: AppStrings.error_msg_try_again);
          }
        } catch (e) {
          yield CreateTweetFailureState(error: AppStrings.error_msg_try_again);
        }
      }
    }

    if (event is EditTweet) {
      yield CreateTweetLoadingState();
      if (event.tweetMessage.length == 0) {
        yield CreateTweetFailureState(error: AppStrings.error_msg_empty_tweet);
      } else if (event.tweetMessage.length > 280) {
        yield CreateTweetFailureState(
            error: AppStrings.error_msg_max_tweet_count);
      } else if (event.tweetMessage == event.tweet.tweet) {
        yield CreateTweetFailureState(error: AppStrings.error_msg_no_update);
      } else {
        try {
          await event.tweet.reference.update({
            AppStrings.tweet: event.tweetMessage,
            AppStrings.tweet_date: FieldValue.serverTimestamp(),
          });
          yield CreateTweetSuccessState();
        } catch (e) {
          yield CreateTweetFailureState(error: AppStrings.error_msg_try_again);
        }
      }
    }
  }
}
