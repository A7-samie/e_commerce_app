import 'package:e_commerce_app/core/widgets/primay_button_widget.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:e_commerce_app/features/cart/cubit/cart_cubit.dart';
import 'package:e_commerce_app/features/cart/cubit/cart_state.dart';
import 'package:e_commerce_app/features/cart/models/cart_model.dart';
import 'package:e_commerce_app/features/cart/widget/cart_item_widget.dart';
import 'package:e_commerce_app/features/home_screen/model/Prodacts_model.dart';
import 'package:e_commerce_app/features/home_screen/widgets/title_price_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shimmer/shimmer.dart';

class CartScreen extends StatefulWidget {
  final List<ProdactsModel> allProducts;

  const CartScreen({super.key, this.allProducts = const []});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Product> products = [];
  List<int> quantities = [];
  bool isLoaded = false;

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
            final cubit = context.read<CartCubit>();

            if (!isLoaded) {
              products = List.from(state.cart.products ?? []);
              quantities = [];
              for (int i = 0; i < products.length; i++) {
                quantities.add(products[i].quantity ?? 1);
              }
              isLoaded = true;
            }

            double subTotal = 0;
            for (int i = 0; i < products.length; i++) {
              double price = products[i].price ?? 0;
              int qty = quantities[i];
              subTotal = subTotal + (price * qty);
            }

            double vat = subTotal * 0.16;
            double shipping = 0;
            double total = subTotal + vat + shipping;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeightSpace(20),
                    if (products.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Text('Cart is empty'),
                        ),
                      )
                    else
                      for (int i = 0; i < products.length; i++)
                        CartItemWidget(
                          product: products[i],
                          allProducts: widget.allProducts,
                          quantity: quantities[i],
                          onAdd: () {
                            setState(() {
                              quantities[i] = quantities[i] + 1;
                            });
                          },
                          onRemove: () {
                            if (quantities[i] > 0) {
                              setState(() {
                                quantities[i] = quantities[i] - 1;
                              });
                            }
                          },
                          onDelete: () {
                            final itemToDelete = products[i];
                            setState(() {
                              products.removeAt(i);
                              quantities.removeAt(i);
                            });
                            cubit.deleteProduct(itemToDelete, products);
                          },
                        ),
                    const HeightSpace(20),
                    TitlePriceWidget(
                      title: "Sub Total",
                      price: "${subTotal.toStringAsFixed(2)} \$",
                    ),
                    TitlePriceWidget(
                      title: "VAT (16 %)",
                      price: "${vat.toStringAsFixed(2)} \$",
                    ),
                    const TitlePriceWidget(
                      title: "Shipping Fees",
                      price: "0 \$",
                    ),
                    const HeightSpace(20),
                    const Divider(),
                    const HeightSpace(20),
                    TotalPriceWidget(
                      title: "Total",
                      price: "${total.toStringAsFixed(2)} \$",
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
