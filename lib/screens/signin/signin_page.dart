import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fires/screens/signin/signin_content_view.dart';
import 'package:fires/screens/signin/signin_text_field.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../mainscreens/product_list_screen.dart';
import '../../services/auth_screen.dart';
import '../../utils/colors.dart';
import '../../utils/custom_alert.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final textFieldsKey = GlobalKey<SignInTextFieldState>();
  final _authService = AuthService();


  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
      color: appBackGroundColor,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: appBackGroundColor,
          body: Stack(
            children: [
              SignInContentView(
                validateSignIn: validateSignIn,
                textFieldsKey: textFieldsKey,
              ),
            ],
          ),

        ),
      ),
    );
  }

  void validateSignIn() {
    // Check if email is empty
    if (textFieldsKey.currentState?.email.text.isEmpty ?? true) {
      displayAlert(context, GlobalKey(), 'Please enter an email');
      return;
    }

    // Check if email format is valid
    if (!_isValidEmail(textFieldsKey.currentState!.email.text)) {
      displayAlert(context, GlobalKey(), 'Please enter a valid email');
      return;
    }

    // Check if password is empty
    if (textFieldsKey.currentState?.password.text.isEmpty ?? true) {
      displayAlert(context, GlobalKey(), 'Please enter a password');
      return;
    }

    // Check if password is at least 6 characters long
    if (textFieldsKey.currentState!.password.text.length < 6) {
      displayAlert(context, GlobalKey(), 'Password should be at least 6 characters');
      return;
    }

    // Proceed with sign-in if all validations pass
    submitSignInData();
  }

// Helper method to validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(email);
  }


  String? username;
  String? profileLink;
  String? localId;




  void submitSignInData() async {
    // Check if currentState is not null before accessing email and password
    if (textFieldsKey.currentState != null &&
        textFieldsKey.currentState!.email.text.isNotEmpty &&
        textFieldsKey.currentState!.password.text.isNotEmpty) {

      // setState(() {
      //   _isLoading = true;
      // });
      displayProgress(context); // Show progress

      String email = textFieldsKey.currentState!.email.text;
      String password = textFieldsKey.currentState!.password.text;

      // Attempt sign-in
      User? user = await _authService.signInUser(email, password);

      // setState(() {
      //   _isLoading = false;
      // });
      hideProgress(context); // Hide progress after completion

      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductScreen()),
        );
      } else {
        displayAlert(
          context,
          GlobalKey(),
          'Sign-in failed. Please check your credentials.',
        );
      }
    } else {
      displayAlert(
        context,
        GlobalKey(),
        'Please enter both email and password.',
      );
    }
  }



  // Navigator.push(
  // context,
  // MaterialPageRoute(
  // builder: (context) => RegisterForm(tech: widget.tech)))
  var imman;

  Future<void> createUser(bool? isadmin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('valid_user', true);
    prefs.setBool('admin', isadmin!);
    prefs.setString("id", localId!);
    prefs.setString('profile', profileLink!);
    prefs.setString('Username', username!);
    debugPrint(imman.toString() + "000");
  }

  Future<void> popWindow() async {
    await Navigator.pushNamedAndRemoveUntil(context, "/signin", (r) => false);
  }

  Future<void> createMenuList(String menuList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('menu_list', menuList);
  }

  static String getSigninData() {
    var signinDetails = {
      // "username": SigninInfo.sharedInfo.userName,
      // "password": SigninInfo.sharedInfo.password,
    };
    return json.encode(signinDetails);
  }

  void pushToHomePage() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => BottomNavigation()),
    // );
  }
}
