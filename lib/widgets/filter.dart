import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class FilterWidget extends StatefulWidget {
  final bool withDateFrom;
  final bool withDateTo;
  final bool withType;
  final Function onChange;
  FilterWidget({
    Key? key,
    this.withDateFrom = true,
    this.withDateTo = true,
    this.withType = true,
    required this.onChange,
  }) : super(key: key);

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  int selectedCategory = 0;
  int? selectedDuration = 0;
  final TextEditingController _dateController = TextEditingController();

  Map<String, dynamic> selector = {
    "dateFrom": "",
    "dateTo": "",
    "filterBy": "createdAt",
  };

  List<String> categories = const ['amount', 'date', 'type'];

  List<int> durations = const [1, 3, 6];

  @override
  Widget build(BuildContext context) {
    // onCategoryChecked(value) {
    //   setState(() {
    //     selector['filterBy'] = value;
    //   });
    //   widget.onChange(selector);
    // }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            "Fliter by",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          primary: true,
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 4,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selector['filterBy'] = categories[index].toLowerCase();
                  selectedCategory = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(
                  right: 12,
                ),
                alignment: Alignment.center,
                width: 130,
                height: 54,
                padding: const EdgeInsets.only(right: 8, left: 8),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selectedCategory == index
                          ? AppColors.secoundaryLight
                          : Theme.of(context).accentColor.withOpacity(.6),
                      width: 2,
                    )),
                child: Text(
                  ucFirst(categories[index].toLowerCase()),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            );
          },
        ),
        verticalSpacing(22),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            "Duration",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          primary: true,
          itemCount: durations.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 4,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDuration = index;
                  selector['dateFrom'] = DateTime.now()
                      .subtract(Duration(days: 30 * durations[index]));
                  selector['dateTo'] = DateTime.now();
                });
              },
              child: Container(
                margin: const EdgeInsets.only(
                  right: 12,
                ),
                alignment: Alignment.center,
                width: 130,
                height: 54,
                padding: const EdgeInsets.only(right: 8, left: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selectedDuration == index
                          ? AppColors.secoundaryLight
                          : Theme.of(context).accentColor.withOpacity(.6),
                      width: 2,
                    ),
                    color: Colors.transparent),
                child: Text(
                  "${durations[index]} Month",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            );
          },
        ),
        verticalSpacing(22),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            "Select Date",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  DatePicker(
                    label: 'Custom Date',
                    type: 'range',
                    controller: _dateController,
                    onChange: (values) {
                      selector['dateFrom'] = values[0];
                      selector['dateTo'] =
                          values[1] ?? DateFormat.yMd().format(DateTime.now());
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        verticalSpacing(38),
        Button.primary(
          onPressed: () {
            widget.onChange(selector);
            context.pop();
          },
          title: "Submit",
          foreground: Colors.white,
          background: Theme.of(context).colorScheme.primary.withGreen(38),
        ),
      ],
    );
  }
}

class CheckCard extends StatefulWidget {
  final Function onChecked;
  final String label;
  final dynamic value;
  final bool checked;
  const CheckCard(
      {Key? key,
      required this.onChecked,
      required this.label,
      this.value,
      this.checked = false})
      : super(key: key);

  @override
  _CheckCardState createState() => _CheckCardState();
}

class _CheckCardState extends State<CheckCard> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isChecked = widget.checked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isChecked = isChecked == true ? false : true;
        });
        widget.onChecked(widget.value);
      },
      child: SizedBox(),
    );
  }
}
