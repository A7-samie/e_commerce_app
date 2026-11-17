import 'package:e_commerce_app/core/networking/dio_helper.dart';
import 'package:e_commerce_app/core/utils/storage_helper.dart';
import 'package:e_commerce_app/features/auth/cubit/auth_cubit.dart';
import 'package:e_commerce_app/features/auth/repo/auth_repo.dart';
import 'package:e_commerce_app/features/cart/cubit/cart_cubit.dart';
import 'package:e_commerce_app/features/cart/repo/cart_repo.dart';
import 'package:e_commerce_app/features/home_screen/Cubit/categories_cubit.dart';
import 'package:e_commerce_app/features/home_screen/Cubit/prodacts_cubit.dart';
import 'package:e_commerce_app/features/home_screen/repo/home_repo.dart';
import 'package:get_it/get_it.dart';

GetIt sl =GetIt.instance;
void setupServiesLocator(){
  DioHelper dio =DioHelper();
// DioHelpper
  sl.registerSingleton<DioHelper>(dio);

  // storige helper
    sl.registerLazySingleton(() => StorageHelper());

  // Repos
  sl.registerLazySingleton(() => AuthRepo(sl<DioHelper>()),);
    sl.registerLazySingleton(() => Homerepo(sl<DioHelper>()),);
        sl.registerLazySingleton(() => CartRepo(sl<DioHelper>()),);


// Cubit
  sl.registerFactory(() => AuthCubit(sl<AuthRepo>()),);
    sl.registerFactory(() => ProdactsCubit(sl<Homerepo>()),);
        sl.registerFactory(() => CategoriesCubit(sl<Homerepo>()),);
                sl.registerFactory(() => CartCubit(sl<CartRepo>()),);



}