import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/quickalert.dart';
import 'package:truvender/cubits/kyc/kyc_cubit.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class BvnKycPage extends StatefulWidget {
  const BvnKycPage({Key? key}) : super(key: key);

  @override
  _BvnKycPageState createState() => _BvnKycPageState();
}

class _BvnKycPageState extends State<BvnKycPage> {
  bool processing = false;

  final _kycForm = GlobalKey<FormState>();
  final TextEditingController _bvnController = TextEditingController();

  _submitVerification() {
    BlocProvider.of<KycCubit>(context)
        .submitTierOneVerification(bankNumber: _bvnController.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<KycCubit, KycState>(
      listener: (context, state) {
        if (state is TierOneVerification) {
          setState(() => processing = false);
          QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              title: 'Sucess!',
              confirmBtnText: "Continue",
              text: "Document verified successfully",
              onConfirmBtnTap: () {
                context.push('/kyc/id');
              });
        } else if (state is CreatingRequest) {
          setState(() => processing = true);
        } else if (state is RequestFailed) {
          setState(() => processing = false);
          notify(context, "Failed to verify document", "error");
        }
      },
      child: KycWrapper(
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
                background: processing
                    ? Theme.of(context).colorScheme.primary.withOpacity(.6)
                    : AppColors.primary,
                title: !processing ? 'Submit' : "Verifying...",
                foreground: Colors.white,
                onPressed: () => {
                  if (_kycForm.currentState!.validate()) {_submitVerification()}
                },
              ),
              verticalSpacing(30),
            ],
          ),
        ),
      ),
    );
  }
}
