import 'package:e_commerce_app/features/cart/models/cart_model.dart';

abstract class CartState {}

class CartsInitialState extends CartState {}

class CartsLodingState extends CartState {}

class CartssucessState extends CartState {
  final CartModel cart;
  CartssucessState(this.cart);
}

class CartsErrorState extends CartState {
  final String message;
  CartsErrorState(this.message);
}

// add
class AddingToCartState extends CartState {}

class AddCartssucessState extends CartState {
  final CartModel cart;

  AddCartssucessState(this.cart);
}

class AddCartsErrorState extends CartState {
  final String message;
  AddCartsErrorState(this.message);
}
