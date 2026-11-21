// ignore_for_file: unused_import

import 'package:e_commerce_app/core/routing/app_routes.dart';
import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/utils/service_locator.dart';
import 'package:e_commerce_app/core/utils/storage_helper.dart';
import 'package:e_commerce_app/core/widgets/custom_text_field.dart';
import 'package:e_commerce_app/core/widgets/loding_widgwt.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:e_commerce_app/features/home_screen/Cubit/categories_cubit.dart';
import 'package:e_commerce_app/features/home_screen/Cubit/categories_state.dart';
import 'package:e_commerce_app/features/home_screen/Cubit/prodacts_cubit.dart';
import 'package:e_commerce_app/features/home_screen/Cubit/prodacts_state.dart';
import 'package:e_commerce_app/features/home_screen/model/Prodacts_model.dart';
import 'package:e_commerce_app/features/home_screen/widgets/category_item_widget.dart';
import 'package:e_commerce_app/features/home_screen/widgets/product_item_widget.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCat = 'ALL';
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    context.read<ProdactsCubit>().fetchProdacts(forceRefresh: true);
    context.read<CategoriesCubit>().fetchCategories();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeightSpace(28),
          SizedBox(
            width: 335.w,
            child: Text("Discover", style: AppStyles.primaryHeadLinesStyle),
          ),
          const HeightSpace(16),
          Row(
            children: [
              CustomTextField(
                onChanged: (value) {
                  context.read<ProdactsCubit>().searchProdacts(
                    searchController.text,
                  );
                },
                controller: searchController,

                width: 270.w,
                hintText: "Search For Clothes",
              ),
              const WidthSpace(8),
              InkWell(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  context.read<ProdactsCubit>().searchProdacts(
                    searchController.text,
                  );
                },
                child: Container(
                  width: 56.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.search, color: Colors.white),
                ),
              ),
            ],
          ),
          const HeightSpace(16),

          BlocBuilder<CategoriesCubit, CategoriesState>(
            builder: (context, state) {
              if (state is CategoriesLodedState) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: state.categories.map((cat) {
                      return CategoryItemWidget(
                        categoryName: cat,
                        isSelected: selectedCat == cat ? true : false,
                        ontap: () {
                          setState(() {
                            selectedCat = cat;
                            if (selectedCat == "ALL") {
                              context.read<ProdactsCubit>().fetchProdacts(
                                forceRefresh: true,
                              );
                            } else {
                              context
                                  .read<ProdactsCubit>()
                                  .fetchProdactsCategories(cat);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
          const HeightSpace(16),
          BlocBuilder<ProdactsCubit, ProdactsState>(
            builder: (context, state) {
              if (state is ProdactsLodingState) {
                return Expanded(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 6,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.sp,
                      crossAxisSpacing: 16.sp,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // مكان الصورة
                              Expanded(
                                flex: 3,
                                child: Container(
                                  width: 150.w,
                                  height: 150.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16.r),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.all(12.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 12.h,
                                        color: Colors.white,
                                      ),
                                      Container(
                                        width: 80.w,
                                        height: 12.h,
                                        color: Colors.white,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 50.w,
                                            height: 14.h,
                                            color: Colors.white,
                                          ),
                                          Container(
                                            width: 30.w,
                                            height: 30.h,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              if (state is ProdactsLodedState) {
                List<ProdactsModel> products = state.products;
                return Expanded(
                  child: RefreshIndicator(
                    color: AppColors.primaryColor,
                    backgroundColor: Colors.white,
                    onRefresh: () async {
                      selectedCat = "ALL";
                      searchController.clear();
                      setState(() {});
                      context.read<ProdactsCubit>().fetchProdacts(
                        forceRefresh: true,
                      );
                    },
                    child: products.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(height: 150),
                              Center(child: Text("Not Found")),
                            ],
                          )
                        : AnimationLimiter(
                            child: GridView(
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 16.sp,
                                    crossAxisSpacing: 16.sp,
                                    childAspectRatio: 0.8,
                                  ),
                              children: products.asMap().entries.map((entry) {
                                final int index = entry.key;
                                final product = entry.value;

                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 700),
                                  child: SlideAnimation(
                                    verticalOffset: 50,
                                    child: FadeInAnimation(
                                      child: ProductItemWidget(
                                        src: product.images,
                                        title: product.title ?? "",
                                        price: product.price.toString(),
                                        onTap: () {
                                          GoRouter.of(context).pushNamed(
                                            AppRoutes.productScreen,
                                            extra: products[index],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                  ),
                );
              }

              return Center(child: Text("there is an error"));
            },
          ),
        ],
      ),
    );
  }
}
