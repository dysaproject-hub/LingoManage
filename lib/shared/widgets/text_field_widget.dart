import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';

enum TextFieldType { normal, outline }

Widget textFieldWidget({
  required String labelText,
  required TextEditingController controller,
  int? maxLength,
  int? maxLines,
  bool obscureText = false,
  Widget? suffixIcon,
  final String? Function(String?)? validator,
  String errorText = "field ini harus diisi!",
  bool alert = false,
  TextFieldType textFieldType = TextFieldType.normal,
  TextInputType? keyboardType,
}) {
  switch (textFieldType) {
    case TextFieldType.outline:
      return TextFormField(
        obscureText: obscureText,
        keyboardType: keyboardType,
        controller: controller,
        autofocus: true,
        maxLength: maxLength,
        validator: validator,
        minLines: 1,
        maxLines: maxLines,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(
          fontFamily: 'Poppins',
          color: AppColors.black,
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          errorText: alert ? errorText : null,
          labelText: labelText,
          labelStyle: const TextStyle(
            fontFamily: 'Poppins',
            color: AppColors.black,
          ),
          suffixIcon: suffixIcon,
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.blueCard.withAlpha(100),
              width: 2,
            ),
          ),
        ),
      );

    case TextFieldType.normal:
      return TextFormField(
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLength: maxLength,
        minLines: 1,
        maxLines: maxLines,
        controller: controller,
        validator: validator,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(
          fontFamily: 'Poppins',
          color: AppColors.black,
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          errorText: alert ? errorText : null,
          hintText: labelText,
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            color: AppColors.black.withAlpha(100),
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          suffixIcon: suffixIcon,
          border: const UnderlineInputBorder(),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.5),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.blueCard, width: 2),
          ),
        ),
      );
  }
}

Widget buildTextField({
  required String label,
  required IconData icon,
  required ValueChanged onChanged,
  FormFieldValidator? validator,
  TextEditingController? controller,
  FocusNode? focusNode,
  Widget suffixIcon = const SizedBox.shrink(),
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 2,
  bool isEdit = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      focusNode: focusNode,
      onChanged: onChanged,
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      minLines: 1,
      maxLines: maxLines,
      decoration: InputDecoration(
        suffixIcon: isEdit ? suffixIcon : SizedBox.shrink(),
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
