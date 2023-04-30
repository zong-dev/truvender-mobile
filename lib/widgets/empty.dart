import 'package:flutter/material.dart';

class EmptyData extends StatelessWidget {
  final String text;
  const EmptyData({ Key? key, required this.text }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.maxFinite,
      width: double.maxFinite,
      child: Center(
        child: Text(text, style: Theme.of(context).textTheme.headlineMedium!.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: Theme.of(context).accentColor
        ),),
      ),
    );
  }
}