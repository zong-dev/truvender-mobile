import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/quickalert.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/cubits/kyc/kyc_cubit.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class IdKycPage extends StatefulWidget {
  final String? comment;
  const IdKycPage({Key? key, this.comment}) : super(key: key);

  @override
  _IdKycPageState createState() => _IdKycPageState();
}

class _IdKycPageState extends State<IdKycPage> {
  bool uploadFile = false;
  final _verificationForm = GlobalKey<FormState>();
  late Map kycRequestData;
  bool processing = false;

  _submitHandler() {
    BlocProvider.of<KycCubit>(context).submitKycDocumnet(
        name: kycRequestData['name'],
        type: kycRequestData['type'],
        dateOfBirth: kycRequestData['dateOfBirth'],
        documentCode: kycRequestData['documentCode'],
        document: kycRequestData['document']);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<KycCubit, KycState>(
      listener: (context, state) {
        if (state is CreatingRequest) {
          setState(() => processing = true);
        } else if (state is RequestFailed) {
          setState(() => processing = false);
          notify(context, "Something went wrong, try again latter", "error");
        } else if (state is TierTwoVerification) {
          setState(() => processing = false);
           QuickAlert.show(
            context: context,
            confirmBtnText: 'Continue',
            type: QuickAlertType.success,
            title: 'Request submitted!',
            text: "Your verification request was submitted and under review",
            onConfirmBtnTap: () {
              context.push('/');
            }
          );
        }
      },
      child: KycWrapper(
          showExitButton: false,
          child: Form(
            key: _verificationForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (uploadFile)
                  SecondStep(
                      submitHandler: (File document, String documentCode) {
                    setState(() {
                      kycRequestData['document'] = document;
                      kycRequestData['documentCode'] = documentCode;
                    });
                    _submitHandler();
                  })
                else
                  FirstStep(
                    onSubmit: (data) {
                      if (_verificationForm.currentState!.validate()) {
                        setState(() {
                          uploadFile = true;
                          kycRequestData = data;
                        });
                      }
                    },
                    source: widget.comment,
                  )
              ],
            ),
          )),
    );
  }
}

class FirstStep extends StatefulWidget {
  const FirstStep({Key? key, required this.onSubmit, this.source})
      : super(key: key);
  final Function onSubmit;
  final String? source;

  @override
  _FirstStepState createState() => _FirstStepState();
}

class _FirstStepState extends State<FirstStep> {
  late User user;
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
      user = BlocProvider.of<AppBloc>(context).authenticatedUser;
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
              RequiredValidator(errorText: "Full name is required"),
              MinLengthValidator(6,
                  errorText: "Full name must be at least 6 characters"),
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
          onPressed: () => widget.onSubmit({
            "name": _nameController.text,
            "type": selectedType,
            "dateOfBirth": _dateOfBirth.text,
          }),
        ),
        verticalSpacing(24),
        const Divider(
          height: 6,
          thickness: 2,
        ),
        verticalSpacing(24),
        user.country.toUpperCase() == 'NG'
            ? GestureDetector(
                onTap: () => context.push('/'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.source == null ? 'Skip for now' : "Cancel",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

class SecondStep extends StatefulWidget {
  final Function submitHandler;
  const SecondStep({Key? key, required this.submitHandler}) : super(key: key);

  @override
  _SecondStepState createState() => _SecondStepState();
}

class _SecondStepState extends State<SecondStep> {
  final TextEditingController _documentController = TextEditingController();
  late File document;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextInput(
          label: 'Document Code',
          obsecureText: false,
          controller: _documentController,
          bordered: true,
          rules: MultiValidator(
            [
              RequiredValidator(errorText: "Document code is required"),
              MinLengthValidator(6,
                  errorText: "Document code must be at least 6 characters"),
            ],
          ),
        ),
        verticalSpacing(20),
        FileUpload(
            label: "Upload an image of your document",
            isMultiple: false,
            onSelected: (File file) {
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
            widget.submitHandler(document, _documentController.text);
          },
        ),
      ],
    );
  }
}
