import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class TypeModal extends StatefulWidget {
  final Function onSelect;
  final String label;
  const TypeModal({Key? key, required this.onSelect, required this.label})
      : super(key: key);

  @override
  State<TypeModal> createState() => _TypeModalState();
}

class _TypeModalState extends State<TypeModal> {
  List<String> tradeTypes = ["buy", "sell"];

  Widget _buildTile(String type) {
    return InkWell(
      onTap: () {
        widget.onSelect(type);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, top: 8),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 1,
              color: AppColors.textFaded,
            )),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(.9),
                  child: Icon(
                    type == "sell"
                        ? CupertinoIcons.paperplane_fill
                        : CupertinoIcons.creditcard_fill,
                    size: 26,
                    color: AppColors.backgroundLight,
                  ),
                ),
                horizontalSpacing(12),
                Text(
                  "${ucFirst(type)} ${ucFirst(widget.label)}",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).accentColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w900),
                )
              ],
            ),
            Icon(
              Icons.arrow_forward_rounded,
              size: 24,
              color: Theme.of(context).accentColor,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      height: double.maxFinite,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Choose Trade Type",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor),
            textAlign: TextAlign.center,
          ),
          verticalSpacing(16),
          _buildTile(tradeTypes[0]),
          _buildTile(tradeTypes[1]),
        ],
      ),
    );
  }
}

class CardValueModal extends StatefulWidget {
  final Function onSelect;
  final int? currentAmount;
  final int? price;
  final Giftcard asset;
  final List values;
  const CardValueModal({Key? key, required this.onSelect, this.currentAmount = 0, this.price = 0, required this.asset, required this.values}) : super(key: key);

  @override
  _CardValueModalState createState() => _CardValueModalState();
}

class _CardValueModalState extends State<CardValueModal> {
  final TextEditingController _otherAmountController = TextEditingController();
  int amount = 0;
  int price = 0;
  List prices = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      price = widget.price!;
      amount = widget.currentAmount!;
      prices = widget.values.map((val) => val.toString()).toList();
    });
  }

  Widget buildWidgetList(int denomination, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 48,
                width: 86,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl:
                        widget.asset.image,
                    placeholder: (context, url) => const SizedBox(
                      height: 40,
                      width: 40,
                      child: LoadingWidget(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              horizontalSpacing(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ucFirst(widget.asset.name),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).accentColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  verticalSpacing(6),
                  Text(
                    "\$$value",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.green.shade400,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              )
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.secoundaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (amount > 0) {
                      setState(() {
                        if (price.toString() != value) {
                          price = int.parse(value);
                          amount = 0;
                        }else {
                          amount--;
                        }
                      });
                    }
                  },
                  child: Icon(
                    CupertinoIcons.minus_circle,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                ),
                horizontalSpacing(12),
                Text(
                  "$denomination",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                horizontalSpacing(12),
                GestureDetector(
                  onTap: () {
                    if (amount < 5) {
                      setState(() {
                        if(price.toString() != value){
                          price = int.parse(value);
                        }
                        amount++;
                      });
                    }else{toastMessage(message: "Maximum cards per trade is 5", context: context);}
                  },
                  child: Icon(
                    CupertinoIcons.plus_circle,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget customPrice() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).cardColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  onChanged: (_) => setState(() {
                    price = int.parse(_otherAmountController.text);
                    amount = 1;
                  }),
                  controller: _otherAmountController,
                  keyboardType: TextInputType.number,
                  cursorColor: Theme.of(context).accentColor,
                  decoration: InputDecoration(
                    label: Text("Other Giftcard Amount", style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 14,
                      color: AppColors.textFaded,
                      fontWeight: FontWeight.bold
                    ),),
                    contentPadding:
                       const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      gapPadding: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          horizontalSpacing(12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.secoundaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (amount > 0 && _otherAmountController.text.isNotEmpty) {
                      setState(() => amount--);
                    }
                  },
                  child: Icon(
                    CupertinoIcons.minus_circle,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                ),
                horizontalSpacing(12),
                Text(
                  _otherAmountController.text.isEmpty ? "0" : "$amount",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                horizontalSpacing(12),
                GestureDetector(
                  onTap: () {
                    if (amount < 5 && _otherAmountController.text.isNotEmpty) {
                      setState(() => amount++);
                    } else {
                      toastMessage(message: "Maximum cards per trade is 5", context: context);
                    }
                  },
                  child: Icon(
                    CupertinoIcons.plus_circle,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 6, left: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: prices.length + 1,
                scrollDirection: Axis.vertical,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index < (prices.length)) {
                    return buildWidgetList(
                      price.toString() == prices[index] ? amount : 0,
                      prices[index],
                    );
                  } else {
                    return customPrice();
                  }
                },
              ),
            ),
            verticalSpacing(26),
            Button.primary(
              onPressed: () {
                widget.onSelect(amount, price);
                Navigator.pop(context);
              },
              background: AppColors.primary,
              foreground: AppColors.secoundaryLight,
              title: "Continue",
            ),
          ],
        ),
      ),
    );
  }
}


class StatusModal extends StatelessWidget {
  final String type;
  final String title;
  final String? subTitle;
  Function? next;
  StatusModal({ Key? key, required this.type, required this.title, this.subTitle, this.next }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    pickIcon() {
      String imagePath = "assets/images/info.png";
      if (type == 'success') {
        imagePath = "assets/images/success.png";
      }else if(type == 'error'){
        imagePath = "assets/images/error.png";
      }
      return Image.asset(
        imagePath, 
        height: 100,
        width: 120,
      );
    }


    return Container(
      height: MediaQuery.of(context).size.height / 3.1,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background.withOpacity(.8),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          pickIcon(),
          verticalSpacing(20),
          Text(
            title, 
            style: GoogleFonts.montserrat(
              fontSize:  18,
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.w900
            ),
          ),
          verticalSpacing(12),
          Text(
            subTitle ?? '',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).accentColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
          ),
          verticalSpacing(40),
          Button.primary(onPressed: () {
            if(next != null){
              next!();
            }else {
               Navigator.pop(context);
            }
          }, background: AppColors.primary, foreground: AppColors.secoundaryLight,title: "Close",),

        ],
      ),
    );
  }
}