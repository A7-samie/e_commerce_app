import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductItemWidget extends StatelessWidget {
  final String title;
  final String price;
  final List<String>? src;
  final Function()? onTap;
  const ProductItemWidget({
    super.key,
    required this.title,
    required this.price,
    this.onTap,
    required this.src,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              width: 150.w,
              height: 150.h,
              color: Colors.white,
              child: Hero(
                tag: "product$title",
                child: CachedNetworkImage(
                  imageUrl: (src != null && src!.isNotEmpty) ? src![0] : "",
                  fit: BoxFit.cover,
                  errorWidget: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.error, color: Colors.red)),
                ),
              ),
            ),
          ),
          const HeightSpace(8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.black15BoldStyle,
          ),
          const HeightSpace(8),
          Text(
            price,
            style: AppStyles.grey12MediumStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
