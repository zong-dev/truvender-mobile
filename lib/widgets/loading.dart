import 'package:flutter/material.dart';
import 'package:truvender/theme.dart';
class LoadingWidget extends StatelessWidget {
  final String? text;
  const LoadingWidget({ Key? key, this.text }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primary,
          ),
          text!= null ? Text(
            text ?? "",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor
            ),
          ) : const SizedBox()
        ],
      ),
    );
  }
}