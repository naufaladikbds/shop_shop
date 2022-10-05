import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? initialValue;
  final Widget? suffixIcon;
  final bool withImagePreview;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final bool obscureText;
  final int maxLines;
  final void Function(String?)? onSaved;

  const CustomTextFormField({
    Key? key,
    required this.labelText,
    this.controller,
    this.withImagePreview = false,
    this.suffixIcon,
    this.onFieldSubmitted,
    this.onSaved,
    this.focusNode,
    this.maxLines = 1,
    this.initialValue,
    this.validator,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('login');
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: TextFormField(
        obscureText: obscureText,
        validator: validator,
        initialValue: initialValue,
        onSaved: onSaved,
        maxLines: maxLines,
        focusNode: focusNode,
        controller: controller,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: withImagePreview
                ? BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )
                : BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: withImagePreview
                ? BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )
                : BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
