import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/spacing.dart';
import 'package:truvender/widgets/widgets.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 100),
        child: Stack(
          children: [
            Positioned(
              top: 80,
              child: Image.asset(
                'assets/images/rectangle_curved.png',
                height: 580,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Image.asset(
                'assets/images/elipse.png',
                height: 600,
              ),
            ),
            Column(
              children: [
                Column(
                  children: [
                    const LogoWidget.small(
                      withText: true,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 1.86,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Stack(
                          children: [
                            Opacity(
                              opacity: 0.1,
                              child: Image.asset(
                                'assets/images/girl.png',
                                color: Colors.black,
                                height: 380.0,
                              ),
                            ),
                            ClipRect(
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                                child: Image.asset('assets/images/girl.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Tru Trade - Tru Flex",
                                  style: GoogleFonts.montserrat(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                verticalSpacing(20),
                                Text(
                                  "It’s more than just trading, experience world class \n transaction processes with Turvender.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.nunito(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () => BlocProvider.of<AppBloc>(context).add(
                                SignOut()
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                width: double.infinity,
                                decoration:  BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                     Text(
                                      "Get Started",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.secoundaryLight,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // horizontalSpacing(12),
                                    // const Icon(
                                    //   CupertinoIcons.arrow_right_circle_fill,
                                    //   size: 20,
                                    //   color: Colors.white,
                                    // ),
                                  ],
                                ),
                              ),
                            )
                          ]),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
