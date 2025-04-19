import 'package:design_task/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomIconButtonWithSplashEffect extends StatefulWidget {
  const CustomIconButtonWithSplashEffect({
    super.key,
    required this.onTap,
    required this.child,
  });

  final Function() onTap;
  final Widget child;
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
        widget.onTap();
        _innerSplashController.reverse();
        _outerSplashController.reset();
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
                        width: 50.h - (15.h * _outerSplashRadiusValue.value),
                        height: 50.h - (15.h * _outerSplashRadiusValue.value),
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
                        width: 31.h + (20.h * _innerSplashRadiusValue.value),
                        height: 31.h + (20.h * _innerSplashRadiusValue.value),
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
