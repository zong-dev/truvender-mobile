import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/currency_picker_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:truvender/cubits/profile/profile_cubit.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class CountryPicker extends StatefulWidget {
  final Widget triger;
  final Country? selectedCountry;
  final Function onPicked;

  const CountryPicker(
      {Key? key,
      required this.triger,
      required this.onPicked,
      this.selectedCountry})
      : super(key: key);

  @override
  _CountryPickerState createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  @override
  void initState() {
    super.initState();
  }

  void openCurrencyPicker() => showDialog(
        context: context,
        builder: (context) => SizedBox(
          child: CurrencyPickerDialog(
            titlePadding: const EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: const InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: const Text('Select Country'),
            onValuePicked: (Country country) {
              widget.onPicked(country);
            },
            itemBuilder: _buildCurrencyDialogItem,
          ),
        ),
      );

  Widget _buildCurrencyDialogItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          const SizedBox(width: 8.0),
          Flexible(
            child: Text(country.name ?? ''),
          ),
          const SizedBox(width: 8.0),
          Text("(${country.currencyCode})"),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openCurrencyPicker,
      child: SizedBox(
        child: widget.triger,
      ),
    );
  }
}

class VarationPicker extends StatefulWidget {
  final String title;
  final List variations;
  final Function onChange;
  final Map currentState;

  const VarationPicker(
      {Key? key,
      required this.variations,
      required this.onChange,
      required this.currentState,
      required this.title})
      : super(key: key);

  @override
  _VarationPickerState createState() => _VarationPickerState();
}

class _VarationPickerState extends State<VarationPicker> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
    child: widget.variations.isNotEmpty ? ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: widget.variations.length,
      itemBuilder: (context, index) {
        Map bundle = widget.variations[index];
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(
                width: 0.8, color: Theme.of(context).accentColor),
          )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                bundle['name'],
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).accentColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              Radio(
                value: bundle,
                groupValue: widget.currentState,
                onChanged: (value) {
                  if (value != null && value != widget.currentState) {
                    widget.onChange(value);
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        );
      },
    ) : const LoadingWidget()
    );
  }
}



//==================== Bank

class BankPicker extends StatefulWidget {
  Map? selectedBank;
  final Function onSelected;
  final List banks;
  BankPicker({Key? key, required this.onSelected, this.selectedBank, required this.banks})
      : super(key: key);

  @override
  _BankPickerState createState() => _BankPickerState();
}

class _BankPickerState extends State<BankPicker> {
  final TextEditingController _searchController = TextEditingController();
  List banks = [];
  List filteredBanks = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      banks = widget.banks;
      filteredBanks = banks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextInput(
            label: 'Search bank by name',
            type: TextInputType.text,
            controller: _searchController,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            bordered: true,
            onChange: () {
              setState(() {
                if (_searchController.text.isNotEmpty) {
                  filteredBanks = banks
                      .where((bnk) => bnk['name']
                          .toString()
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase()))
                      .toList();
                }
              });
            },
            iconPreffix: Icon(
              CupertinoIcons.search,
              size: 22,
              color: Theme.of(context).accentColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 25, bottom: 10, left: 12, right: 12),
            child: Divider(
              height: 1.4,
              color: Theme.of(context).accentColor,
            ),
          ),
          Expanded(
            child: filteredBanks.isNotEmpty
                ? ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: filteredBanks.length,
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.only(bottom: 8),
                    itemBuilder: (context, index) {
                      Map<String, dynamic> bank = filteredBanks[index];
                      return GestureDetector(
                        onTap: () {
                          widget.onSelected(bank);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 18),
                          margin: const EdgeInsets.symmetric(horizontal: 18),
                          decoration: BoxDecoration(
                            color: widget.selectedBank != null &&
                                    bank == widget.selectedBank
                                ? AppColors.secoundaryLight.withAlpha(6)
                                : Colors.transparent,
                            border: const Border(
                              bottom: BorderSide(
                                  width: 0.8, color: AppColors.textFaded),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                bank['name'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const LoadingWidget(),
          ),
        ],
      ),
    );
  }
}
