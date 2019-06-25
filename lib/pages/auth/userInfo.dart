import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../../scoped-models/user_repository.dart';
import './../../models/user.dart';


class UserInfoPage extends StatelessWidget {
  final User user;

  const UserInfoPage({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Info'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(user.email),
            RaisedButton(
              child: Text('Sign Out'),
              onPressed: () => Provider.of<UserRepository>(context).signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
