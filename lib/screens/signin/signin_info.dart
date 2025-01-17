import 'dart:io';

class SigninInfo {
  static final SigninInfo _singleton = SigninInfo._internal();
  factory SigninInfo() => _singleton;
  SigninInfo._internal();
  static SigninInfo get sharedInfo => _singleton;

  String clientKey = '';
  String userName = '';
  String password = '';

  void clearData() {
    clientKey = '';
    userName = '';
    password = '';
  }
}
