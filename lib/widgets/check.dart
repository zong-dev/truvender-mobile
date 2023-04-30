import 'package:flutter/material.dart';
import 'package:truvender/utils/methods.dart';

class CheckCard extends StatefulWidget {
  final Function onChecked;
  final String label;
  final dynamic value;
  final bool checked;
  const CheckCard({ Key? key, required this.onChecked, required this.label, this.value, this.checked = false }) : super(key: key);

  @override
  _CheckCardState createState() => _CheckCardState();
}

class _CheckCardState extends State<CheckCard> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isChecked = widget.checked;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isChecked = isChecked == true ? false : true;
        });
        widget.onChecked(widget.value);
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: Theme.of(context).accentColor.withOpacity( isChecked ? 1 : .48),
            width: 1.4,
          ),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: const Offset(0.0, 1), //(x,y)
                blurRadius: .8,
                spreadRadius: isChecked ? -1 : -2,
              )
          ]
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              ucFirst(widget.label),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}