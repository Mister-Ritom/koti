import 'package:flutter/material.dart';

class KotiRadii {
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double xlarge = 32.0; 
  static const double xxlarge = 40.0;
  
  static const BorderRadius roundedSmall = BorderRadius.all(Radius.circular(small));
  static const BorderRadius roundedMedium = BorderRadius.all(Radius.circular(medium));
  static const BorderRadius roundedLarge = BorderRadius.all(Radius.circular(large));
  static const BorderRadius roundedXLarge = BorderRadius.all(Radius.circular(xlarge));
  static const BorderRadius roundedXXLarge = BorderRadius.all(Radius.circular(xxlarge));
  
  static const BorderRadius bottomSheet = BorderRadius.only(
    topLeft: Radius.circular(xxlarge),
    topRight: Radius.circular(xxlarge),
  );
}
