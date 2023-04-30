import 'package:flutter/material.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/spacing.dart';

class AuthHeader extends StatelessWidget {

  AuthHeader({ Key? key, required this.actionText, this.description = '' }) : super(key: key);

  final String actionText;
  String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          actionText,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        verticalSpacing(10),
        Image.asset(
          'assets/images/accent.png',
          width: 99,
          height: 4,
        ),
        description.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textFaded,
                  ),
                ),
              )
            : verticalSpacing(30),
      ],
    );
  }
}