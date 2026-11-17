import 'package:dartz/dartz.dart';
import 'package:e_commerce_app/features/home_screen/Cubit/categories_state.dart';
import 'package:e_commerce_app/features/home_screen/repo/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit(this._homerepo):super(CategoriesInitialState());
  final Homerepo _homerepo ;

  void fetchCategories() async{
    emit(CategoriesLodingState());

    final Either<String,List<String>> res = await _homerepo.getCategories();
    res.fold((error){
      emit(CategoriesErrorState(error));
    },(categories){
      emit(CategoriesLodedState(categories));

    });

    
  }

}