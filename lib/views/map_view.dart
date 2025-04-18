import 'dart:ui';

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

class _MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  late AnimationController _cardController;
  late Animation<double> _cardScaleValue;
  @override
  void initState() {
    super.initState();
    _cardController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _cardScaleValue = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _cardController.dispose();
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
          MarkerLayer(
            markers: markerPoints
                .map((point) => Marker(
                      point: point,
                      width: 50.w,
                      height: 50.h,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Palette.primary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.r),
                            topRight: Radius.circular(12.r),
                            bottomRight: Radius.circular(12.r),
                          ),
                        ),
                        child: Icon(
                          Icons.location_city,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ))
                .toList(),
          ),
          Positioned(
            top: 60.h,
            left: 20.w,
            right: 20.w,
            child: Row(
              children: [
                Expanded(
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
                )),
                CustomSpacer(horizontal: true),
                Container(
                  width: 50.h,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.filter_list, color: Colors.black),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 100.h,
              right: 30.w,
              left: 30.w,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          _cardController.forward();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.r),
                          child: Container(
                            width: 50.h,
                            height: 50.h,
                            decoration: BoxDecoration(
                                color: Palette.white.withValues(alpha: .7),
                                shape: BoxShape.circle),
                            child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                                child: Icon(Icons.filter_list,
                                    size: 20.sp, color: Palette.white)),
                          ),
                        ),
                      ),
                      CustomSpacer(),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30.r),
                        child: Container(
                          width: 50.h,
                          height: 50.h,
                          decoration: BoxDecoration(
                              color: Palette.white.withValues(alpha: .7),
                              shape: BoxShape.circle),
                          child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                              child: Icon(Icons.filter_list,
                                  size: 20.sp, color: Palette.white)),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.r),
                    child: Container(
                      height: 50.h,
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 15.w),
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
                ],
              )),
          AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
              bottom: 155.h,
              left: 20.w,
              child: GestureDetector(
                onTap: () {
                  _cardController.reverse();
                },
                child: AnimatedBuilder(
                  animation: _cardController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _cardScaleValue.value,
                      alignment: Alignment.bottomLeft,
                      child: child,
                    );
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
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
              )),
        ]);
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
