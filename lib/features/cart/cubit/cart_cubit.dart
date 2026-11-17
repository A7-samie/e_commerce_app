// ignore: unused_import
import 'dart:convert';
import 'dart:developer';

import 'package:e_commerce_app/features/cart/cubit/cart_state.dart';
import 'package:e_commerce_app/features/cart/models/cart_model.dart';
import 'package:e_commerce_app/features/cart/repo/cart_repo.dart';
import 'package:e_commerce_app/features/home_screen/model/Prodacts_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._cartRepo) : super(CartsInitialState());
  List<Product> _cartItems = [];
  final Set<int> _deletedProductIds = {};
  List<Product> _savedProducts = [];
  final List<int> _deletedIds = [];

  Future<void> loadDeletedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('deleted_cart_product_ids') ?? [];
    _deletedIds.clear();
    for (final item in savedList) {
      final parsed = int.tryParse(item);
      if (parsed != null && !_deletedIds.contains(parsed)) {
        _deletedIds.add(parsed);
      }
    }
    log('Loaded deletedIds: $_deletedIds');
  }

  Future<void> saveDeletedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final stringList = _deletedIds.map((id) => id.toString()).toList();
    await prefs.setStringList('deleted_cart_product_ids', stringList);
    log('Saved deletedIds: $stringList');
  }

  void setInitialProducts(List<Product> items) {
    if (_cartItems.isEmpty && _deletedProductIds.isEmpty) {
      _cartItems = List.from(items);
    }
  }

  Future<void> loadsavedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString('saved_cart_products');
    _savedProducts.clear();
    if (rawJson != null && rawJson.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(rawJson);
      for (final item in decoded) {
        if (item is Map<String, dynamic>) {
          final prod = Product.fromJson(item);
          if (prod.id == null || !_deletedIds.contains(prod.id)) {
            _savedProducts.add(prod);
          }
        }
      }
    }
    log('Loaded _savedProducts count: ${_savedProducts.length}');
  }

  Future<void> savedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      _savedProducts.map((item) => item.toJson()).toList(),
    );
    await prefs.setString('saved_cart_products', encoded);
    log('Saved _savedProducts count: ${_savedProducts.length}');
  }

  final CartRepo _cartRepo;
  Future<void> fetchCarts() async {
    emit(CartsLodingState());
    await loadDeletedIds();
    await loadsavedProducts();
    final res = await _cartRepo.getUserCart();
    res.fold(
      (error) {
        emit(CartsErrorState(error));
      },
      (cart) {
        List<Product> filtered = [];
        for (int i = 0; i < (cart.products ?? []).length; i++) {
          int? id = cart.products![i].id;
          if (id == null || !_deletedIds.contains(id)) {
            filtered.add(cart.products![i]);
          }
        }
        List<Product> mergedProducts = List.from(filtered);
        for (int i = 0; i < _savedProducts.length; i++) {
          int? savedId = _savedProducts[i].id;
          if (savedId != null && !_deletedIds.contains(savedId)) {
            bool alreadyExists = mergedProducts.any(
              (item) => item.id == savedId,
            );
            if (!alreadyExists) {
              mergedProducts.add(_savedProducts[i]);
            }
          }
        }

        _savedProducts = mergedProducts;
        cart.products = List.from(_savedProducts);
        emit(CartssucessState(cart));
      },
    );
  }

  Future<void> addCarts({
    required ProdactsModel product,
    required int quantity,
  }) async {
    emit(AddingToCartState());
    if (product.id != null) {
      _deletedIds.remove(product.id);
      await saveDeletedIds();
    }
    final res = await _cartRepo.addToCart(product: product, quantity: quantity);
    res.fold(
      (error) {
        emit(AddCartsErrorState(error));
      },
      (cart) {
        List<Product> filtered = [];
        for (int i = 0; i < (cart.products ?? []).length; i++) {
          int? id = cart.products![i].id;
          if (id == null || !_deletedIds.contains(id)) {
            filtered.add(cart.products![i]);
          }
        }
        bool isAddedProductInFiltered = filtered.any(
          (item) => item.id == product.id,
        );
        if (!isAddedProductInFiltered && product.id != null) {
          double unitPrice = (product.price ?? 0).toDouble();
          double itemTotal = unitPrice * quantity;
          filtered.add(
            Product(
              id: product.id,
              title: product.title,
              price: unitPrice,
              quantity: quantity,
              total: itemTotal,
              discountPercentage: product.discountPercentage?.toDouble(),
              discountedTotal: itemTotal,
              thumbnail: product.thumbnail,
            ),
          );
        }
        List<Product> mergedProducts = List.from(_savedProducts);
        for (int i = 0; i < filtered.length; i++) {
          int? newId = filtered[i].id;
          int existingIndex = -1;
          if (newId != null) {
            existingIndex = mergedProducts.indexWhere(
              (item) => item.id == newId,
            );
          }
          if (existingIndex != -1) {
            mergedProducts[existingIndex] = filtered[i];
          } else {
            mergedProducts.add(filtered[i]);
          }
        }

        _savedProducts = mergedProducts;
        savedProducts();
        cart.products = List.from(_savedProducts);
        emit(AddCartssucessState(cart));
        emit(CartssucessState(cart));
      },
    );
  }

  void removeProductAt(int index) {
    if (index >= 0 && index < _cartItems.length) {
      final removed = _cartItems[index];
      if (removed.id != null) {
        _deletedProductIds.add(removed.id!);
        if (!_deletedIds.contains(removed.id!)) {
          _deletedIds.add(removed.id!);
          saveDeletedIds();
        }
        _savedProducts.removeWhere((item) => item.id == removed.id!);
        savedProducts();
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
    savedProducts();
  }

  void deleteProductAt(int index) async {
    if (index >= 0 && index < _savedProducts.length) {
      int? id = _savedProducts[index].id;
      if (id != null && !_deletedIds.contains(id)) {
        _deletedIds.add(id);
        await saveDeletedIds();
      }
      _savedProducts.removeAt(index);
      await savedProducts();

      if (state is CartssucessState) {
        CartModel currentCart = (state as CartssucessState).cart;
        currentCart.products = List.from(_savedProducts);
        emit(CartssucessState(currentCart));
      }
    }
  }
}
