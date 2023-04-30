import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/cubits/profile/profile_cubit.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class ProfileSettingPage extends StatefulWidget {
  const ProfileSettingPage({Key? key}) : super(key: key);

  @override
  _ProfileSettingPageState createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState extends State<ProfileSettingPage>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();
  late TabController _tabController;

  late User user;
  Map profile = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    setState(() => user = BlocProvider.of<AppBloc>(context).authenticatedUser);
    BlocProvider.of<ProfileCubit>(context).profile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is RequestSuccess) {
          if (profile == {}) {
            setState(() => profile = state.responseData);
          }
        }
      },
      child: Wrapper(
        title: "Profile Setting",
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 4),
          child: Form(
            key: _profileFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Align(
                    alignment: Alignment.center,
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Theme.of(context).accentColor,
                      labelStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                      // labelPadding: const EdgeInsets.only(left: 20, right: 20),
                      unselectedLabelColor: AppColors.textFaded,
                      isScrollable: false,
                      // indicator: CircleTabIndicator(
                      //   color: Theme.of(context).accentColor,
                      //   radius: 4,
                      // ),
                      tabs: const [
                        Tab(
                          text: "Account Info",
                        ),
                        Tab(
                          text: "Personal Info",
                        ),
                        Tab(
                          text: "Contact Info",
                        ),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: SizedBox(
                    height: (MediaQuery.of(context).size.height / 2) - 100,
                    width: double.maxFinite,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: GeneralTab(user: user),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: PersonalTab(profile: profile),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: ContactTab(
                            profile: profile,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PersonalTab extends StatefulWidget {
  final Map profile;
  const PersonalTab({Key? key, required this.profile}) : super(key: key);

  @override
  State<PersonalTab> createState() => _PersonalTabState();
}

class _PersonalTabState extends State<PersonalTab> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  final List<String> genders = ["Male", "Female"];

  setProfileDataFromResponse(Map data) {
    _firstNameController.text = data['firstname'] ?? '';
    _lastNameController.text = data['lastname'] ?? '';
    _dateOfBirthController.text = data['dateOfBirth'] ?? '';
    _genderController.text =
        data['gender'] != null ? ucFirst(data['gender']) : genders[0];
  }

  @override
  void initState() {
    super.initState();
    setProfileDataFromResponse(widget.profile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 12),
          child: Text(
            "First name",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
          ),
        ),
        TextInput(
          label: "",
          controller: _firstNameController,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          type: TextInputType.text,
          bordered: false,
          readOnly: widget.profile['firstname'] != null ? true : false,
        ),
        verticalSpacing(28),
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 12),
          child: Text(
            "Last name",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
          ),
        ),
        TextInput(
          label: "",
          controller: _lastNameController,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          type: TextInputType.text,
          bordered: false,
          readOnly: widget.profile['lastname'] != null ? true : false,
        ),
        verticalSpacing(28),
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 12),
          child: Text(
            "Gender",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(width: 1, color: AppColors.textFaded),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 2,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              autofocus: true,
              dropdownColor: Theme.of(context).cardColor,
              // focusColor: Theme.of(context).colorScheme.primary.withOpacity(.7),
              hint: const Text("Select Gender"),
              borderRadius: BorderRadius.circular(14),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.textFaded,
                    fontWeight: FontWeight.w800,
                  ),
              value: _genderController.text,
              isExpanded: true,
              iconSize: 20,
              icon: const Icon(CupertinoIcons.chevron_down),
              items: genders
                  .map<DropdownMenuItem<String>>(
                      (String val) => DropdownMenuItem<String>(
                            value: val,
                            child: Text(
                              val,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: _genderController.text == val
                                        ? Theme.of(context).accentColor
                                        : AppColors.textFaded,
                                    fontWeight: _genderController.text == val
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                            ),
                          ))
                  .toList(),
              onChanged: (value) {
                debugPrint(value.toString());
                // _genderController.text = ;
              },
            ),
          ),
        ),
        verticalSpacing(28),
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 12),
          child: Text(
            "Date of birth",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
          ),
        ),
        TextInput(
          label: "",
          controller: _dateOfBirthController,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          type: TextInputType.datetime,
          bordered: false,
          readOnly: widget.profile['dateOfBirth'] != null ? true : false,
        ),
      ],
    );
  }
}

class GeneralTab extends StatefulWidget {
  final User user;
  GeneralTab({Key? key, required this.user}) : super(key: key);

  @override
  State<GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends State<GeneralTab> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  setFieldsFromResponse() {
    _usernameController.text = widget.user.username!;
    _emailController.text = widget.user.email!;
    _phoneController.text = widget.user.phone!;
  }

