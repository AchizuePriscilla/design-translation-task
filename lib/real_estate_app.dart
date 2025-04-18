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

class _RealEstateAppState extends State<RealEstateApp> {
  int _selectedPage = 2;
  final PageController _pageController = PageController(initialPage: 2);
  final List<IconData> _icons = [
    Icons.search_rounded,
    Icons.chat_bubble_rounded,
    Icons.home_rounded,
    Icons.favorite_rounded,
    Icons.person_2_rounded,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.bottomCenter, children: [
        PageView(
          controller: _pageController,
          children: [
            MapPage(),
            SizedBox(),
            HomeView(),
            SizedBox(),
            SizedBox(),
          ],
        ),
        Positioned(
          bottom: 30.h,
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
                  children: List.generate(5, (index) {
                return BottomNavigationItem(
                  iconData: _icons[index],
                  isSelected: _selectedPage == index,
                  onTap: () {
                    setState(() {
                      _selectedPage = index;
                    });
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                );
              }))),
        ),
      ]),
    );
  }
}

class BottomNavigationItem extends StatelessWidget {
  const BottomNavigationItem({
    super.key,
    required this.iconData,
    required this.onTap,
    this.isSelected = false,
  });
  final IconData iconData;
  final bool isSelected;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40.h,
        width: 40.h,
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Palette.primary : null,
        ),
        child: Icon(
          iconData,
          size: 22.sp,
          color: Palette.white,
        ),
      ),
    );
  }
}
