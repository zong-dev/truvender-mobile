import 'package:flutter/material.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class TradePage extends StatelessWidget {
  final Trade? trade;

  const TradePage({Key? key, this.trade}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      title: "Trade Info",
      child: Column(
        children: [
          Expanded(
            child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Button.primary(
                  onPressed: () {},
                  title: "Download Reciept",
                  background: AppColors.primary,
                  foreground: AppColors.secoundaryLight,
                ),
              ),
              verticalSpacing(20)
            ],
          ))
        ],
      ),
    );
  }
}
