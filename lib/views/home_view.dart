import 'dart:ui';
import 'package:design_task/utils/custom_spacer.dart';
import 'package:design_task/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icons_plus/icons_plus.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late final HomeViewAnimations _homeViewAnimations;
  final DraggableScrollableController _draggableScrollableController =
      DraggableScrollableController();
  @override
  void initState() {
    super.initState();
    _homeViewAnimations = HomeViewAnimations(this);

    Future.microtask(() => _animateElements());
  }

  double _bottomSheetMinHeight = 0;
  Future<void> _animateElements() async {
    await Future.delayed(Duration(milliseconds: 500));
    if (mounted) {
      await _homeViewAnimations.searchRowController.forward();
      await Future.delayed(Duration(milliseconds: 100));
      if (mounted) {
        await _homeViewAnimations.nameTextFadeController.forward();
        await _homeViewAnimations.textFadeController.forward();
        _homeViewAnimations.offersRowController.forward();
        await _homeViewAnimations.numberOfOffersController.forward();
        await _draggableScrollableController
            .animateTo(
          0.66,
          duration: const Duration(milliseconds: 600),
          curve: Curves.fastOutSlowIn,
        )
            .then((value) {
          setState(() {
            _bottomSheetMinHeight = 0.3;
          });
        });
      }
    }
  }

  @override
  void dispose() {
    _homeViewAnimations.dispose();
    super.dispose();
  }

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
          stops: [0.0, 0.3, 0.5, 1.0],
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
                SearchRow(homeViewAnimations: _homeViewAnimations),
                CustomSpacer(
                  flex: 9,
                ),
                FadeTransition(
                  opacity: _homeViewAnimations.nameTextFade,
                  child: Text(
                    "Hi, Priscilla",
                    style: TextStyle(
                      fontSize: 23.sp,
                      color: Palette.grey,
                    ),
                  ),
                ),
                ClipRRect(
                  child: AnimatedBuilder(
                    animation: _homeViewAnimations.textFade,
                    builder: (context, child) {
                      return Align(
                        alignment: Alignment.topCenter,
                        heightFactor: _homeViewAnimations.textFade.value,
                        child: Text(
                          "let's select your perfect place",
                          style: TextStyle(
                            fontSize: 33.sp,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                CustomSpacer(
                  flex: 7,
                ),
                OffersRow(homeViewAnimations: _homeViewAnimations)
              ],
            ),
          ),
          BottomSheet(
              bottomSheetMinHeight: _bottomSheetMinHeight,
              draggableScrollableController: _draggableScrollableController,
              homeViewAnimations: _homeViewAnimations),
        ],
      ),
    );
  }
}

class BottomSheet extends StatelessWidget {
  const BottomSheet({
    super.key,
    required double bottomSheetMinHeight,
    required DraggableScrollableController draggableScrollableController,
    required HomeViewAnimations homeViewAnimations,
  })  : _bottomSheetMinHeight = bottomSheetMinHeight,
        _draggableScrollableController = draggableScrollableController,
        _homeViewAnimations = homeViewAnimations;

  final double _bottomSheetMinHeight;
  final DraggableScrollableController _draggableScrollableController;
  final HomeViewAnimations _homeViewAnimations;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: _bottomSheetMinHeight,
        minChildSize: _bottomSheetMinHeight,
        maxChildSize: 0.66,
        expand: false,
        controller: _draggableScrollableController,
        shouldCloseOnMinExtent: false,
        builder: (context, controller) {
          return SingleChildScrollView(
            controller: controller,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
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
                    animations: _homeViewAnimations,
                    slideAnimationSpeedFactor: 2,
                    scaleAnimationSpeedFactor: .8,
                  ),
                  CustomSpacer(
                    flex: 3,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        HouseImageContainer(
                            imagePath: "two",
                            address: "Gubina St., 11",
                            slideAnimationSpeedFactor: 0.1,
                            scaleAnimationSpeedFactor: 0.1,
                            animations: _homeViewAnimations),
                        CustomSpacer(
                          horizontal: true,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              HouseImageContainer(
                                  imagePath: "three",
                                  address: "Trefoleva St., 43",
                                  slideAnimationSpeedFactor: 0.7,
                                  scaleAnimationSpeedFactor: 0.3,
                                  animations: _homeViewAnimations),
                              CustomSpacer(),
                              HouseImageContainer(
                                  imagePath: "four",
                                  address: "Sedova St., 22",
                                  slideAnimationSpeedFactor: 0.1,
                                  scaleAnimationSpeedFactor: 0.1,
                                  animations: _homeViewAnimations),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class SearchRow extends StatelessWidget {
  const SearchRow({
    super.key,
    required HomeViewAnimations homeViewAnimations,
  }) : _homeViewAnimations = homeViewAnimations;

  final HomeViewAnimations _homeViewAnimations;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SearchTextField(animations: _homeViewAnimations),
        const Spacer(),
        ScaleTransition(
          scale: _homeViewAnimations.searchRow,
          child: Container(
            width: 49.w,
            height: 49.h,
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
          ),
        )
      ],
    );
  }
}

class OffersRow extends StatelessWidget {
  const OffersRow({
    super.key,
    required HomeViewAnimations homeViewAnimations,
  }) : _homeViewAnimations = homeViewAnimations;

