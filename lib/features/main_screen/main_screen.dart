import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:e_commerce_app/core/utils/service_locator.dart';
import 'package:e_commerce_app/features/account/account_screen.dart';
import 'package:e_commerce_app/features/auth/cubit/auth_cubit.dart';
import 'package:e_commerce_app/features/cart/cart_screen.dart';
import 'package:e_commerce_app/features/cart/cubit/cart_cubit.dart';
import 'package:e_commerce_app/features/home_screen/Cubit/categories_cubit.dart';
import 'package:e_commerce_app/features/home_screen/Cubit/prodacts_cubit.dart';
import 'package:e_commerce_app/features/home_screen/home_screen.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  List<Widget> screens = [
    BlocProvider(create: (context) => sl<ProdactsCubit>(), child: HomeScreen()),
    CartScreen(),
    BlocProvider(create: (context) => sl<AuthCubit>(), child: AccountScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ProdactsCubit>()..fetchProdacts()),
        BlocProvider(
          create: (context) => sl<CategoriesCubit>()..fetchCategories(),
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          body: screens[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            unselectedItemColor: Colors.grey,
            elevation: 1,
            selectedItemColor: AppColors.primaryColor,
            currentIndex: currentIndex,
            onTap: (value) {
              setState(() {
                currentIndex = value;
              });
              if (value == 1) {
                context.read<CartCubit>().fetchCarts();
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 30.sp),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart, size: 30.sp),
                label: "Cart",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_3_outlined, size: 30.sp),
                label: "Account",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
