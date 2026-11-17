import 'package:e_commerce_app/core/styling/app_assets.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class LodingWidgwt extends StatelessWidget {
  final double? width;
  final double? height;

   // ignore: prefer_const_constructors_in_immutables
   LodingWidgwt( {super.key,this.width, this.height,});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width ?? MediaQuery.of(context).size.width,
    // height: height?? MediaQuery.of(context).size.width ,
    child: Center(
      child: LottieBuilder.asset(AppAssets.lottieloding,width:400.w ,height:400.h ,)
    ),
    
     );
  }
}