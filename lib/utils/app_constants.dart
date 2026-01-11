import 'package:flutter/cupertino.dart';

class AppConstants{
  static const double cardRadius = 20.0;
  static const double spacing = 16.0;

  static double getProgressSize(BuildContext context){
    final width = MediaQuery.sizeOf(context).width;
    if (width < 360) return 100.0;
    if (width < 414) return 110.0;
    return 120.0;
  }

  static double getCategoryTitleSize(BuildContext context){
    return getProgressSize(context) * 0.25;
  }
}