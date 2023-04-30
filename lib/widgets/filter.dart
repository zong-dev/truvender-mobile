import 'package:flutter/material.dart';
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
  Map<String, dynamic> selector = {
    "dateFrom": "",
    "dateTo": "",
    "filterBy": "createdAt",
  };

  List<String> categories = const ['amount', 'date', 'type'];

  List<int> durations = const [1, 3, 6];

  @override
  Widget build(BuildContext context) {
    onCategoryChecked(value) {
      setState(() {
        selector['filterBy'] = value;
      });
      widget.onChange(selector);
    }

    Widget buildCheckbox(String text, int index, dynamic value, String type) {
      return CheckCard(
        label: text,
        value: value,
        checked: (selectedCategory == index) ? true : false,
        onChecked: () {
          setState(() {
            if (type == 'category') {
              selector['filterBy'] = value;
              selectedCategory = index;
            } else {
              selectedDuration = index;
              selector['dateFrom'] = DateTime.now()
                  .subtract(Duration(days: 30 * durations[index]));
              selector['dateTo'] = DateTime.now();
            }
          });
        },
      );
    }

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
            return buildCheckbox(categories[index].toLowerCase(), index,
                categories[index], 'category');
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
            return buildCheckbox("${durations[index]} Month", index,
                durations[index], 'duration');
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
                  Text(
                    "Start Date",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).accentColor.withOpacity(.8),
                        ),
                  )
                ],
              ),
            ),
            horizontalSpacing(16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Start Date",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).accentColor.withOpacity(.8),
                        ),
                  )
                ],
              ),
            )
          ],
        ),
        verticalSpacing(38),
        Button.primary(
          onPressed: () {},
          title: "Submit",
          foreground: Colors.white,
          background: Theme.of(context).colorScheme.primary.withGreen(38),
        ),
      ],
    );
  }
}
