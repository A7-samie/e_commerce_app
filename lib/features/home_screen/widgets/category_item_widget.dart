import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryItemWidget extends StatelessWidget {
  final String categoryName;
  final VoidCallback? ontap;
  // ignore: non_constant_identifier_names
  final bool IsSelected;
  const CategoryItemWidget({
    super.key,
    this.ontap,
    required this.categoryName,
    this.IsSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 8.w),
      child: InkWell(
        onTap: ontap ?? () {},
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 7.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: IsSelected ? AppColors.primaryColor : AppColors.whiteColor,
            border: IsSelected
                ? null
                : Border.all(color: Colors.grey, width: 0.5),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            categoryName,
            style: AppStyles.black15BoldStyle.copyWith(
              color: IsSelected ? AppColors.whiteColor : AppColors.blackColor,
            ),
          ),
        ),
      ),
    );
  }
}
