import 'package:e_commerce_app/core/widgets/primay_button_widget.dart';

import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';

import 'package:e_commerce_app/features/cart/cubit/cart_cubit.dart';

import 'package:e_commerce_app/features/cart/cubit/cart_state.dart';

import 'package:e_commerce_app/features/cart/widget/cart_item_widget.dart';

import 'package:e_commerce_app/features/home_screen/widgets/title_price_widget.dart';

import 'package:material_ui/material_ui.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shimmer/shimmer.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),

        centerTitle: true,

        backgroundColor: Colors.white,

        leading: Container(),
      ),

      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartsLodingState) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),

              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const HeightSpace(20),

                    // شيمر وهمي لمنتجين أو تلاتة جوه السلة أثناء التحميل
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,

                      highlightColor: Colors.grey[100]!,

                      child: Container(
                        margin: EdgeInsets.only(bottom: 16.h),

                        height: 100.h,

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                    ),

                    const HeightSpace(20),

                    // شيمر للـ Sub Total والأسعار
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,

                      highlightColor: Colors.grey[100]!,

                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,

                            height: 20.h,

                            color: Colors.white,
                          ),

                          SizedBox(height: 12.h),

                          Container(
                            width: double.infinity,

                            height: 20.h,

                            color: Colors.white,
                          ),

                          SizedBox(height: 12.h),

                          Container(
                            width: double.infinity,

                            height: 20.h,

                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),

                    const HeightSpace(20),

                    const Divider(),

                    const HeightSpace(20),

                    // شيمر للـ Total النهائي
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,

                      highlightColor: Colors.grey[100]!,

                      child: Container(
                        width: double.infinity,

                        height: 24.h,

                        color: Colors.white,
                      ),
                    ),

                    const HeightSpace(20),

                    // شيمر لزرار الـ Checkout
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,

                      highlightColor: Colors.grey[100]!,

                      child: Container(
                        width: double.infinity,

                        height: 50.h,

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),

                    const HeightSpace(20),
                  ],
                ),
              ),
            );
          }

          if (state is CartssucessState) {
            final cart = state.cart..products;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),

              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const HeightSpace(20),
                    ...cart.products!.map((p) {
                      return CartItemWidget(product: p);

                      // ignore: unnecessary_to_list_in_spreads
                    }).toList(),

                    const HeightSpace(20),

                    // ربط الـ Sub Total بالبيانات الحقيقية (total)
                    TitlePriceWidget(
                      title: "Sub Total",

                      price: "${cart.total} \$",
                    ),

                    // ربط الـ VAT (مثلاً استخدام discountedTotal أو ثابته حسب رغبتك)
                    TitlePriceWidget(
                      title: "VAT (16 %)",

                      price: "${cart.discountedTotal ?? 0} \$",
                    ),

                    // رسوم الشحن (ممكن تخليها ثابتة أو من الـ Model لو موجودة)
                    const TitlePriceWidget(
                      title: "Shipping Fees",

                      price: "0 \$",
                    ),

                    const HeightSpace(20),

                    const Divider(),

                    const HeightSpace(20),

                    // ربط الـ Total النهائي بالسعر الإجمالي الحقيقي
                    TotalPriceWidget(
                      title: "Total",

                      price: "${cart.total ?? 0} \$",
                    ),

                    const HeightSpace(20),

                    PrimayButtonWidget(
                      buttonText: "Go To Checkout",

                      trailingIcon: Icon(
                        Icons.payment,

                        color: Colors.white,

                        size: 16.sp,
                      ),

                      onPress: () {},
                    ),

                    const HeightSpace(20),
                  ],
                ),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
