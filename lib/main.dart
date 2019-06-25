import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './scoped-models/user_repository.dart';
import './models/user.dart';
import './pages/auth/splash.dart';
import './pages/auth/userinfo.dart';
import './pages/auth/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toastmasters',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) => UserRepository.instance(),
      child: Consumer(
        builder: (context, UserRepository user, _) {
            print("user");
            print(user);
            return user.user == null ? LoginPage() : UserInfoPage(user: user.user);
        },
      ),
    );
  }
}
