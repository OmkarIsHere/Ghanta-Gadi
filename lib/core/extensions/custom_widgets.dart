

import 'package:flutter/material.dart';

extension CustomWidget on Widget {

  Widget center({
    double? widthFactor,
    double? heightFactor,
  }) =>
      Center(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        child: this,
      );

  Widget card({
    Color? color,
    double elevation= 0,
    ShapeBorder? shape,
    bool borderOnForeground = true,
    EdgeInsetsGeometry? margin,
    Clip? clipBehavior,
    bool semanticContainer = true,
  }) =>
      Card(
        color: color,
        elevation: elevation,
        shape: shape,
        borderOnForeground: borderOnForeground,
        margin: margin,
        clipBehavior: clipBehavior,
        semanticContainer: semanticContainer,
        child: this,
      );

  Widget safeArea() => SafeArea(child: this);

  Widget inkWell({GestureTapCallback? onTap, GestureLongPressCallback? onLongPress}) => InkWell(
    onLongPress: onLongPress,
    highlightColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
    onTap: onTap,child: this,);

  Widget onLongPressTap({GestureLongPressCallback? onLongPress}) => InkWell(onLongPress: onLongPress,child: this,);


  Widget expanded({
    int flex = 1,
  }) =>
      Expanded(
        flex: flex,
        child: this,
      );

  Widget flexible({
    int flex = 1,
    FlexFit fit = FlexFit.loose,
  }) =>
      Flexible(
        flex: flex,
        fit: fit,
        child: this,
      );

  Widget positioned({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
  }) =>
      Positioned(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
        width: width,
        height: height,
        child: this,
      );

  Widget singleChildScrollView({
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    bool? primary,
    ScrollPhysics? physics,
    ScrollController? controller,
  }) =>
      SingleChildScrollView(
        scrollDirection: scrollDirection,
        reverse: reverse,
        primary: primary,
        physics: physics,
        controller: controller,
        child: this,
      );

  Widget clipRRect({
    double? all,
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
    CustomClipper<RRect>? clipper,
    Clip clipBehavior = Clip.antiAlias,
    bool animate = false,
  }) =>
      ClipRRect(
        clipper: clipper,
        clipBehavior: clipBehavior,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeft ?? all ?? 0.0),
          topRight: Radius.circular(topRight ?? all ?? 0.0),
          bottomLeft: Radius.circular(bottomLeft ?? all ?? 0.0),
          bottomRight: Radius.circular(bottomRight ?? all ?? 0.0),
        ),
        child: this,
      );

  Widget alignment(
      AlignmentGeometry alignment, {
        bool animate = false,
      }) =>
      Align(
        alignment: alignment,
        child: this,
      );

}