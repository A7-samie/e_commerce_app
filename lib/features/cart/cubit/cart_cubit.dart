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

  final CartRepo _cartRepo;

  static const String _savedProductsKey = 'saved_cart_products';
  static const String _deletedIdsKey = 'deleted_cart_product_ids';

  List<Product> _savedProducts = [];
  final List<int> _deletedIds = [];

  Future<void> loadDeletedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList(_deletedIdsKey) ?? [];
    _deletedIds.clear();
    for (final item in savedList) {
      final parsed = int.tryParse(item);
      if (parsed != null && !_deletedIds.contains(parsed)) {
        _deletedIds.add(parsed);
      }
    }
    log('Deleted IDs: $_deletedIds');
  }

  Future<void> saveDeletedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final stringList = _deletedIds.map((id) => id.toString()).toList();
    await prefs.setStringList(_deletedIdsKey, stringList);
    log('Saved Deleted IDs: $stringList');
  }

  Future<void> loadsavedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString(_savedProductsKey);
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
    log('Loaded savedProducts: ${_savedProducts.length}');
  }

  Future<void> savedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      _savedProducts.map((item) => item.toJson()).toList(),
    );
    await prefs.setString(_savedProductsKey, encoded);
    log('Saved savedProducts: ${_savedProducts.length}');
  }

  Future<void> fetchCarts() async {
    emit(CartsLodingState());
    await loadDeletedIds();
    await loadsavedProducts();

    final res = await _cartRepo.getUserCart();
    res.fold(
      (error) {
        if (_savedProducts.isNotEmpty) {
          emit(
            CartssucessState(CartModel(products: List.from(_savedProducts))),
          );
        } else {
          emit(CartsErrorState(error));
        }
      },
      (cart) async {
        final List<Product> mergedProducts = [];

        for (final item in (cart.products ?? [])) {
          final id = item.id;
          if (id == null || !_deletedIds.contains(id)) {
            mergedProducts.add(item);
          }
        }

        for (final savedItem in _savedProducts) {
          final savedId = savedItem.id;
          if (savedId != null && !_deletedIds.contains(savedId)) {
            final alreadyExists = mergedProducts.any(
              (item) => item.id == savedId,
            );
            if (!alreadyExists) {
              mergedProducts.add(savedItem);
            }
          }
        }

        _savedProducts = mergedProducts;
        await savedProducts();
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

    if (product.id != null && _deletedIds.remove(product.id)) {
      await saveDeletedIds();
    }

    final res = await _cartRepo.addToCart(product: product, quantity: quantity);
    res.fold(
      (error) {
        emit(AddCartsErrorState(error));
      },
      (cart) async {
        final List<Product> filtered = [];
        for (final item in (cart.products ?? [])) {
          final id = item.id;
          if (id == null || !_deletedIds.contains(id)) {
            filtered.add(item);
          }
        }

        final isAddedProductInFiltered = filtered.any(
          (item) => item.id == product.id,
        );

        if (!isAddedProductInFiltered && product.id != null) {
          final double unitPrice = (product.price ?? 0).toDouble();
          final double itemTotal = unitPrice * quantity;
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

        final List<Product> mergedProducts = List.from(_savedProducts);
        for (final item in filtered) {
          final newId = item.id;
          final existingIndex = newId != null
              ? mergedProducts.indexWhere((element) => element.id == newId)
              : -1;

          if (existingIndex != -1) {
            mergedProducts[existingIndex] = item;
          } else {
            mergedProducts.add(item);
          }
        }

        _savedProducts = mergedProducts;
        await savedProducts();

        cart.products = List.from(_savedProducts);
        emit(AddCartssucessState(cart));
        emit(CartssucessState(cart));
      },
    );
  }

  Future<void> updateProductsList(List<Product> incomingProducts) async {
    _savedProducts = incomingProducts
        .where((item) => item.id == null || !_deletedIds.contains(item.id))
        .toList();
    await savedProducts();
  }

  Future<void> deleteProductAt(int index) async {
    if (index >= 0 && index < _savedProducts.length) {
      final id = _savedProducts[index].id;
      if (id != null && !_deletedIds.contains(id)) {
        _deletedIds.add(id);
        await saveDeletedIds();
      }
      _savedProducts.removeAt(index);
      await savedProducts();

      if (state is CartssucessState) {
        final currentCart = (state as CartssucessState).cart;
        currentCart.products = List.from(_savedProducts);
        emit(CartssucessState(currentCart));
      }
    }
  }
}
