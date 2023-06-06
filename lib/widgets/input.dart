import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
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
      onChanged: (_) {
        if (onChange != null) {
          onChange!();
        }
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

class PhoneInput extends StatefulWidget {
  const PhoneInput(
      {Key? key,
      required this.controller,
      this.bordered = true,
      this.onChange,
      this.require = true,
      this.label = 'Phone number',
      this.padding = const EdgeInsets.symmetric(horizontal: 10)})
      : super(key: key);
  final TextEditingController controller;
  final bool bordered;
  final bool require;
  final String? label;
  final Function? onChange;
  final EdgeInsets padding;

  @override
  State<PhoneInput> createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput> {
  bool isValid = true;
  String selectedCountry = 'NG';
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: widget.padding,
          decoration: BoxDecoration(
              border: Border.all(
                width: widget.bordered ? 1.4 : 0,
                color: !isValid ? const Color.fromARGB(150, 247, 97, 117) : AppColors.textFaded,
              ),
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          child: InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              setState(() => selectedCountry = number.isoCode ?? 'NG');
              widget.onChange!(number.isoCode);
            },
            onInputValidated: (bool value) =>  setState(() => isValid = value),
            ignoreBlank: true,
            countries: const ['NG', 'GH', 'ZA', 'KE', 'CM'],
            autoValidateMode: AutovalidateMode.disabled,
            cursorColor: Theme.of(context).accentColor,
            initialValue: PhoneNumber(isoCode: selectedCountry),
            textFieldController: widget.controller,
            inputBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            selectorConfig: const SelectorConfig(
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            ),
            inputDecoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        !isValid && widget.require ? Padding(padding: const EdgeInsets.only(top: 6), child: Text("${widget.label!} is invalid", style: Theme.of(context).textTheme.labelSmall!.copyWith(
          color: AppColors.redLight,
          fontSize: 10,
        ),),) : const SizedBox(),
      ],
    );
  }
}

class InputLabel extends StatelessWidget {
  final String text;
  final double fontSize;
  final EdgeInsets padding;
  const InputLabel({Key? key, required this.text, this.fontSize = 14, this.padding =  const EdgeInsets.only(top: 4, bottom: 12)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.w600,
              fontSize: fontSize,
            ),
      ),
    );
  }
}



class PinInput extends StatefulWidget {
  final int length;
  final TextEditingController controller;
  final bool showError;

  const PinInput({ Key? key, this.length = 5,  required this.controller, this.showError = false }) : super(key: key);

  @override
  State<PinInput> createState() => _PinInputState();
}

class _PinInputState extends State<PinInput> {
  final focusNode = FocusNode();

  

  @override
  void dispose() {
    widget.controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    const borderColor = AppColors.accent;
    const errorColor = Color.fromRGBO(255, 234, 238, 1);
    var fillColor = isDarkMode ? Theme.of(context).cardColor : AppColors.secoundaryLight;
    final defaultPinTheme = PinTheme(
      // width: 56,
      width: (MediaQuery.of(context).size.width - 100) / widget.length,
      height: 60,
      textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
        fontSize: 22,
        color: Theme.of(context).accentColor,
        fontWeight: FontWeight.bold
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );
  
    return SizedBox(
      height: 68,
      child: Pinput(
        length: widget.length,
        controller: widget.controller,
        focusNode: focusNode,
        defaultPinTheme: defaultPinTheme,
        onCompleted: (pin) {
          // setState(() => widget.showError = pin != '5555');
        },
        focusedPinTheme: defaultPinTheme.copyWith(
          height: 68,
          // width: 64,
          width: (MediaQuery.of(context).size.width - 60) / widget.length,
          decoration: defaultPinTheme.decoration!.copyWith(
            border: Border.all(color: borderColor),
          ),
        ),
        errorPinTheme: defaultPinTheme.copyWith(
          decoration: BoxDecoration(
            color: errorColor,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}