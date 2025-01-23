import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    this.labelText,
    this.textFieldStyle,
    this.isPwdType = false,
    required this.controller,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.isEnabled = true,
    this.isReadonly = false,
    this.textCapitalization = TextCapitalization.sentences,
    this.keyboardType = TextInputType.text,
    this.inputFormatter,
    this.prefixIcon,
    this.suffixIcon,
    this.isLast = false,
    this.showSuffix = false,
    this.inputAction = TextInputAction.next,
    this.onChange,
    this.helperText,
    required this.validator,
    this.onSave,
    this.onClick,
    this.fillColor,
    this.borderColor,
    this.labelColor,
    this.focusedBorderColor,
    this.enabledBorderColor,
    this.formKey,
    this.cursorColor,
    this.hintTextColor,
    this.labelHeight,
    this.showCursor = true,
    this.focusNode,
    this.labelStyle,
    this.topPadding,
    this.leftPadding,
    this.contentPadding,
    this.onSubmitted
  });

  final String? labelText;
  final TextStyle? textFieldStyle;
  final bool isPwdType;
  final bool isEnabled;
  final bool isReadonly;
  final String? helperText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final int maxLines;
  final int minLines;
  final int? maxLength;
  final TextAlign? textAlign;
  final bool showSuffix;
  final Widget? suffixIcon;
  final TextStyle? labelStyle;
  final bool isLast;
  final inputFormatter;
  final textCapitalization;
  final TextInputAction inputAction;
  final void Function(String)? onChange;
  final String? Function(String?)? validator;
  final void Function(String?)? onSave;
  final Widget? prefixIcon;
  final Color? fillColor;
  final Color? borderColor;
  final Color? labelColor;
  final Color? focusedBorderColor;
  final Color? enabledBorderColor;
  final Color? cursorColor;
  final Color? hintTextColor;
  final bool showCursor;
  final double? labelHeight;
  final double? topPadding;
  final double? leftPadding;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final Function(String)? onSubmitted;

  final Key? formKey;

  final VoidCallback? onClick;

  @override
  CustomTextFormFieldState createState() => CustomTextFormFieldState();
}

class CustomTextFormFieldState extends State<CustomTextFormField> {
  FocusNode myFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.showSuffix
            ? Positioned(
                bottom: 13,
                right: 12,
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
              )
            : Container(),
        TextFormField(
          key: widget.key,
          textAlignVertical: TextAlignVertical.top,
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
            myFocusNode.unfocus();
          },
          style: widget.textFieldStyle ?? TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          inputFormatters: widget.inputFormatter,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          cursorColor: widget.cursorColor,
          showCursor: widget.showCursor,
          obscureText: widget.isPwdType,
          obscuringCharacter: '*',
          enabled: widget.isEnabled,
          readOnly: widget.isReadonly,
          textCapitalization: widget.textCapitalization,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength, 
          textAlign: widget.textAlign!,
          textInputAction: widget.inputAction,
          focusNode: widget.focusNode ?? myFocusNode,
          onChanged: widget.onChange,
          validator: widget.validator,
          onSaved: widget.onSave,
          onTap: widget.onClick,
          decoration: InputDecoration(
            counter: const SizedBox(),
            helperStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey),
            contentPadding: widget.contentPadding ?? EdgeInsets.fromLTRB(widget.leftPadding ?? 16.0, widget.topPadding ?? 16.0, 0.0, 16.0),
            hintText: widget.helperText,
            labelText: widget.labelText,
            alignLabelWithHint: true,
            filled: true,
            fillColor: widget.fillColor ?? Colors.white,
            hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(color: widget.focusedBorderColor ?? Colors.black, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(color: widget.enabledBorderColor ?? Colors.grey),
            ),
            labelStyle: widget.labelStyle ?? TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey,),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
          ),
        ),
      ],
    );
  }
}