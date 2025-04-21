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
  late AnimationController _splashController;
  late Animation<double> _outerSplashAnimation;
  late Animation<double> _innerSplashAnimation;

  @override
  void initState() {
    super.initState();
    _splashController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );
    _innerSplashAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.5),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.5, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(parent: _splashController, curve: Curves.ease));
    _outerSplashAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _splashController,
        curve: Interval(0.1, 1.0, curve: Curves.ease),
      ),
    );
  }

  @override
  void dispose() {
    _splashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await _splashController.forward();
        _splashController.reset();
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
                animation: _outerSplashAnimation,
                builder: (context, child) {
                  double outerSplashHeightAndWidth =
                      widget.outerWidthAndHeight -
                          15.h * (_outerSplashAnimation.value);

                  return Visibility(
                    visible: _outerSplashAnimation.value < 1 &&
                        _splashController.isAnimating &&
                        outerSplashHeightAndWidth <=
                            widget.outerWidthAndHeight - 10.h,
                    child: Container(
                      width: outerSplashHeightAndWidth,
                      height: outerSplashHeightAndWidth,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(color: Palette.white),
                      ),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: _innerSplashAnimation,
                builder: (context, child) {
                  return Visibility(
                    visible: _innerSplashAnimation.value >= -0.5 &&
                        _splashController.isAnimating,
                    child: Container(
                      width: widget.innerWidthAndHeight +
                          (15.h * _innerSplashAnimation.value),
                      height: widget.innerWidthAndHeight +
                          (15.h * _innerSplashAnimation.value),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(
                          color: Palette.white,
                          width: 11.h - (10.h * _innerSplashAnimation.value),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
