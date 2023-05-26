import 'package:flutter/material.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 86,
            width: double.maxFinite,
            child: Image.asset(
              'assets/images/error-icon.png',
              height: 86,
            ),
          ),
          verticalSpacing(30),
          Text(
            "Connection Error!",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).accentColor,
                ),
            textAlign: TextAlign.center,
          ),
          verticalSpacing(20),
          Text(
            "Your connection seem to be down or slow to reach our server",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).accentColor,
                ),
            textAlign: TextAlign.center,
          ),
          verticalSpacing(20),
          TextButton(
            onPressed: () {},
            clipBehavior: Clip.none,
            child: Text(
              "TRY AGAIN",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.redLight,
                  ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
