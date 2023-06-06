import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LogoWidget extends StatelessWidget {
  
  const LogoWidget({Key? key, required this.withText})
      : size = 58,
        font = 24,
        super(key: key);

  const LogoWidget.small({Key? key, required this.withText})
      : size = 36,
        font = 18,
        super(key: key);

  final bool withText;
  final double size;
  final double font;
  
  @override
  Widget build(BuildContext context) {

    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;


    if (withText) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size,
              width: 300,
              child: Image.asset(
                !isDarkMode ? 'assets/images/logo/logo-long-dark.png' : 'assets/images/logo/logo-long.png',
                width: size,
                height: size,
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 20.0),
            //   child: Text(
            //     "truvender",
            //     style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            //       fontWeight: FontWeight.bold,
            //       fontSize: 16
            //     ),
            //   ),
            // )
          ],
        );
    } else {
      return Image.asset(
          !isDarkMode
                ? 'assets/images/logo/logo-dark.png'
                : 'assets/images/logo/logo.png',
            width: size,
            height: size,
          );
    }
  }
}
