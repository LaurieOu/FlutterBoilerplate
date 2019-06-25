import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../models/auth.dart';


class UserRepository with ChangeNotifier {
  UserRepository();

  User _authenticatedUser; 
  bool _isLoading = false;

  User get user {
    return _authenticatedUser; 
  }

  bool get isLoading {
    return _isLoading;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password, [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();

    final Map<String,dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };
    
    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post('https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyB0T9d7GiB_Jb3uOrZkBcr_BSkxHXT8vCc',
      body: json.encode(authData),
      headers: {'Content-Type': 'application/json'});
    } else {
      response = await http.post('https://www.googleapis.com/identitytoolkit/v3/signupNewUser/verifyPassword?key=AIzaSyB0T9d7GiB_Jb3uOrZkBcr_BSkxHXT8vCc',
      body: json.encode(authData),
      headers: {'Content-Type': 'application/json'});
    }

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong';
    
    if(responseData.containsKey('idToken')){
      hasError = false;
      message = 'Authentication succeeded!';
      _authenticatedUser = User(
        email: email,
        id: responseData['localId'],
        token: responseData['idToken'],
      );
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
      prefs.setString('userEmail', email);
      prefs.setString('userId', responseData['localId']);
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email was not found.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid.';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists.';
    }

    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  Function signOut() {
    return 'signing out'
  }
}