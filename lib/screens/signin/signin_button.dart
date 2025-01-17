import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../register_screen/register_screen.dart';

class SignInSubmitButton extends StatefulWidget {
  final Function? validateSignIn;
  Color? color;
  Color? borderColor;
  FontWeight? fontWeight;
  bool? tech;
  int? fontSize;
  String? text;
  Color? textColor;
  SignInSubmitButton(
      {Key? key,
      this.validateSignIn,
      this.color,
      this.text,
      this.textColor,
      this.fontSize,
      this.fontWeight,
      this.borderColor,
      this.tech})
      : super(key: key);

  @override
  SignInSubmitButtonState createState() => SignInSubmitButtonState();
}

class SignInSubmitButtonState extends State<SignInSubmitButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => {
            widget.text == "LOGIN"
                ? widget.validateSignIn!()
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegisterForm(tech: widget.tech)))
          },
          child: Container(
            height: 64,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border.all(color: widget.borderColor!),
              color: widget.text == "LOGIN"
                  ? floatingButtonColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              widget.text.toString(),
              textScaleFactor: 1,
              style: TextStyle(
                color: widget.textColor,
                fontSize: widget.fontSize?.toDouble(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