  final HomeViewAnimations _homeViewAnimations;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _homeViewAnimations.numberOfOffers,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ScaleTransition(
                scale: _homeViewAnimations.offersRow,
                child: Container(
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
                      numberOfOffers:
                          "${(1034 * _homeViewAnimations.numberOfOffers.value).round()}",
                      textColor: Palette.white,
                    ),
                  ),
                ),
              ),
              ScaleTransition(
                scale: _homeViewAnimations.offersRow,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.43,
                  height: MediaQuery.of(context).size.width * 0.43,
                  decoration: BoxDecoration(
                      color: Palette.white,
                      borderRadius: BorderRadius.circular(30.r)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    child: OffersColumn(
                      title: "RENT",
                      numberOfOffers:
                          "${(2212 * _homeViewAnimations.numberOfOffers.value).round()}",
                      textColor: Palette.grey,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}

class HouseImageContainer extends StatefulWidget {
  const HouseImageContainer(
      {super.key,
      this.isFirstImage = false,
      required this.imagePath,
      required this.address,
      required this.animations,
      required this.slideAnimationSpeedFactor,
      required this.scaleAnimationSpeedFactor});
  final String imagePath;
  final String address;
  final bool isFirstImage;
  final HomeViewAnimations animations;
  final double slideAnimationSpeedFactor;
  final double scaleAnimationSpeedFactor;
  @override
  State<HouseImageContainer> createState() => _HouseImageContainerState();
}

class _HouseImageContainerState extends State<HouseImageContainer>
    with TickerProviderStateMixin {
  late final AnimationController _sliderSizeAndAddressFadeController;
  late final AnimationController _sliderScaleController;
  late final Animation<double> _sliderScale;
  late final Animation<double> _addressFade;
  late final Animation<double> _sliderSize;
  late final double _scaleAnimationEndTime;
  late final double _widthMultiplier;
  @override
  void initState() {
    _scaleAnimationEndTime =
        (0.5 + (1.0 - widget.scaleAnimationSpeedFactor) * 0.5).clamp(0.0, 1.0);
    _widthMultiplier =
        (1 + (widget.slideAnimationSpeedFactor.clamp(0.1, 10.0) - 1) * 0.5);
    _sliderSizeAndAddressFadeController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _sliderScaleController = AnimationController(
        vsync: this,
        duration:
            Duration(milliseconds: (_scaleAnimationEndTime * 1000).toInt()));
    _sliderScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _sliderScaleController,
        curve: Interval(
          0.0,
          _scaleAnimationEndTime,
          curve: Curves.easeOut,
        ),
      ),
    );
    _sliderSize = Tween<double>(begin: .09, end: 1).animate(
      CurvedAnimation(
        parent: _sliderSizeAndAddressFadeController,
        curve: Interval(0.09, 1, curve: Curves.easeOut),
      ),
    );
    _addressFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _sliderSizeAndAddressFadeController,
        curve: Interval(0.5, 1, curve: Curves.easeOut),
      ),
    );
    super.initState();
    Future.microtask(() => animate());
  }

  Future<void> animate() async {
    await Future.delayed(Duration(milliseconds: 4300));
    if (mounted) {
      await _sliderScaleController.forward();
      _sliderSizeAndAddressFadeController.forward();
    }
  }

  @override
  void dispose() {
    _sliderScaleController.dispose();
    _sliderSizeAndAddressFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(widget.isFirstImage ? 32.r : 17.r),
              image: DecorationImage(
                image:
                    AssetImage('assets/images/house_${widget.imagePath}.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          AnimatedBuilder(
              animation: _sliderSize,
              builder: (context, child) {
                return Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
                    child: ScaleTransition(
                      scale: _sliderScale,
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32.r),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                            _sliderSize.value == 0.09 ? 1.h : 8.w,
                            3.h,
                            1.w,
                            3.h,
                          ),
                          width: _sliderSize.value != 0.09
                              ? MediaQuery.of(context).size.width *
                                  (_sliderSize.value * _widthMultiplier)
                              : !widget.isFirstImage
                                  ? 32.w
                                  : 42.w,
                          height: !widget.isFirstImage ? 32.w : 42.h,
                          decoration: BoxDecoration(
                            color: Palette.white.withValues(alpha: .5),
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                            child: Stack(
                              alignment: widget.isFirstImage
                                  ? Alignment.center
                                  : Alignment.centerLeft,
                              children: [
                                if (_sliderSize.value != 0.09)
                                  FadeTransition(
                                    opacity: _addressFade,
                                    child: Text(
                                      widget.address,
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ScaleTransition(
                                  scale: _sliderScale,
                                  child: Align(
                                    alignment: _sliderSize.value == 0.09
                                        ? Alignment.center
                                        : Alignment.centerRight,
                                    child: Container(
                                      width: !widget.isFirstImage ? 30.w : 40.w,
                                      height:
                                          !widget.isFirstImage ? 30.w : 40.h,
                                      decoration: BoxDecoration(
                                        color: Palette.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size:
                                            !widget.isFirstImage ? 8.sp : 11.sp,
                                        color: Palette.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              })
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
  const SearchTextField({super.key, required this.animations});
  final HomeViewAnimations animations;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animations.searchRow,
        builder: (context, child) {
          return SizedBox(
            width: animations.searchRow.value *
                (MediaQuery.of(context).size.width * 0.5),
            height: 45.h,
            child: TextField(
              textAlignVertical: TextAlignVertical(y: 1),
              style: TextStyle(
                fontSize: 14.sp,
                color: Palette.grey,
              ),
              decoration: InputDecoration(
                prefixIcon: FadeTransition(
                  opacity: animations.hintTextFade,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15.w, right: 4.w),
                        child: Icon(
                          MingCute.location_fill,
                          color: Palette.grey,
                          size: 18.sp,
                        ),
                      ),
                      Text(
                        'Saint Petersburg',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Palette.grey,
                        ),
                      )
                    ],
                  ),
                ),
                hintStyle: TextStyle(
                  fontSize: 15.sp,
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
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    color: Palette.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    color: Palette.white,
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class HomeViewAnimations {
  late AnimationController pageFadeController;
  final AnimationController searchRowController;
  final AnimationController nameTextFadeController;
  final AnimationController textFadeController;
  final AnimationController offersRowController;
  final AnimationController numberOfOffersController;

  late final Animation<double> pageFade;
  late final Animation<double> searchRow;
  late final Animation<double> hintTextFade;
  late final Animation<double> nameTextFade;
  late final Animation<double> textFade;
  late final Animation<double> offersRow;
  late final Animation<double> numberOfOffers;
  late final Animation<double> bottomNavBar;

  HomeViewAnimations(TickerProvider vsync)
      : pageFadeController = AnimationController(
            vsync: vsync, duration: Duration(milliseconds: 400)),
        searchRowController =
            AnimationController(vsync: vsync, duration: Duration(seconds: 1)),
        nameTextFadeController = AnimationController(
            vsync: vsync, duration: Duration(milliseconds: 800)),
        textFadeController = AnimationController(
            vsync: vsync, duration: Duration(milliseconds: 800)),
        offersRowController = AnimationController(
            vsync: vsync, duration: Duration(milliseconds: 500)),
        numberOfOffersController =
            AnimationController(vsync: vsync, duration: Duration(seconds: 1)) {
    pageFade = Tween<double>(begin: 1, end: 0).animate(pageFadeController);
    searchRow = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(curve: Curves.easeOut, parent: searchRowController));
    hintTextFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: searchRowController,
        curve: Interval(0.8, 1, curve: Curves.easeOut),
      ),
    );
    nameTextFade =
        Tween<double>(begin: 0, end: 1).animate(nameTextFadeController);
    textFade = Tween<double>(begin: 0, end: 1).animate(textFadeController);
    offersRow = Tween<double>(begin: 0, end: 1).animate(offersRowController);
    numberOfOffers =
        Tween<double>(begin: 0, end: 1).animate(numberOfOffersController);
  }

  void dispose() {
    searchRowController.dispose();
    textFadeController.dispose();
    nameTextFadeController.dispose();
    offersRowController.dispose();
    numberOfOffersController.dispose();
    pageFadeController.dispose();
  }
}
