import 'dart:ui';

import 'package:design_task/utils/custom_spacer.dart';
import 'package:design_task/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xffF8F8F8),
            Color(0xffF8F8F8),
            Color(0xffFADDBC),
            Color(0xffF8F8F8),
          ],
          stops: [0.0, 0.2, 0.5, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSpacer(
                  flex: 15,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 40.h,
                      child: SearchTextField(),
                    ),
                    const Spacer(),
                    Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Palette.primaryDark,
                            Palette.primary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/me.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  ],
                ),
                CustomSpacer(
                  flex: 7,
                ),
                Text(
                  "Hi, Priscilla",
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: Palette.grey,
                  ),
                ),
                Text(
                  "let's select your perfect place",
                  style: TextStyle(
                    fontSize: 33.sp,
                  ),
                ),
                CustomSpacer(
                  flex: 7,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.43,
                      height: MediaQuery.of(context).size.width * 0.43,
                      decoration: BoxDecoration(
                        color: Palette.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: OffersColumn(
                          title: "BUY",
                          numberOfOffers: "1034",
                          textColor: Palette.white,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.43,
                      height: MediaQuery.of(context).size.width * 0.43,
                      decoration: BoxDecoration(
                          color: Palette.white,
                          borderRadius: BorderRadius.circular(30.r)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: OffersColumn(
                          title: "RENT",
                          numberOfOffers: "1034",
                          textColor: Palette.grey,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          DraggableScrollableSheet(
              initialChildSize: 0.67,
              minChildSize: 0.37,
              maxChildSize: 0.67,
              expand: false,
              shouldCloseOnMinExtent: false,
              builder: (context, controller) {
                return SingleChildScrollView(
                  controller: controller,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.67,
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Palette.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r),
                      ),
                    ),
                    child: Column(
                      children: [
                        HouseImageContainer(
                          imagePath: "one",
                          isFirstImage: true,
                          address: "Gladkova St., 25",
                        ),
                        CustomSpacer(
                          flex: 3,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              HouseImageContainer(
                                  imagePath: "two", address: "Gubina St., 11"),
                              CustomSpacer(
                                horizontal: true,
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    HouseImageContainer(
                                        imagePath: "three",
                                        address: "Trefoleva St., 43"),
                                    CustomSpacer(),
                                    HouseImageContainer(
                                        imagePath: "four",
                                        address: "Sedova St., 22"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        CustomSpacer(
                          flex: 3,
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class HouseImageContainer extends StatelessWidget {
  const HouseImageContainer({
    super.key,
    this.isFirstImage = false,
    required this.imagePath,
    required this.address,
  });
  final String imagePath;
  final String address;
  final bool isFirstImage;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isFirstImage ? 30.r : 15.r),
              image: DecorationImage(
                image: AssetImage('assets/images/house_$imagePath.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: !isFirstImage ? 7.h : 10.h,
            left: 10.w,
            right: 10.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.r),
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(8.w, 3.h, 2.w, 3.h),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Palette.white.withValues(alpha: .5),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                      child: Stack(
                        alignment: isFirstImage
                            ? Alignment.center
                            : Alignment.centerLeft,
                        children: [
                          Text(
                            address,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: !isFirstImage ? 30.w : 40.w,
                              height: !isFirstImage ? 30.w : 40.h,
                              decoration: BoxDecoration(
                                color: Palette.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 15.sp,
                                color: Palette.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OffersColumn extends StatelessWidget {
  const OffersColumn({
    super.key,
    required this.title,
    required this.numberOfOffers,
    required this.textColor,
  });
  final String title;
  final String numberOfOffers;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(color: textColor, fontSize: 14.sp),
        ),
        const Spacer(),
        Text(
          numberOfOffers,
          style: TextStyle(
            fontSize: 35.sp,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        Text(
          "offers",
          style: TextStyle(
            fontSize: 13.sp,
            color: textColor,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlignVertical: TextAlignVertical(y: 0.5),
      style: TextStyle(
        fontSize: 14.sp,
        color: Palette.grey,
      ),
      decoration: InputDecoration(
        hintText: 'Search',
        enabled: false,
        prefixIcon: Icon(
          Icons.location_on_rounded,
          color: Palette.grey,
        ),
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: Palette.grey,
        ),
        filled: true,
        fillColor: Palette.white,
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: Palette.white,
          ),
        ),
      ),
    );
  }
}
