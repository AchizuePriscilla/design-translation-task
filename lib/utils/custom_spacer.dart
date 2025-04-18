import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSpacer extends StatelessWidget {
  final bool? horizontal;
  final double? flex;

  const CustomSpacer({super.key, this.horizontal= false, this.flex= 2});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: !horizontal! ? 4.h * flex! : 0,
      width: horizontal! ? 4.w * flex! : 0,
    );
  }
}