  @override
  void initState() {
    super.initState();
    setFieldsFromResponse();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 12),
          child: Text(
            "Username",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
          ),
        ),
        TextInput(
          label: "Enter username",
          controller: _usernameController,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          type: TextInputType.emailAddress,
          bordered: true,
          readOnly: true,
          rules: MultiValidator(
            [
              RequiredValidator(errorText: "Username is required"),
              MaxLengthValidator(20,
                  errorText: "Username must be less that 20 characters long"),
            ],
          ),
        ),
        verticalSpacing(28),
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 12),
          child: Text(
            "Email",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
          ),
        ),
        TextInput(
          label: "Enter Email Address",
          controller: _emailController,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          type: TextInputType.emailAddress,
          bordered: true,
          readOnly: true,
          rules: MultiValidator(
            [
              RequiredValidator(errorText: "Email is required"),
              MaxLengthValidator(20,
                  errorText: "Email must be less that 20 characters long"),
            ],
          ),
        ),
        verticalSpacing(28),
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 12),
          child: Text(
            "Phone",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
          ),
        ),
        TextInput(
          label: "Enter Phone Number",
          controller: _phoneController,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          type: TextInputType.phone,
          bordered: true,
          readOnly: true,
        ),
      ],
    );
  }
}

class ContactTab extends StatefulWidget {
  final Map profile;
  const ContactTab({Key? key, required this.profile}) : super(key: key);

  @override
  State<ContactTab> createState() => _ContactTabState();
}

class _ContactTabState extends State<ContactTab> {
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  Country selectedCountry = CountryPickerUtils.getCountryByIsoCode('ng');

  bool processing = false;

  setProfileDataFromResponse(Map data) {
    _countryController.text = data['country'] ?? 'NG';
    _currencyController.text = data['currency'] ?? 'NGN';
    _stateController.text = data['state'] ?? '';
    _postalCodeController.text = data['postalCode'] ?? '';
    if (data['country'] != null &&
        data['country'].toString().toLowerCase() != 'ng') {
      setState(() {
        selectedCountry = CountryPickerUtils.getCountryByIsoCode(
            data['country'].toString().toLowerCase());
      });
    }
  }

  _updateProfile() {
    if(!processing){
      BlocProvider.of<ProfileCubit>(context).updateProfile(
        country: _countryController.text, state: _stateController.text, 
        postalCode: _postalCodeController.text, currency: _currencyController.text
      );
    }
  }
  @override
  void initState() {
    super.initState();
    setProfileDataFromResponse(widget.profile);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if(state is ProcessingRequest){
          setState(() => processing = true);
        }else if(state is RequestSuccess){
          context.pop();
          setState(() => processing = false);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 12),
            child: Text(
              "Country",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
            ),
          ),
          CountryPicker(
            triger: Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.textFaded,
                  width: 1.4,
                ),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: _countryController.text.isNotEmpty ? 12 : 6,
                  vertical: 18),
              child: _countryController.text.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _countryController.text.isNotEmpty
                                ? CountryPickerUtils.getDefaultFlagImage(
                                    selectedCountry)
                                : const SizedBox(),
                            horizontalSpacing(8),
                            Text(
                              _countryController.text,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 22,
                          color: Theme.of(context).accentColor,
                        )
                      ],
                    )
                  : Text(
                      "Select Country",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.textFaded,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
            ),
            onPicked: (Country country) {
              setState(() {
                selectedCountry = country;
                _countryController.text = country.iso3Code!.toUpperCase();
                _currencyController.text = country.currencyCode!.toUpperCase();
              });
            },
            selectedCountry: selectedCountry,
          ),
          verticalSpacing(28),
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 12),
            child: Text(
              "State",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
            ),
          ),
          TextInput(
            label: "",
            controller: _stateController,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            type: TextInputType.text,
            bordered: true,
            readOnly: false,
          ),
          verticalSpacing(28),
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 12),
            child: Text(
              "Postal Code",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
            ),
          ),
          TextInput(
            label: "",
            controller: _postalCodeController,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            type: TextInputType.text,
            bordered: true,
            readOnly: false,
          ),
          verticalSpacing(20),
          Button.primary(
            onPressed: () => _updateProfile(),
            title: "Save Changes",
            background: !processing ? AppColors.primary : Theme.of(context).colorScheme.primary.withOpacity(.6),
            foreground: AppColors.secoundaryLight,
          ),
        ],
      ),
    );
  }
}
