import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_person_twitter/Utilities/app_strings.dart';
import 'package:one_person_twitter/features/authentication/authentication_bloc.dart';
import 'package:one_person_twitter/features/create_tweet/create_tweet_page.dart';
import 'package:one_person_twitter/features/home/models/Tweet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_bloc.dart';

class HomeForm extends StatefulWidget {
  @override
  State<HomeForm> createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {},
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: const Text(AppStrings.home_page_title),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      BlocProvider.of<AuthenticationBloc>(context)
                          .add(AuthenticationLogoutRequested());
                    },
                  )
                ],
              ),
              body: _buildBody(context),
              floatingActionButton: new FloatingActionButton(
                  elevation: 0.0,
                  child: new Icon(Icons.create),
                  onPressed: () {
                    Navigator.of(context).push(CreateTweetPage.route());
                  }));
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(AppStrings.collection_name)
          .where(AppStrings.tweet_email,
              isEqualTo: FirebaseAuth.instance.currentUser.email)
          .orderBy(AppStrings.tweet_date, descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Tweet.fromSnapshot(data);
    return Padding(
      key: ValueKey(record.tweet),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          title: Text(
            record.tweet,
            style: new TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
          trailing: Container(
            width: 70,
            child: Row(
              children: [
                Expanded(
                    child: IconButton(
                  padding: new EdgeInsets.all(10.0),
                  icon: Icon(
                    Icons.edit,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) =>
                            new CreateTweetPage(record: record)));
                  },
                )),
                Expanded(
                    child: IconButton(
                  padding: new EdgeInsets.all(10.0),
                  icon: Icon(
                    Icons.delete,
                    size: 20,
                  ),
                  onPressed: () {
                    record.reference.delete();
                  },
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
