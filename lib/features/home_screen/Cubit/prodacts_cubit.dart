import 'package:dartz/dartz.dart';
import 'package:e_commerce_app/features/home_screen/Cubit/prodacts_state.dart';
import 'package:e_commerce_app/features/home_screen/model/Prodacts_model.dart';
import 'package:e_commerce_app/features/home_screen/repo/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProdactsCubit extends Cubit<ProdactsState> {
  ProdactsCubit(this._homerepo) : super(ProdactsInitialState());
  final Homerepo _homerepo;
  bool isLoaded = false;

  void fetchProdacts({bool forceRefresh = false}) async {
    if (isLoaded && !forceRefresh) {
      return;
    }
    emit(ProdactsLodingState());
    final Either<String, List<ProdactsModel>> res = await _homerepo
        .getProdacts();
    if (isClosed) return;

    res.fold(
      (error) {
        emit(ProdactsErrorState(error));
      },
      (right) {
        if (!isClosed) {
          isLoaded = true;
          emit(ProdactsLodedState(right));
        }
      },
    );
  }

  void fetchProdactsCategories(String catName) async {
    emit(ProdactsLodingState());
    final res = await _homerepo.getProdactsCategories(catName);
    if (isClosed) return;

    res.fold(
      (error) {
        if (!isClosed) {
          emit(ProdactsErrorState(error));
        }
      },
      (right) {
        if (!isClosed) {
          emit(ProdactsLodedState(right));
        }
      },
    );
  }
}
