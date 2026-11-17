import 'package:dartz/dartz.dart';
import 'package:e_commerce_app/features/home_screen/Cubit/categories_state.dart';
import 'package:e_commerce_app/features/home_screen/repo/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit(this._homerepo) : super(CategoriesInitialState());
  final Homerepo _homerepo;
  bool isLoaded = false;

  void fetchCategories({bool forceRefresh = false}) async {
    if (isLoaded && !forceRefresh) {
      return;
    }

    emit(CategoriesLodingState());

    final Either<String, List<String>> res = await _homerepo.getCategories();
    if (isClosed) return;

    res.fold(
      (error) {
        if (!isClosed) {
          emit(CategoriesErrorState(error));
        }
      },
      (categories) {
        if (!isClosed) {
          isLoaded = true;
          emit(CategoriesLodedState(categories));
        }
      },
    );
  }
}
