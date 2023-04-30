import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/spacing.dart';


void notify(BuildContext context, String text, String type) {
  Color? background = type == 'error' ? AppColors.errorLight  : Colors.green[100];
  Color? foreground = type == 'error' ? AppColors.redLight  :  Colors.green[900];
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.fixed,
      duration: const Duration(seconds: 3),
      elevation: 0,
      backgroundColor: background,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              CupertinoIcons.info_circle,
              color: foreground,
              size: 26,
            ),
          ),
          Text(text, style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: foreground,
            fontWeight: FontWeight.w700
          ),),
        ],
      ),
    ),
  );
}


void toastMessage({ required String message, required BuildContext context}) {
  FToast fToast = FToast();
  fToast.init(context);
   Widget toast = Container(
     width: double.maxFinite,
     margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: AppColors.secoundaryLight.withOpacity(.6),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children:  [
        ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(8)),child: Image.asset("assets/images/icon.png", height: 24, width: 24 ),),
        horizontalSpacing(10),
        Expanded(
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.accent
            ),
          ),
        ),
      ],
    ),
  );
  fToast.showToast(
    child: toast,
    toastDuration: const Duration(seconds: 4),
    gravity: ToastGravity.BOTTOM,
  );
}