import 'package:design_task/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomIconButtonWithSplashEffect extends StatefulWidget {
  const CustomIconButtonWithSplashEffect({
    super.key,
    required this.onTap,
    required this.child,
    required this.outerWidthAndHeight,
    required this.innerWidthAndHeight,
  });

  final Function() onTap;
  final Widget child;
  final double outerWidthAndHeight;
  final double innerWidthAndHeight;
  @override
  State<CustomIconButtonWithSplashEffect> createState() =>
      _CustomIconButtonWithSplashEffectState();
}

class _CustomIconButtonWithSplashEffectState
    extends State<CustomIconButtonWithSplashEffect>
    with TickerProviderStateMixin {
  late AnimationController _innerSplashController;
  late AnimationController _outerSplashController;
  late Animation<double> _innerSplashRadiusValue;
  late Animation<double> _outerSplashRadiusValue;

  @override
  void initState() {
    super.initState();
    _innerSplashController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _outerSplashController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );

    _innerSplashRadiusValue = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _innerSplashController, curve: Curves.easeInOut),
    );
    _outerSplashRadiusValue = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _outerSplashController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _innerSplashController.dispose();
    _outerSplashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await _innerSplashController.forward();
        _outerSplashController.forward();
        _innerSplashController.reverse();
        _outerSplashController.reset();
        widget.onTap();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          widget.child,
          Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                  animation: _outerSplashRadiusValue,
                  builder: (context, child) {
                    return Visibility(
                      visible: _outerSplashRadiusValue.value < 1,
                      child: Container(
                        width: widget.outerWidthAndHeight -
                            (15.h * _outerSplashRadiusValue.value),
                        height: widget.outerWidthAndHeight -
                            (15.h * _outerSplashRadiusValue.value),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(30.r),
                          border: Border.all(color: Palette.white),
                        ),
                      ),
                    );
                  }),
              AnimatedBuilder(
                  animation: _innerSplashRadiusValue,
                  builder: (context, child) {
                    return Visibility(
                      visible: _innerSplashRadiusValue.value < 1,
                      child: Container(
                        width: widget.innerWidthAndHeight +
                            (20.h * _innerSplashRadiusValue.value),
                        height: widget.innerWidthAndHeight +
                            (20.h * _innerSplashRadiusValue.value),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(30.r),
                          border: Border.all(
                            color: Palette.white,
                            width: 5.h - (4.h * _innerSplashRadiusValue.value),
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
