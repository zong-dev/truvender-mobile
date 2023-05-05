import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class OperationTile extends StatelessWidget {
  const OperationTile(
      {Key? key,
      required this.title,
      required this.icon,
      required this.onTap,
      this.subTitle = ''})
      : super(key: key);

  final IconData icon;
  final String title;
  final String subTitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 86,
        padding: const EdgeInsets.only(left: 20),
        decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: AppColors.textFaded, width: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 54,
              width: 54,
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
                  color: title == 'Crypto'
                      ? Colors.orange[300]
                      : Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            horizontalSpacing(16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          letterSpacing: 0.2,
                          wordSpacing: 1.5,
                          fontWeight: FontWeight.w900),
                    ),
                    verticalSpacing(8),
                    SizedBox(
                      height: 20,
                      child: Text(
                        subTitle,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textFaded,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            verticalSpacing(12),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  verticalSpacing(8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.secoundaryLight,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 26,
                      color:
                          Theme.of(context).colorScheme.primary.withGreen(34),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ActivityTile extends StatelessWidget {
  final Transaction transaction;
  const ActivityTile({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color forground;

    if (transaction.type == 'debit') {
      icon = Icons.upload_rounded;
      forground = Theme.of(context).colorScheme.primary.withRed(220);
    } else {
      icon = Icons.download_rounded;
      forground = Theme.of(context).colorScheme.primary.withGreen(200);
    }

    return InkWell(
      onTap: () => context.pushNamed(
        "transaction",
        extra: transaction,
      ),
      child: Container(
        height: 86,
        padding: const EdgeInsets.only(left: 20),
        decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: AppColors.textFaded, width: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 54,
              width: 54,
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
            horizontalSpacing(16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      transaction.formatedAmount,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          letterSpacing: 0.2,
                          wordSpacing: 1.5,
                          fontWeight: FontWeight.w900),
                    ),
                    verticalSpacing(8),
                    SizedBox(
                      height: 20,
                      child: Row(
                        children: [
                          Text(
                            ucFirst(transaction.type),
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: forground,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                          ),
                          horizontalSpacing(10),
                          Text(
                            transaction.date,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: AppColors.textFaded,
                                  fontSize: 12,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            verticalSpacing(12),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  verticalSpacing(8),
                  TileButton(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TradeTile extends StatelessWidget {
  final Trade trade;
  const TradeTile({Key? key, required this.trade}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color foreground;

    switch (trade.assetType) {
      case "crypto":
        icon = CupertinoIcons.bitcoin_circle_fill;
        break;
      case "gift card":
        icon = CupertinoIcons.gift_alt_fill;
        break;
      case "spending card":
        icon = CupertinoIcons.creditcard_fill;
        break;
      default:
        icon = Icons.card_travel;
        break;
    }

    if (trade.status == 'success') {
      foreground = Theme.of(context).colorScheme.primary.withGreen(200);
    } else if (trade.status == 'pending') {
      foreground = Colors.amber.shade700;
    } else if (trade.status == 'on-hold') {
      foreground = AppColors.textFaded;
    } else {
      foreground = Theme.of(context).colorScheme.primary.withRed(220);
    }

    return InkWell(
      onTap: () => context.pushNamed(
        "trade",
        extra: trade,
      ),
      child: Container(
        height: 86,
        padding: const EdgeInsets.only(left: 20),
        decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: AppColors.textFaded, width: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 54,
              width: 54,
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
            horizontalSpacing(16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ucFirst(trade.assetType),
                          // overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            letterSpacing: 0.2,
                            wordSpacing: 1.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        horizontalSpacing(20),
                        Text(
                          trade.formatedAmount,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            letterSpacing: 0.2,
                            wordSpacing: 1.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ucFirst(trade.status),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: foreground,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                          ),
                          horizontalSpacing(12),
                          Text(
                            trade.date,
                            textAlign: TextAlign.end,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: AppColors.textFaded,
                                  fontSize: 12,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            verticalSpacing(12),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  verticalSpacing(8),
                  const TileButton(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


class SettingTile extends StatelessWidget {
  final String label; 
  final IconData iconLeft; 
  final Widget? iconRight;
  final Function? onTap;
  final EdgeInsets padding;

  const SettingTile({ Key? key, required this.label, required this.iconLeft, this.iconRight, this.onTap, this.padding = const EdgeInsets.only(left: 20)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(onTap != null) {
          onTap!();
        }
      },
      child: Container(
        height: 76,
        padding: const EdgeInsets.only(left: 20),
        decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: AppColors.textFaded, width: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 46,
              width: 46,
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
                  iconLeft,
                  size: 30,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            horizontalSpacing(16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                          letterSpacing: 0.2,
                          wordSpacing: 1.5,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            ),
            verticalSpacing(12),
            iconRight != null ? Padding(
              padding: const EdgeInsets.only(right: 20),
              child: iconRight,
            ) : const SizedBox(),
          ],
        ),
      ),
    );
  }
}


class NotificationTile extends StatelessWidget {

  final Notify notification;

  const NotificationTile(
      {Key? key,
      required this.notification
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    void openTransaction() async {
      // Mark notification as seen
      openBottomSheet(context: context, 
      label: notification.data.title,
      child: Column(
        children: [
            Text(
              notification.data.message,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 14
              ),
            ),
            verticalSpacing(12),
            notification.data.toString().isNotEmpty ? Text(
                formatDate(notification.data.message),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 14),
              ) : const SizedBox()
        ],
      ));
    }

    return InkWell(
      onTap: () => openTransaction(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: AppColors.textFaded, width: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Text(
              notification.data.message,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor,
                  ),
            )),
            Text(
              formatDate(
                notification.createdAt
              ),
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textFaded),
            )
          ],
        ),
      ),
    );
  }
}

class KeyValue extends StatelessWidget {
  final String name;
  final String value;
  final Color? valueColor;
  const KeyValue(
      {Key? key, required this.name, required this.value, this.valueColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color foreground = valueColor ?? Theme.of(context).accentColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).accentColor,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: foreground,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                // letterSpacing: 1.2,
              ),
        )
      ],
    );
  }
}



class WalletBalanceTile extends StatelessWidget {
  final Wallet wallet;
  const WalletBalanceTile({ Key? key, required this.wallet }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      padding: const EdgeInsets.symmetric(vertical:  14, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Row(
              children: [
                Icon(
                  CupertinoIcons.rectangle_fill_on_rectangle_fill,
                  size: 28,
                  color: Colors.amber.shade600,
                ),
                horizontalSpacing(8),
                Text(
                  "Wallet Balance",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                )
              ],
            ),
          Text(
            wallet.getFormattedAmount(),
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).accentColor,
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
}




class TradeValueTile extends StatelessWidget {
  final String title;
  final String value;
  const TradeValueTile({Key? key, required this.value, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.rectangle_fill_on_rectangle_fill,
                size: 28,
                color: Colors.amber.shade600,
              ),
              horizontalSpacing(8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
              )
            ],
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).accentColor,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
