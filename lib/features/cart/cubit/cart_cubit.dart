// ignore: unused_import
import 'package:dartz/dartz.dart';
import 'package:e_commerce_app/features/cart/cubit/cart_state.dart';
import 'package:e_commerce_app/features/cart/models/cart_model.dart';
import 'package:e_commerce_app/features/cart/repo/cart_repo.dart';
import 'package:e_commerce_app/features/home_screen/model/Prodacts_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._cartRepo) : super(CartsInitialState());

  final CartRepo _cartRepo;
  List<int> deletedIds = [];

  // ignore: strict_top_level_inference
  fetchCarts() async {
    emit(CartsLodingState());
    final res = await _cartRepo.getUserCart();
    res.fold(
      (error) {
        emit(CartsErrorState(error));
      },
      (cart) {
        cart.products = _filterDeleted(cart.products ?? []);
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

  void addProductToCart(ProdactsModel prodact, int qty) {
    if (prodact.id != null) {
      deletedIds.remove(prodact.id);
    }

    Product newCartItem = Product(
      id: prodact.id,
      title: prodact.title,
      price: prodact.price,
      quantity: qty,
      total: (prodact.price ?? 0) * qty,
      thumbnail: prodact.thumbnail,
    );

    if (state is CartssucessState) {
      CartModel currentCart = (state as CartssucessState).cart;
      List<Product> updatedList = List.from(currentCart.products ?? []);
      updatedList.add(newCartItem);
      currentCart.products = _filterDeleted(updatedList);
      emit(CartssucessState(currentCart));
    } else {
      CartModel newCart = CartModel(products: [newCartItem]);
      emit(CartssucessState(newCart));
    }
  }

  void deleteProduct(Product product, List<Product> currentList) {
    if (product.id != null && !deletedIds.contains(product.id)) {
      deletedIds.add(product.id!);
    }

    if (state is CartssucessState) {
      CartModel currentCart = (state as CartssucessState).cart;
      currentCart.products = _filterDeleted(currentList);
      emit(CartssucessState(currentCart));
    }
  }

  List<Product> _filterDeleted(List<Product> items) {
    List<Product> result = [];
    for (int i = 0; i < items.length; i++) {
      int? id = items[i].id;
      if (id == null || !deletedIds.contains(id)) {
        result.add(items[i]);
      }
    }
    return result;
  }
}
