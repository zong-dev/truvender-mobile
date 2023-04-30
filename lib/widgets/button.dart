import 'package:flutter/material.dart';
import 'package:truvender/theme.dart';

class Button extends StatelessWidget {
  Button.primary(
      {Key? key,
      this.background = AppColors.backgroundDark,
      this.foreground = AppColors.backgroundLight,
      this.title = '',
      this.height = 54,
      this.iconSize = 0,
      this.radius = 14.0,
      this.width = double.infinity,
      this.disable = false,
      this.icon,
      required this.onPressed, this.fontSize = 16})
      : super(key: key);

  Button.light(
      {Key? key,
      this.background = AppColors.secoundaryLight,
      this.foreground = AppColors.accent,
      this.title = '',
      this.height = 54,
      this.radius = 14.0,
      this.iconSize = 24,
      this.width = double.infinity,
      this.icon,
      required this.onPressed, this.fontSize = 16, this.disable = false})
      : super(key: key);

  final Color background;
  String title;
  final Color? foreground;
  final VoidCallback onPressed;
  final double radius;
  final double width;
  final double height;
  final IconData? icon;
  final double iconSize;
  final double fontSize;
  final bool disable;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.all(Radius.circular(radius), ),
          border: Border.all(
            width: 1,
            color: background
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon != null ? Icon(
              icon,
              size: iconSize,
              color: foreground,
            ) : const SizedBox(),
            title.isNotEmpty ? Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w800,
                      fontSize: fontSize,
                    ),
              ),
            ): const SizedBox(),
          ],
        ),
      ),
    );
  }
}


class TileButton extends StatelessWidget {
  const TileButton({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.secoundaryLight,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        Icons.chevron_right_rounded,
        size: 26,
        color: Theme.of(context).colorScheme.primary.withGreen(34),
      ),
    );
  }
}