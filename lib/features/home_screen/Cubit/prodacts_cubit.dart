import 'package:dartz/dartz.dart';
import 'package:e_commerce_app/features/home_screen/Cubit/prodacts_state.dart';
import 'package:e_commerce_app/features/home_screen/model/Prodacts_model.dart';
import 'package:e_commerce_app/features/home_screen/repo/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProdactsCubit extends Cubit<ProdactsState> {
ProdactsCubit(this._homerepo) :super (ProdactsInitialState());
final Homerepo _homerepo;

void fetchProdacts()async{
  emit(ProdactsLodingState());
  final Either<String,List<ProdactsModel>> res =await _homerepo.getProdacts();

  res.fold((error){
    emit(ProdactsErrorState(error));
  },(right){
    emit(ProdactsLodingState()); // أو اللودد حسب حالتك الصحيحة
    emit(ProdactsLodedState(right));
  }
  );
}
void fetchProdactsCategories(String catName)async{
  emit(ProdactsLodingState());
  final res =await _homerepo.getProdactsCategories(catName);
  res.fold((error)
  {
    emit(ProdactsErrorState(error));
  },(right){
        emit(ProdactsLodedState(right));

  }
  );
}

} 