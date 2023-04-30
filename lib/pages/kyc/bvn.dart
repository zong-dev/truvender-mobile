import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:truvender/utils/spacing.dart';
import 'package:truvender/widgets/widgets.dart';

class BvnKycPage extends StatefulWidget {
  const BvnKycPage({Key? key}) : super(key: key);

  @override
  _BvnKycPageState createState() => _BvnKycPageState();
}

class _BvnKycPageState extends State<BvnKycPage> {
  final _kycForm = GlobalKey<FormState>();
  final TextEditingController _bvnController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return KycWrapper(
      child: Form(
        key: _kycForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 3, left: 4),
              child: Text(
                "Enter Bank Verification Number (BVN) to continue",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            verticalSpacing(20),
            TextInput(
                label: 'Bank Verification Number',
                controller: _bvnController,
                bordered: true,
                rules: MultiValidator(
                  [
                    RequiredValidator(errorText: "BVN is required"),
                    MaxLengthValidator(
                      11,
                      errorText: "BVN must be 11 digits",
                    ),
                    MinLengthValidator(
                      11,
                      errorText: "BVN must be 11 digits",
                    ),
                  ],
                ),
                type: TextInputType.number),
            verticalSpacing(40),
            Button.primary(
              background: Theme.of(context).colorScheme.primary,
              title: 'Continue',
              foreground: Colors.white,
              onPressed: () => {
                if(_kycForm.currentState!.validate()){
                  context.replace('/kyc/id')
                }
              },
            ),
            verticalSpacing(30),
          ],
        ),
      ),
    );
  }
}
