import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_person_twitter/Utilities/app_strings.dart';
import 'package:one_person_twitter/features/home/models/Tweet.dart';

import 'create_tweet_bloc.dart';
import 'create_tweet_form.dart';

class CreateTweetPage extends StatelessWidget {
  final Tweet record;
  const CreateTweetPage({Key key, this.record}) : super(key: key);
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => CreateTweetPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.create_tweet_page_title)),
      body: BlocProvider(
        create: (context) {
          return CreateTweetBloc(CreateTweetInitialState());
        },
        child: CreateTweetForm(record: record,),
      ),
    );
  }
}
