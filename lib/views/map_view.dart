import 'dart:ui';
import 'package:design_task/utils/custom_icon_button_with_splash_effect.dart';
import 'package:design_task/utils/custom_spacer.dart';
import 'package:design_task/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

final List<LatLng> markerPoints = [
  LatLng(9.037359, 7.477315),
  LatLng(9.048760, 7.480233),
  LatLng(9.050413, 7.472208),
  LatLng(9.039224, 7.474440),
  LatLng(9.048082, 7.498472),
  LatLng(9.059752, 7.478010),
  LatLng(9.044754, 7.484102),
];

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  late final MapViewAnimations animations;

  @override
  void initState() {
    super.initState();
    animations = MapViewAnimations(this);
    Future.microtask(() => _scaleElements());
  }

  Future<void> _scaleElements() async {
    await animations.elementsScaleController.forward();
    await animations.markerScaleController.forward();
    animations.markerTextFadeController.forward();
  }

  List<String> locations = [
    "6,95mn P",
    "7,8mn P",
    "11mn P",
    "13,3mn P",
    "Kaduna",
    "10,3mn P",
    "8,5mn P",
  ];
  @override
  void dispose() {
    animations.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(9.047473, 7.478592),
          initialZoom: 15,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
            subdomains: ['a', 'b', 'c'],
            retinaMode: true,
            userAgentPackageName: 'com.example.app',
          ),
          ValueListenableBuilder(
              valueListenable: animations.markerSize,
              builder: (context, value, child) {
                return MarkerLayer(
                  markers: markerPoints
                      .map((point) => Marker(
                            point: point,
                            width: 70.w * value,
                            height: 50.h,
                            child: ScaleTransition(
                              scale: animations.markerScale,
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                width: 70.w * value,
                                decoration: BoxDecoration(
                                  color: Palette.primary,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12.r),
                                    topRight: Radius.circular(12.r),
                                    bottomRight: Radius.circular(12.r),
                                  ),
                                ),
                                child: value < .8
                                    ? Icon(
                                        Icons.location_city,
                                        color: Palette.white.withValues(
                                            alpha: (1.0 - value) * 2),
                                        size: 20.sp,
                                      )
                                    : value == 1
                                        ? Center(
                                            child: FadeTransition(
                                            opacity: animations.markerTextFade,
                                            child: Text(
                                              locations[
                                                  markerPoints.indexOf(point)],
                                              style: TextStyle(
                                                color: Palette.white.withValues(
                                                    alpha: (value - 0.8) / 0.2),
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ))
                                        : SizedBox.shrink(),
                              ),
                            ),
                          ))
                      .toList(),
                );
              }),
          SearchRow(animations: animations),
          BottomButtons(
            animations: animations,
          ),
          OptionsCard(animations: animations),
        ]);
  }
}

class OptionsCard extends StatelessWidget {
  const OptionsCard({
    super.key,
    required this.animations,
  });

  final MapViewAnimations animations;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 155.h,
        left: 20.w,
        child: GestureDetector(
          onTap: () {
            animations.cardController.reverse();
            animations.markerSizeController.forward();
          },
          child: ScaleTransition(
            scale: animations.cardScaleValue,
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Palette.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardRow(
                    iconData: Icons.beenhere_outlined,
                    title: "Cozy areas",
                  ),
                  CardRow(
                    iconData: Icons.wallet_outlined,
                    color: Palette.primary,
                    title: "Price",
                  ),
                  CardRow(
                    iconData: Icons.location_on,
                    title: "Infrastructure",
                  ),
                  CardRow(
                    iconData: Icons.layers_outlined,
                    title: "Without any layer",
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class BottomButtons extends StatelessWidget {
  const BottomButtons({super.key, required this.animations});

  final MapViewAnimations animations;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 100.h,
        right: 30.w,
        left: 30.w,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children: [
                ScaleTransition(
                  scale: animations.elementsScaleValue,
                  alignment: Alignment.center,
                  child: CustomIconButtonWithSplashEffect(
                    onTap: () {
                      animations.cardController.forward();
                      animations.markerSizeController.reverse();
                    },
                    child: BlurredButtonWidget(),
                  ),
                ),
                CustomSpacer(),
                ScaleTransition(
                    scale: animations.elementsScaleValue,
                    alignment: Alignment.center,
                    child: BlurredButtonWidget())
              ],
            ),
            const Spacer(),
            ScaleTransition(
              scale: animations.elementsScaleValue,
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.r),
                child: Container(
                  height: 50.h,
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                  decoration: BoxDecoration(
                    color: Palette.white.withValues(alpha: .5),
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                      child: Row(
                        children: [
                          Icon(Icons.filter_list,
                              color: Palette.white, size: 20.sp),
                          CustomSpacer(horizontal: true),
                          Text("List of variants",
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Palette.white,
                              )),
                        ],
                      )),
                ),
              ),
            ),
          ],
        ));
  }
}

