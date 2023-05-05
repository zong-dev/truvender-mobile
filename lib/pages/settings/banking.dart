import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/cubits/profile/profile_cubit.dart';
import 'package:truvender/services/services.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class BankSettingPage extends StatefulWidget {
  const BankSettingPage({Key? key}) : super(key: key);

  @override
  _BankSettingPageState createState() => _BankSettingPageState();
}

class _BankSettingPageState extends State<BankSettingPage> {
  bool processing = true;
  var profileBloc, appBloc;
  Map accountInfo = {};
  Map? selectedBank;
  bool verifiedAccount = false;
  List banks = [];

  String? bankName;

  StorageUtil localStore = StorageUtil();

  final TextEditingController _acountNumberController = TextEditingController();
  final GlobalKey<FormState> _bankingFormKey = GlobalKey<FormState>();

  _updateBankingInfo() async {
    var biometricsIsEnabled = await localStore.getBoolVal('biometricsEnabled');
    bool authenticate = true;
    if (biometricsIsEnabled) {
      authenticate = await LocalAuth.authenticate();
    }
    if (authenticate) {
      profileBloc.addAccount(
        accountBank: selectedBank!['name'],
        accountNumber: _acountNumberController.text,
        bankName: accountInfo['account_name'],
      );
    }
  }

  _getBankData() {
    if(selectedBank!['code'] != null && _bankingFormKey.currentState!.validate()){
      setState(() {
        verifiedAccount = false;
        accountInfo = {};
      });
      BlocProvider.of<ProfileCubit>(context).validateAccount(account: _acountNumberController.text, bank: selectedBank!['code']);
    }
  }

  selecteBank() {
    openBottomSheet(
      context: context,
      label: "Select Bank",
      child: BankPicker(
        banks: banks,
        onSelected: (bank) {
          setState(() {
            if(selectedBank != bank){
              selectedBank = bank;
            }
          });
        },
        selectedBank: selectedBank,
      ),
      radius: 0,
      height: MediaQuery.of(context).size.height / 1.8,
    );
  }

  @override
  void initState() {
    super.initState();
    appBloc = BlocProvider.of<ProfileCubit>(context).appBloc;
      BlocProvider.of<ProfileCubit>(context).banks();
  }

  String bankPickerTitle = "Loading banks ....";

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProcessingRequest) {
          setState(() => processing = true);
        } else if (state is RequestFailed) {
          setState(() => processing = false);
          notify(context, state.message, "error");
        } else if (state is RequestSuccess) {
          setState(() {
            processing = false;
            if(banks.isEmpty && !state.isSubProccess){
              banks = state.responseData;
              bankPickerTitle = "Select Bank";
            }else if(state.isSubProccess && accountInfo['account_name'] == null){
              accountInfo = state.responseData;
              verifiedAccount = true;
            }else if(!state.isSubProccess && banks.isNotEmpty){
              notify(context, "Profile updated!", "success");
              BlocProvider.of<AppBloc>(context).add(UserChanged());
              context.push("/");
            }
          });
        }
      },
      child: Wrapper(
        title: "Bank Info",
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 26),
          child: Form(
            key: _bankingFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Update banking information for account withrawals",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).accentColor),
                ),
                verticalSpacing(30),
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 12),
                  child: Text(
                    "Account bank",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (!processing) {
                      selecteBank();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Theme.of(context).cardColor,
                        border: Border.all(
                          width: 1.4,
                          color: AppColors.textFaded,
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          selectedBank != null && selectedBank!['name'] != null
                              ? selectedBank!['name']
                              : bankPickerTitle,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontSize: 14,
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.w800),
                        ),
                        Icon(
                          Icons.arrow_drop_down_outlined,
                          size: 28,
                          color: Theme.of(context).accentColor,
                        )
                      ],
                    ),
                  ),
                ),
                verticalSpacing(28),
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 12),
                  child: Text(
                    "Account number",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                  ),
                ),
                TextInput(
                  label: "",
                  controller: _acountNumberController,
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                  type: TextInputType.number,
                  bordered: true,
                  readOnly: processing,
                  onChange: () {
                    if(_acountNumberController.text.length > 9 && _acountNumberController.text.length < 11 && !processing ){
                      _getBankData();
                    }
                  },
                  obsecureText: false,
                  rules: MultiValidator([
                    RequiredValidator(errorText: "Account number is required")
                  ]),
                ),
                accountInfo['account_name'] != null
                    ? Padding(
                        padding: const EdgeInsets.only(
                          top: 12,
                          right: 8,
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                           accountInfo['account_name'].toString(),
                            textAlign: TextAlign.end,
                            style:
                                Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).accentColor,
                                    ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                verticalSpacing(38),
                Button.primary(
                  onPressed: () {
                    if(verifiedAccount && !processing){
                      _updateBankingInfo();
                    }
                  },
                  title: !processing ? "Save Changes" : 'Please wait...',
                  background: processing
                      ? Theme.of(context).colorScheme.primary.withOpacity(.6)
                      : AppColors.primary,
                  foreground: AppColors.secoundaryLight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
