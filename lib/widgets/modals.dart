import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';


class TypeModal extends StatefulWidget {
  final Function onSelect;
  final String label;
  const TypeModal({Key? key, required this.onSelect, required this.label})
      : super(key: key);

  @override
  State<TypeModal> createState() => _TypeModalState();
}


class _TypeModalState extends State<TypeModal> {
  List<String> tradeTypes = ["buy", "sell"];

  Widget _buildTile(String type) {
    return InkWell(
      onTap: () {
        widget.onSelect(type);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, top: 8),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 1,
              color: AppColors.textFaded,
            )),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(.9),
                  child: Icon(
                    type == "sell"
                        ? CupertinoIcons.paperplane_fill
                        : CupertinoIcons.creditcard_fill,
                    size: 26,
                    color: AppColors.backgroundLight,
                  ),
                ),
                horizontalSpacing(16),
                Text(
                  "${ucFirst(type)} ${ucFirst(widget.label)}",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).accentColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w900),
                )
              ],
            ),
            Icon(
              Icons.arrow_right,
              size: 34,
              color: Theme.of(context).accentColor,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
      child: Column(
        children: [
          Text(
            "Choose Trade type",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor),
            textAlign: TextAlign.center,
          ),
          verticalSpacing(30),
          _buildTile(tradeTypes[0]),
          _buildTile(tradeTypes[1]),
        ],
      ),
    );
  }
}