class SearchRow extends StatelessWidget {
  const SearchRow({
    super.key,
    required this.animations,
  });

  final MapViewAnimations animations;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60.h,
      left: 20.w,
      right: 20.w,
      child: Row(
        children: [
          Expanded(
              child: ScaleTransition(
            scale: animations.elementsScaleValue,
            alignment: Alignment.center,
            child: TextField(
              style: TextStyle(
                fontSize: 14.sp,
                color: Palette.black,
              ),
              decoration: InputDecoration(
                hintText: 'Abuja, Nigeria',
                enabled: false,
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Palette.black,
                ),
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: Palette.black,
                ),
                filled: true,
                fillColor: Palette.white,
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide(
                    color: Palette.white,
                  ),
                ),
              ),
            ),
          )),
          CustomSpacer(horizontal: true),
          ScaleTransition(
            scale: animations.elementsScaleValue,
            alignment: Alignment.center,
            child: Container(
              width: 50.h,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.filter_list, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class BlurredButtonWidget extends StatelessWidget {
  const BlurredButtonWidget({
    super.key,
    this.child,
  });
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30.r),
      child: Container(
        width: 50.h,
        height: 50.h,
        decoration: BoxDecoration(
            color: Palette.white.withValues(alpha: .7), shape: BoxShape.circle),
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Icon(Icons.filter_list, size: 20.sp, color: Palette.white)),
      ),
    );
  }
}

class CardRow extends StatelessWidget {
  const CardRow({
    super.key,
    required this.title,
    required this.iconData,
    this.color = Palette.grey,
  });
  final String title;
  final IconData iconData;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.h),
      child: Row(
        children: [
          Icon(
            iconData,
            color: color,
            size: 18.sp,
          ),
          const CustomSpacer(
            horizontal: true,
          ),
          Text(
            title,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}

class MapViewAnimations {
  final AnimationController markerScaleController;
  final AnimationController markerSizeController;
  final AnimationController markerTextFadeController;
  final AnimationController cardController;
  final AnimationController elementsScaleController;

  late final Animation<double> cardScaleValue;
  late final Animation<double> elementsScaleValue;
  late final Animation<double> markerScale;
  late final Animation<double> markerSize;
  late final Animation<double> markerTextFade;

  MapViewAnimations(TickerProvider vsync)
      : markerScaleController = AnimationController(
            vsync: vsync, duration: Duration(milliseconds: 500)),
        markerSizeController = AnimationController(
            vsync: vsync, duration: Duration(milliseconds: 500)),
        markerTextFadeController = AnimationController(
            vsync: vsync, duration: Duration(milliseconds: 500)),
        cardController = AnimationController(
            vsync: vsync, duration: Duration(milliseconds: 500)),
        elementsScaleController =
            AnimationController(vsync: vsync, duration: Duration(seconds: 1)) {
    markerScale =
        Tween<double>(begin: 0, end: 1).animate(markerScaleController);
    markerSize =
        Tween<double>(begin: 1, end: 0.5).animate(markerSizeController);
    markerTextFade =
        Tween<double>(begin: 0, end: 1).animate(markerTextFadeController);
    cardScaleValue = Tween<double>(begin: 0, end: 1).animate(cardController);
    elementsScaleValue =
        Tween<double>(begin: 0, end: 1).animate(elementsScaleController);
  }

  void dispose() {
    markerScaleController.dispose();
    markerSizeController.dispose();
    markerTextFadeController.dispose();
    cardController.dispose();
    elementsScaleController.dispose();
  }
}
