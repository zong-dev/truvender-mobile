import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/notifier.dart';
import 'package:truvender/utils/spacing.dart';
import 'package:truvender/widgets/widgets.dart';

class IdKycPage extends StatefulWidget {
  const IdKycPage({Key? key}) : super(key: key);

  @override
  _IdKycPageState createState() => _IdKycPageState();
}

class _IdKycPageState extends State<IdKycPage> {
  bool uploadFile = false;
  final _verificationForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return KycWrapper(
        showExitButton: false,
        child: Form(
          key: _verificationForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (uploadFile)
                const SecondStep()
              else
                FirstStep(onSubmit: () {
                  if (_verificationForm.currentState!.validate()) {
                    setState(() {
                      uploadFile = true;
                    });
                  }
                })
            ],
          ),
        ));
  }
}

class FirstStep extends StatefulWidget {
  const FirstStep({Key? key, required this.onSubmit}) : super(key: key);
  final Function onSubmit;

  @override
  _FirstStepState createState() => _FirstStepState();
}

class _FirstStepState extends State<FirstStep> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateOfBirth = TextEditingController();

  final verificationTypes = <String>[
    "Nationa ID Card",
    "Driver's Licence",
    "International Passport",
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedType = verificationTypes[0];
    });
  }

  String? selectedType;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 3),
          child: Text(
            "Select verification Type",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(width: 1, color: AppColors.textFaded),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              autofocus: true,
              dropdownColor: Theme.of(context).cardColor,
              // focusColor: Theme.of(context).colorScheme.primary.withOpacity(.7),
              hint: const Text("Verification Type"),
              borderRadius: BorderRadius.circular(14),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.textFaded,
                    fontWeight: FontWeight.w800,
                  ),
              value: selectedType,
              isExpanded: true,
              iconSize: 20,
              icon: const Icon(CupertinoIcons.chevron_down),
              items: verificationTypes
                  .map<DropdownMenuItem<String>>(
                      (String val) => DropdownMenuItem<String>(
                            value: val,
                            child: Text(
                              val,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: selectedType == val
                                        ? Theme.of(context).accentColor
                                        : AppColors.textFaded,
                                    fontWeight: selectedType == val
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                            ),
                          ))
                  .toList(),
              onChanged: (value) => setState(() {
                selectedType = value;
              }),
            ),
          ),
        ),
        verticalSpacing(20),
        TextInput(
          label: 'Full name',
          obsecureText: false,
          controller: _nameController,
          bordered: true,
          rules: MultiValidator(
            [
              RequiredValidator(errorText: "Token is required"),
              MinLengthValidator(6,
                  errorText: "Token must be at least 6 characters"),
            ],
          ),
        ),
        verticalSpacing(20),
        DatePicker(
            label: 'Date Of Birth', type: 'single', controller: _dateOfBirth),
        verticalSpacing(40),
        Button.primary(
          background: Theme.of(context).colorScheme.primary,
          title: 'Next',
          foreground: Colors.white,
          onPressed: () => widget.onSubmit(),
        ),
        verticalSpacing(24),
        const Divider(
          height: 6,
          thickness: 2,
        ),
        verticalSpacing(24),
        GestureDetector(
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Skip for now',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w800),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class SecondStep extends StatefulWidget {
  const SecondStep({Key? key}) : super(key: key);

  @override
  _SecondStepState createState() => _SecondStepState();
}

class _SecondStepState extends State<SecondStep> {
  late File document;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FileUpload(label: "Upload an image of your document", isMultiple: false, onSelected: (file) {
          setState(() {
            document = file;
          });
          // documents = ;
        }),
        verticalSpacing(30),
        Button.primary(
          background: Theme.of(context).colorScheme.primary,
          title: 'Submit',
          foreground: Colors.white,
          onPressed: () {
              notify(context, "Verification request seccessful", 'success');
          },
        ),
      ],
    );
  }
}
