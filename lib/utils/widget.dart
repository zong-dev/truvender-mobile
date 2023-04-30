import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

openBottomSheet(
    {required BuildContext context,
    double height = 420,
    double radius = 40,
    String label = '',
    bool enableDrag = false,
    required Widget child}) {
  showModalBottomSheet(
    enableDrag: false,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (_) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background.withOpacity(.8),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 26),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Icon(
                    CupertinoIcons.xmark,
                    size: 20,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ],
            ),
            verticalSpacing(22),
            child,
          ],
        ),
      );
    },
  );
}

Container beforeLoad() => Container(
      height: 100,
      padding: const EdgeInsets.only(left: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
      ),
      child: Row(
        children: [
          const ShimmerWidget.rounded(
            height: 50,
            width: 50,
            shapedBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          horizontalSpacing(10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ShimmerWidget.rectangle(height: 16),
                  verticalSpacing(8),
                  const ShimmerWidget.rectangle(height: 12),
                ],
              ),
            ),
          ),
          horizontalSpacing(12),
          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: ShimmerWidget.rounded(
              height: 36,
              width: 36,
              shapedBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          )
        ],
      ),
    );

Container beforeLoad2() => Container(
      height: 68,
      padding: const EdgeInsets.only(left: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  ShimmerWidget.rectangle(height: 16),
                ],
              ),
            ),
          ),
          horizontalSpacing(40),
          const Padding(
            padding: EdgeInsets.only(right: 26),
            child: ShimmerWidget.rectangle(
              height: 14,
              width: 60,
            ),
          )
        ],
      ),
    );


SizedBox beforeCardLoad(BuildContext context, double itemDiff) => SizedBox(
      width: (MediaQuery.of(context).size.width / 2) - 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment:
            (itemDiff > 0) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          const ShimmerWidget.rounded(
            height: 108,
            width: double.maxFinite,
            shapedBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          verticalSpacing(8),
          ShimmerWidget.rectangle(
            height: 18,
            width: (MediaQuery.of(context).size.width / 2.38) - 40,
          ),
        ],
      ),
    );
