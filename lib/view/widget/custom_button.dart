import 'package:flutter/material.dart';

class CustomElevatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String? buttonText;
  final Color? textColor;
  final Color? buttonColor;
  final Color? splashColor;
  final Color? disableColor;
  final double? elevation;
  final double? buttonHeight;
  final double? buttonWidth;
  final Icon? icon;
  final Widget? child;
  final ButtonStyle? buttonStyle;
  final TextStyle? textStyle;

  const CustomElevatedButton({super.key, @required this.onPressed, @required this.buttonText, this.splashColor, this.textColor, this.disableColor, this.buttonColor, this.elevation, this.buttonHeight, this.buttonWidth, this.buttonStyle, this.textStyle, this.icon, this.child});

  @override
  CustomElevatedButtonState createState() => CustomElevatedButtonState();
}

class CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: widget.buttonWidth ?? size.width * 0.99 ,
      height: widget.buttonHeight ?? 53,
      child: ElevatedButton(
        key: widget.key,
        style: widget.buttonStyle ??
            ElevatedButton.styleFrom(
              elevation: (widget.elevation != null)?widget.elevation :null,
              backgroundColor: widget.buttonColor ?? Colors.black,
              disabledBackgroundColor: widget.disableColor,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
        onPressed: widget.onPressed,
        child: widget.child ?? Text(
          widget.buttonText!,
          textAlign: TextAlign.center,
          style: widget.textStyle ?? TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
        ),
      ),
    );
  }
}