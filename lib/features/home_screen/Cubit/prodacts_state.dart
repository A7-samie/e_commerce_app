import 'package:e_commerce_app/features/home_screen/model/Prodacts_model.dart';

abstract class ProdactsState {}


class ProdactsInitialState extends ProdactsState{}


class ProdactsLodingState extends ProdactsState{}


class ProdactsLodedState extends ProdactsState{

  List<ProdactsModel> products;

  ProdactsLodedState(this.products);
  
}



class ProdactsErrorState extends ProdactsState {
  final String massage;
  ProdactsErrorState(this.massage);
}
