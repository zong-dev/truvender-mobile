// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';


class QuickAction extends StatelessWidget {
  QuickAction(
      {required this.name,
      required this.icon,
      required this.context,
      required this.onTap});

  final String name;
  final Widget icon;
  final BuildContext context;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {

    bool isDarkMode = usingDarkmode();

    Color _getColor() {
      if(isDarkMode){
        return Theme.of(context).cardColor;
      }
      return AppColors.secoundaryLight;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(
          right: 16,
        ),
        width: 140,
        height: 60,
        padding: const EdgeInsets.only(right: 8, left: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: _getColor()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            verticalSpacing(8),
            Text(
              name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
