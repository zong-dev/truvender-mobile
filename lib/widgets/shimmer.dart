import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapedBorder;

  const ShimmerWidget.rectangle(
      {Key? key, this.width = double.infinity, this.height = double.infinity})
      : shapedBorder = const RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(8)), );

  const ShimmerWidget.rounded(
      {Key? key,
      required this.height,
      required this.width,
      this.shapedBorder = const CircleBorder()});
  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: Colors.grey[400]!,
        highlightColor: Colors.grey[300]!,
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            shape: shapedBorder,
            color: Colors.grey[400],
          ),
        ),
      );
}
