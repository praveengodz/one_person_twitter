import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_person_twitter/Utilities/app_strings.dart';
import 'package:one_person_twitter/features/home/models/Tweet.dart';
import 'package:one_person_twitter/widgets/loading_widget.dart';
import 'create_tweet_bloc.dart';

class CreateTweetForm extends StatefulWidget {
  final Tweet record;
  const CreateTweetForm({Key key, this.record}) : super(key: key);
  @override
  State<CreateTweetForm> createState() => _CreateTweetFormState();
}

class _CreateTweetFormState extends State<CreateTweetForm> {

  TextEditingController tweetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.record != null){
      tweetController.text = widget.record.tweet;
    }
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<CreateTweetBloc, CreateTweetState>(
        listener: (context, state) {
          if(state is CreateTweetLoadingState){
            showLoadingWidget(context);
          }

          if(state is CreateTweetFailureState){
            Navigator.pop(context);
            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(state.error)
            ));
          }

          if(state is CreateTweetSuccessState){
            Navigator.pop(context);
            showAlertDialog(context);
          }
        },
      child: BlocBuilder<CreateTweetBloc, CreateTweetState>(
        builder: (context, state) {
          return Scaffold(
            body:  Container(
              padding: const EdgeInsets.only(top: 20.0,left: 20.0,right: 20.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: tweetController,
                    maxLength: 280,
                    decoration: InputDecoration(
                      labelText: AppStrings.create_tweet_placeholder,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    maxLengthEnforced: true,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    child: const Text(AppStrings.create_tweet_btn_title),
                    onPressed: () {
                      if(widget.record == null) {
                        BlocProvider.of<CreateTweetBloc>(context).add(NewTweet(tweetController.text));
                      }  else {
                        BlocProvider.of<CreateTweetBloc>(context).add(EditTweet(widget.record,tweetController.text));
                      }
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text(AppStrings.alert_dialog_Ok),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(AppStrings.alert_dialog_success),
      content: Text(AppStrings.alert_dialog_msg),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
