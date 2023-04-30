import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:truvender/utils/spacing.dart';
import 'package:truvender/widgets/widgets.dart';
import 'package:flutter/material.dart';

class KycWrapper extends StatelessWidget {
  const KycWrapper(
      {Key? key,
      required this.child,
      this.description = 'Almost there!. Verify your account to continue',
      this.showExitButton = true})
      : super(key: key);
  final Widget child;
  final String description;
  final bool showExitButton;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: AuthHeader(
                        actionText: 'KYC',
                        description: description,
                      ),
                    ),
                    showExitButton
                        ? IconButton(
                            onPressed: () => context.pop(),
                            icon: const SizedBox(
                              child: Icon(
                                CupertinoIcons.xmark,
                                size: 28,
                              ),
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
                verticalSpacing(20),
                child
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final Widget child;
  const AuthWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 60.0, 24.0, 0),
            child: child,
          ),
        ),
      ),
    );
  }
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({Key? key, required this.child, this.topSpace = 20.0})
      : super(key: key);
  final Widget child;
  final double topSpace;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Container(margin: EdgeInsets.only(top: topSpace), child: child),
      ),
    );
  }
}




class Wrapper extends StatelessWidget {
  const Wrapper({Key? key, required this.title, required this.child, this.subTitle})
      : super(key: key);

  final String title;
  final String? subTitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        leadingWidth: 46,
        leading: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            child: Icon(
              Icons.arrow_back_rounded,
              size: 28,
              color: Theme.of(context).accentColor,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.w800,
                fontSize: 14
              ),
            ),
            verticalSpacing(4),
            subTitle != null ? Text(
              subTitle!,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 12),
            ) : const SizedBox(),
          ],
        ),
      ),
      body: child,
    );
  }
}
