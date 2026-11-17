import 'package:animated_snack_bar/animated_snack_bar.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:e_commerce_app/core/styling/app_styles.dart';

import 'package:e_commerce_app/core/utils/animated_snack.dart';

import 'package:e_commerce_app/core/widgets/primay_button_widget.dart';

import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';

import 'package:e_commerce_app/features/cart/cubit/cart_cubit.dart';

import 'package:e_commerce_app/features/cart/cubit/cart_state.dart';

import 'package:e_commerce_app/features/home_screen/model/Prodacts_model.dart';

import 'package:material_ui/material_ui.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductScreen extends StatefulWidget {
  final ProdactsModel product;

  const ProductScreen({super.key, required this.product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),

        centerTitle: true,

        backgroundColor: Colors.white,
      ),

      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),

            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  HeightSpace(20),

                  Container(
                    width: 341.w,

                    height: 341.h,

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(8.r),
                    ),

                    child: Hero(
                      tag: "product${product.title}",

                      child: CachedNetworkImage(imageUrl: product.images![0]),
                    ),
                  ),

                  const HeightSpace(12),

                  Text(
                    product.title.toString(),

                    style: AppStyles.black16w500Style.copyWith(fontSize: 24.sp),
                  ),

                  const HeightSpace(8),

                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 18.sp),

                      const WidthSpace(2),

                      product.rating != null
                          ? Text(
                              product.rating.toString(),

                              style: AppStyles.black15BoldStyle.copyWith(
                                decoration: TextDecoration.underline,
                              ),
                            )
                          : SizedBox.shrink(),

                      const WidthSpace(2),

                      product.reviews != null
                          ? Text(
                              " ${product.reviews!.length} Reviews",

                              style: AppStyles.grey12MediumStyle.copyWith(
                                fontWeight: FontWeight.bold,

                                fontSize: 15.sp,
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),

                  const HeightSpace(8),

                  Text(
                    "${product.description}",

                    style: AppStyles.grey12MediumStyle.copyWith(
                      fontSize: 16.sp,

                      fontWeight: FontWeight.normal,
                    ),
                  ),

                  const HeightSpace(150),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 0,

            child: Container(
              color: Colors.white,

              padding: EdgeInsets.symmetric(horizontal: 24.w),

              width: MediaQuery.of(context).size.width,

              child: Column(
                children: [
                  Divider(),

                  HeightSpace(10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "Price",

                            style: AppStyles.grey12MediumStyle.copyWith(
                              fontSize: 16.sp,
                            ),
                          ),

                          HeightSpace(4),

                          Text(
                            "${product.price} \$",

                            style: AppStyles.black16w500Style.copyWith(
                              fontSize: 24.sp,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const WidthSpace(16),

                      BlocConsumer<CartCubit, CartState>(
                        listener: (context, state) {
                          if (state is AddCartssucessState) {
                            showAnimatedSnackDialog(
                              context,

                              message: "Product Added successfuiiy To Our Cart",

                              type: AnimatedSnackBarType.success,
                            );
                          }
                        },

                        builder: (context, state) {
                          if (state is AddingToCartState) {
                            return PrimayButtonWidget(
                              isLoding: true,

                              width: MediaQuery.of(context).size.width * 0.5,

                              buttonText: "Add To Cart",

                              onPress: () {},
                            );
                          }

                          return PrimayButtonWidget(
                            width: MediaQuery.of(context).size.width * 0.5,

                            buttonText: "Add To Cart",

                            icon: Icon(
                              Icons.shopping_cart,

                              color: Colors.white,

                              size: 16.sp,
                            ),

                            onPress: () {
                              context.read<CartCubit>().addCarts(
                                product: product,

                                quantity: 1,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),

                  const HeightSpace(8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
