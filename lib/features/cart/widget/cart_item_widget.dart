import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:e_commerce_app/features/cart/models/cart_model.dart';
import 'package:e_commerce_app/features/home_screen/model/Prodacts_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

class CartItemWidget extends StatelessWidget {
  final Product product;
  final List<ProdactsModel> allProducts;
  final int quantity;
  final Function() onAdd;
  final Function() onRemove;
  final Function() onDelete;

  const CartItemWidget({
    super.key,
    required this.product,
    required this.allProducts,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
    required this.onDelete,
  });

  String getImage() {
    for (int i = 0; i < allProducts.length; i++) {
      if (allProducts[i].id == product.id) {
        if (allProducts[i].thumbnail != null &&
            allProducts[i].thumbnail != "") {
          return allProducts[i].thumbnail!;
        }
        if (allProducts[i].images != null &&
            allProducts[i].images!.isNotEmpty) {
          return allProducts[i].images![0];
        }
      }
    }
    return product.thumbnail ?? "";
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = getImage();

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.5),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 83.w,
              height: 79.h,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.grey[300],
              ),
              child: imageUrl != ""
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, color: Colors.grey),
                    )
                  : const Icon(Icons.image, color: Colors.grey),
            ),
            WidthSpace(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.title ?? "",
                          style: AppStyles.black15BoldStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        onTap: onDelete,
                        child: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                  const HeightSpace(30),
                  Row(
                    children: [
                      Text(
                        "${product.price ?? 0} \$",
                        style: AppStyles.black15BoldStyle,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          InkWell(
                            onTap: onAdd,
                            child: Container(
                              width: 24.w,
                              height: 24.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(Icons.add, size: 16.sp),
                            ),
                          ),
                          WidthSpace(8),
                          Text("$quantity", style: AppStyles.black15BoldStyle),
                          WidthSpace(8),
                          InkWell(
                            onTap: onRemove,
                            child: Container(
                              width: 24.w,
                              height: 24.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(Icons.remove, size: 16.sp),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
