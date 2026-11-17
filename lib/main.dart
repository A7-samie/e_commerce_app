import 'package:e_commerce_app/core/routing/router_generation_config.dart';
import 'package:e_commerce_app/core/styling/theme_data.dart';
import 'package:e_commerce_app/core/utils/service_locator.dart';
import 'package:e_commerce_app/features/cart/cubit/cart_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  // ignore: await_only_futures
  WidgetsFlutterBinding.ensureInitialized();
  setupServiesLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) {
        return BlocProvider(
          create: (context) => sl<CartCubit>(),
          child: MaterialApp.router(
            title: 'Flutter Demo',
            theme: AppThemes.lightTheme,
            routerConfig: RouterGenerationConfig.goRouter,
          ),
        );
      },
    );
  }
}
