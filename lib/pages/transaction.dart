import 'package:flutter/material.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class TransactionPage extends StatelessWidget {
  final Transaction transaction;
  const TransactionPage({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color forground;

    if (transaction.type == 'debit') {
      icon = Icons.upload_rounded;
    } else {
      icon = Icons.download_rounded;
    }

    if (transaction.status == 'success') {
      forground = Theme.of(context).colorScheme.primary.withGreen(200);
    } else if (transaction.status == 'failed') {
      forground = Theme.of(context).colorScheme.primary.withRed(200);
    } else {
      forground = Colors.amber.shade700;
    }

    generateReceipt() async {
      Map data = {
        
      };
    }

    return Wrapper(
      title: "Transaction Info",
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 26),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 58,
                        width: 58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).cardColor,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1), //(x,y)
                              blurRadius: .8,
                              spreadRadius: -1,
                            ),
                          ],
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Icon(
                            icon,
                            size: 38,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      horizontalSpacing(12),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ucFirst(transaction.type),
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                    ),
                          ),
                          verticalSpacing(6),
                          Text(
                            "Fee",
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      // letterSpacing: 1.2,
                                    ),
                          )
                        ],
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        transaction.formatedAmount,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).accentColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      verticalSpacing(6),
                      Text(
                        transaction.formatedFee,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).accentColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              // letterSpacing: 1.2,
                            ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  child: Divider(
                    height: 2,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                Positioned(
                  top: 8.6,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: AppColors.secoundaryLight,
                      ),
                      child: Text(
                        "${transaction.date}",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.accent),
                      ),
                    ),
                  ),
                )
              ],
            ),
            verticalSpacing(16),
            KeyValue(
              name: "REF",
              value: transaction.ref,
            ),
            verticalSpacing(22),
            KeyValue(
              name: "STATUS",
              value: transaction.status.toUpperCase(),
              valueColor: forground,
            ),
            verticalSpacing(22),
            KeyValue(
              name: "AMOUNT",
              value: transaction.formatedAmount,
            ),
            verticalSpacing(22),
            KeyValue(
              name: "DENOMINATION",
              value: transaction.denomination.toUpperCase(),
            ),
            Expanded(
              child: Stack(children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Button.primary(
                    onPressed: () => generateReceipt(),
                    title: "Share Reciept",
                    background: AppColors.primary,
                    foreground: AppColors.secoundaryLight,
                  ),
                ),
                verticalSpacing(20)
              ]),
            )
          ],
        ),
      ),
    );
  }
}