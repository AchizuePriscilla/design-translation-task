import 'package:design_task/utils/custom_icon_button_with_splash_effect.dart';
import 'package:design_task/views/home_view.dart';
import 'package:design_task/views/map_view.dart';
import 'package:design_task/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RealEstateApp extends StatefulWidget {
  const RealEstateApp({super.key});

  @override
  State<RealEstateApp> createState() => _RealEstateAppState();
}

class _RealEstateAppState extends State<RealEstateApp>
    with TickerProviderStateMixin {
  int _selectedPage = 2;
  late AnimationController _pageFadeController;
  late AnimationController _bottomBarSlideController;
  late Animation<double> _pageFade;
  late Animation<Offset> _bottomBarSlide;
  final List<IconData> _icons = [
    Icons.search_rounded,
    Icons.chat_bubble_rounded,
    Icons.home_rounded,
    Icons.favorite_rounded,
    Icons.person_2_rounded,
  ];
  final List<Widget> _pages = [
    MapPage(),
    Container(
      color: Palette.primary,
    ),
    HomeView(),
    Container(
      color: Palette.primaryDark,
    ),
    Container(
      color: Palette.grey,
    ),
  ];
  @override
  void initState() {
    super.initState();
    _pageFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _bottomBarSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pageFade =
        Tween<double>(begin: 1.0, end: 0.0).animate(_pageFadeController);
    _bottomBarSlide = Tween<Offset>(begin: Offset(0, 100), end: Offset(0, -20))
        .animate(_bottomBarSlideController);
    Future.microtask(() => animateBottomBar());
  }

  Future<void> animateBottomBar() async {
    await Future.delayed(const Duration(milliseconds: 7300));
    _bottomBarSlideController.forward();
  }

  @override
  void dispose() {
    _pageFadeController.dispose();
    _bottomBarSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.bottomCenter, children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _pages[_selectedPage],
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
        AnimatedBuilder(
            animation: _bottomBarSlide,
            builder: (context, child) {
              return Transform.translate(
                offset: _bottomBarSlide.value,
                child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 7.h,
                    ),
                    decoration: BoxDecoration(
                      color: Palette.black,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (index) {
                          return BottomNavigationItem(
                            iconData: _icons[index],
                            isSelected: _selectedPage == index,
                            fadeController: _pageFadeController,
                            fadeAnimation: _pageFade,
                            onTap: () async {
                              if (_selectedPage != index) {
                                await _pageFadeController.forward();
                              }
                              setState(() {
                                _selectedPage = index;
                              });
                              _pageFadeController.reverse();
                            },
                          );
                        }))),
              );
            }),
      ]),
    );
  }
}

class BottomNavigationItem extends StatelessWidget {
  const BottomNavigationItem({
    super.key,
    required this.iconData,
    required this.onTap,
    required this.fadeController,
    required this.fadeAnimation,
    this.isSelected = false,
  });
  final IconData iconData;
  final bool isSelected;
  final Function() onTap;
  final AnimationController fadeController;
  final Animation<double> fadeAnimation;

  @override
  Widget build(BuildContext context) {
    return CustomIconButtonWithSplashEffect(
      onTap: onTap,
      outerWidthAndHeight: 50.h,
      innerWidthAndHeight: 20.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          FadeTransition(
            opacity: fadeAnimation,
            child: Container(
              height: 40.h,
              width: 40.h,
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Palette.primary : null,
              ),
            ),
          ),
          Icon(
            iconData,
            size: 22.sp,
            color: Palette.white,
          ),
        ],
      ),
    );
  }
}
