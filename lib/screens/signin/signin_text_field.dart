import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class SignInTextField extends StatefulWidget {
  final double top;
  String? text;

  SignInTextField({Key? key, required this.top, this.text}) : super(key: key);

  @override
  SignInTextFieldState createState() => SignInTextFieldState();
}

class SignInTextFieldState extends State<SignInTextField> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 64, child: emailTextField()),
        const SizedBox(
          height: 10,
        ),
        SizedBox(height: 64, child: passwordTextfield()),
      ],
    );
  }

  bool colorChange = false;
  bool colorChange1 = false;

  Widget emailTextField() {
    return TextFormField(
      cursorColor: floatingButtonColor,
      controller: email,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      style: TextStyle(
        color: black,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: textFieldColorFilled,
        border: InputBorder.none,
        labelText: 'Email',
        contentPadding: const EdgeInsets.only(
            left: 24,
            top: 50,
            bottom: 20,
            right: 24), // Padding inside the text field

        labelStyle: TextStyle(
            color: black,
            fontWeight: FontWeight.w300,
            fontSize: 14 // Color of the label text
            ), // Padding inside the text field
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
              color: Colors.transparent,
              ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.transparent,

          ),
        ),
      ),
    );
  }

  Widget passwordTextfield() {
    return TextFormField(
      cursorColor: floatingButtonColor,
      controller: password,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      style: TextStyle(
        color: black,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: textFieldColorFilled,
        border: InputBorder.none,
        labelText: 'Password',
        contentPadding: const EdgeInsets.only(
            left: 24,
            top: 50,
            bottom: 20,
            right: 24), // Padding inside the text field

        labelStyle: TextStyle(
            color: black,
            fontWeight: FontWeight.w300,
            fontSize: 14 // Color of the label text
        ), // Padding inside the text field
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.transparent,

            // color: buttonColor03,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.transparent,

          ),
        ),
      ),
    );
  }
}
