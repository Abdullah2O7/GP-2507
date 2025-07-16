import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  const CustomShimmer({
    super.key,
    this.height,
    this.width,
    this.shape = BoxShape.rectangle,
    this.baseColor = Colors.grey,
  });
  final double? height;
  final double? width;
  final MaterialColor baseColor;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor.shade300,
      highlightColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius:
              shape != BoxShape.circle ? BorderRadius.circular(5) : null,
          shape: shape,
        ),
        height: height,
        width: width,
      ),
    );
  }
}
