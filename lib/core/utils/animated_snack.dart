import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:material_ui/material_ui.dart';


// ignore: strict_top_level_inference
showAnimatedSnackDialog(
    BuildContext context,
  {
  required String? message,
  required AnimatedSnackBarType? type,
}){
  AnimatedSnackBar.material(
    message ?? "",
    type:type ?? AnimatedSnackBarType.info,
    mobileSnackBarPosition: MobileSnackBarPosition.bottom, // Position of snackbar on mobile devices
    desktopSnackBarPosition: DesktopSnackBarPosition.topRight, // Position of snackbar on desktop devices
).show(context);
}