import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:truvender/theme.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class TextInput extends StatelessWidget {
  final String label;
  final FormFieldValidator? rules;
  final Widget? suffixIcon;
  final bool? readOnly;
  final Widget? iconPreffix;
  final bool obsecureText;
  final TextEditingController controller;
  final TextInputType type;
  final bool bordered;
  final EdgeInsetsGeometry padding;
  final Function? onChange;
  TextInput({
    Key? key,
    required this.label,
    this.suffixIcon,
    this.readOnly,
    this.padding = const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
    this.iconPreffix,
    this.onChange,
    this.obsecureText = false,
    this.bordered = false,
    required this.controller,
    this.rules,
    this.type = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: type,
      readOnly: readOnly == true,
      validator: rules,
      obscureText: obsecureText,
      maxLines: 1,
      onChanged: (_){
        if (onChange != null) {onChange!();}
      },
      cursorColor: Theme.of(context).accentColor,
      decoration: InputDecoration(
        contentPadding: padding,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: bordered
              ? const BorderSide(color: AppColors.textFaded, width: 1.4)
              : BorderSide.none,
          gapPadding: 0,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
              color: Color.fromARGB(150, 247, 97, 117), width: 1.4),
          gapPadding: 0,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: bordered
              ? BorderSide(color: Theme.of(context).accentColor, width: 1.4)
              : BorderSide.none,
          gapPadding: 0,
        ),
        floatingLabelStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: AppColors.textFaded,
              backgroundColor: Theme.of(context).cardColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
        fillColor: Theme.of(context).cardColor,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        hintText: label,
        labelStyle: TextStyle(
          color: AppColors.textFaded,
          backgroundColor: Theme.of(context).cardColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: AppColors.textFaded,
            ),
        suffixIcon: suffixIcon,
        prefixIcon: iconPreffix,
      ),
      controller: controller,
      autocorrect: false,
    );
  }
}

class PhoneInput extends StatelessWidget {

  const PhoneInput({Key? key, required this.controller, this.bordered = true, this.label = 'Phone number', this.padding = const EdgeInsets.symmetric(horizontal: 10) }) : super(key: key);
  final TextEditingController controller;
  final bool bordered;
  final String? label;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        border: Border.all(
          width: bordered ? 1.4 : 0,
          color: AppColors.textFaded,
        ),
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(16))
      ),
      child: InternationalPhoneNumberInput(
        textFieldController: controller,
        onInputChanged: (PhoneNumber number) {
          if (kDebugMode) {
            print(number.phoneNumber);
          }
        },
        onInputValidated: (bool value) {
          if (kDebugMode) {
            print(value);
          }
        },
        hintText: label,
        textStyle: TextStyle(
          color: controller.text.isEmpty ? AppColors.textFaded : AppColors.textDark,
          backgroundColor: Theme.of(context).cardColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),

        ignoreBlank: true,
        autoValidateMode: AutovalidateMode.disabled,
        initialValue: PhoneNumber(isoCode: 'NG'),
        // textFieldController: controller,
        inputBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        selectorConfig: const SelectorConfig(
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        ),
      ),
    );
  }
}
