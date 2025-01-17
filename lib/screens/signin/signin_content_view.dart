
import 'package:fires/screens/signin/signin_button.dart';
import 'package:fires/screens/signin/signin_text_field.dart';
import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class SignInContentView extends StatefulWidget {
  final GlobalKey textFieldsKey;
  final Function() validateSignIn;

  SignInContentView({
    Key? key,
    required this.textFieldsKey,
    required this.validateSignIn,
  }) : super(key: key);

  @override
  SignInContentViewState createState() => SignInContentViewState();
}

class SignInContentViewState extends State<SignInContentView> {
  String welcomeText = 'Sign In!';
  bool? tech = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: screenWidth,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.1),
            // App Logo
            Container(
              width: 125,
              height: 125,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  image: AssetImage('assets/Icons/app_logo.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: screenWidth * 0.15),
            // Sign-In Text Field
            Center(
              child: SignInTextField(
                key: widget.textFieldsKey,
                text: '', top: 0,
              ),
            ),
            const SizedBox(height: 20),
            // Login Button
            SignInSubmitButton(
              borderColor: loginLightText,
              textColor: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              text: 'LOGIN',
              color: Colors.transparent,
              validateSignIn: widget.validateSignIn,
            ),
            const SizedBox(height: 18),
            // Sign-Up Button
            SignInSubmitButton(
              tech: tech,
              borderColor: Colors.transparent,
              textColor: textHeadingColor,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              text: 'SIGN UP',
              color: Colors.transparent,
              // Uncomment below line and add function if there's an action for the sign-up button
              // validateSignIn: signUpFunction,
            ),
            SizedBox(height: screenHeight * 0.1),
          ],
        ),
      ),
    );
  }
}
