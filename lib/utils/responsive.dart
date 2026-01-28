import 'package:flutter/material.dart';

enum ScreenSize { mobile, tablet, desktop }

class Responsive {
  static const double _mobileMaxWidth = 600;
  static const double _tabletMaxWidth = 1024;

  static ScreenSize screenSizeOf(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w <= _mobileMaxWidth) return ScreenSize.mobile;
    if (w <= _tabletMaxWidth) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }

  static bool isMobile(BuildContext context) =>
      screenSizeOf(context) == ScreenSize.mobile;
  static bool isTablet(BuildContext context) =>
      screenSizeOf(context) == ScreenSize.tablet;
  static bool isDesktop(BuildContext context) =>
      screenSizeOf(context) == ScreenSize.desktop;

  /// Page-level padding that scales across breakpoints
  static EdgeInsets pagePadding(BuildContext context) {
    switch (screenSizeOf(context)) {
      case ScreenSize.mobile:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case ScreenSize.tablet:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
      case ScreenSize.desktop:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 20);
    }
  }

  /// Max content width to keep long lines readable on large screens
  static double contentMaxWidth(BuildContext context) {
    switch (screenSizeOf(context)) {
      case ScreenSize.mobile:
        return double.infinity;
      case ScreenSize.tablet:
        return 720; // medium column width
      case ScreenSize.desktop:
        return 960; // comfortable reading width
    }
  }

  /// Helper to pick values per breakpoint
  static T value<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    switch (screenSizeOf(context)) {
      case ScreenSize.mobile:
        return mobile;
      case ScreenSize.tablet:
        return tablet ?? mobile;
      case ScreenSize.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }
}
