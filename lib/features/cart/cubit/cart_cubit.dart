// ignore: unused_import
import 'package:dartz/dartz.dart';
import 'package:e_commerce_app/features/cart/cubit/cart_state.dart';
import 'package:e_commerce_app/features/cart/models/cart_model.dart';
import 'package:e_commerce_app/features/cart/repo/cart_repo.dart';
import 'package:e_commerce_app/features/home_screen/model/Prodacts_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._cartRepo) : super(CartsInitialState());
  List<Product> _cartItems = [];
  final Set<int> _deletedProductIds = {};
  List<Product> _savedProducts = [];
  final List<int> _deletedIds = [];
  void setInitialProducts(List<Product> items) {
    if (_cartItems.isEmpty && _deletedProductIds.isEmpty) {
      _cartItems = List.from(items);
    }
  }

  final CartRepo _cartRepo;
  // ignore: strict_top_level_inference
  fetchCarts() async {
    emit(CartsLodingState());
    final res = await _cartRepo.getUserCart();
    res.fold(
      (error) {
        emit(CartsErrorState(error));
      },
      (cart) {
        emit(CartssucessState(cart));
      },
    );
  }

  // ignore: strict_top_level_inference, non_constant_identifier_names
  AddCarts({required ProdactsModel product, required int quantity}) async {
    emit(AddingToCartState());
    final res = await _cartRepo.addToCart(product: product, quantity: quantity);
    res.fold(
      (error) {
        emit(AddCartsErrorState(error));
      },
      (cart) {
        emit(AddCartssucessState(cart));
      },
    );
  }

  void removeProductAt(int index) {
    if (index >= 0 && index < _cartItems.length) {
      final removed = _cartItems[index];
      if (removed.id != null) {
        _deletedProductIds.add(removed.id!);
      }
      _cartItems.removeAt(index);

      if (state is CartssucessState) {
        final currentCart = (state as CartssucessState).cart;
        currentCart.products = List.from(_cartItems);
        emit(CartssucessState(currentCart));
      }
    }
  }

  void updateProductsList(List<Product> incomingProducts) {
    List<Product> filtered = [];
    for (int i = 0; i < incomingProducts.length; i++) {
      int? id = incomingProducts[i].id;
      if (id == null || !_deletedIds.contains(id)) {
        filtered.add(incomingProducts[i]);
      }
    }
    _savedProducts = filtered;
  }

  void deleteProductAt(int index) {
    if (index >= 0 && index < _savedProducts.length) {
      int? id = _savedProducts[index].id;
      if (id != null && !_deletedIds.contains(id)) {
        _deletedIds.add(id);
      }
      _savedProducts.removeAt(index);

      if (state is CartssucessState) {
        CartModel currentCart = (state as CartssucessState).cart;
        currentCart.products = List.from(_savedProducts);
        emit(CartssucessState(currentCart));
      }
    }
  }
}
