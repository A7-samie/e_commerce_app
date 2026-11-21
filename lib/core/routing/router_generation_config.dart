import 'package:e_commerce_app/features/cart/cart_screen.dart';
import 'package:e_commerce_app/features/splash_screen/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:e_commerce_app/core/routing/app_routes.dart';
import 'package:e_commerce_app/core/utils/service_locator.dart';
import 'package:e_commerce_app/features/address/address_screen.dart';
import 'package:e_commerce_app/features/auth/cubit/auth_cubit.dart';
import 'package:e_commerce_app/features/auth/login_screen.dart';
import 'package:e_commerce_app/features/auth/register_screen.dart';
import 'package:e_commerce_app/features/home_screen/model/Prodacts_model.dart';
import 'package:e_commerce_app/features/main_screen/main_screen.dart';
import 'package:e_commerce_app/features/product_screen/product_screen.dart';

class RouterGenerationConfig {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.splashScreen,
    routes: [
      GoRoute(
        name: AppRoutes.splashScreen,
        path: AppRoutes.splashScreen,
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        name: AppRoutes.loginScreen,
        path: AppRoutes.loginScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<AuthCubit>(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        name: AppRoutes.registerScreen,
        path: AppRoutes.registerScreen,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        name: AppRoutes.mainScreen,
        path: AppRoutes.mainScreen,
        builder: (context, state) => MainScreen(),
      ),
      GoRoute(
        name: AppRoutes.productScreen,
        path: AppRoutes.productScreen,
        builder: (context, state) {
          ProdactsModel productList = state.extra as ProdactsModel;
          return ProductScreen(product: productList);
        },
      ),
      GoRoute(
        name: AppRoutes.cartScreen,
        path: AppRoutes.cartScreen,
        builder: (context, state) => CartScreen(),
      ),
      GoRoute(
        name: AppRoutes.addressScreen,
        path: AppRoutes.addressScreen,
        builder: (context, state) => const AddressScreen(),
      ),
    ],
  );
}
