// import 'dart:developer';

// import 'package:dartz/dartz.dart';
// import 'package:e_commerce_app/core/networking/api_endpoints.dart';
// import 'package:e_commerce_app/core/networking/dio_helper.dart';
// import 'package:e_commerce_app/features/cart/models/cart_model.dart';
// import 'package:e_commerce_app/features/home_screen/model/Prodacts_model.dart';

// class CartRepo {

//   final DioHelper _dioHelper;
//   CartRepo(this._dioHelper);
//   Future<Either<String,CartModel>> getUserCart() async{
//     try{
//       // ignore: prefer_interpolation_to_compose_strings
//       final response = await _dioHelper.getRequest(endPoint: ApiEndpoints.carts + "/user/2");
//       if(response.statusCode== 200){
//         CartModel cartModel =CartModel.fromJson(response.data[0]);
//         return Right(cartModel);
//       }else{
//         return Left(" Error is getting cart");
//       }
//     }catch(e){
//       log(e.toString());
//       return Left(e.toString())
//     ;}
//   }

//   Future<Either<String,CartModel>> addToCart({required ProdactsModel produat ,required int quantity,}) async{
//     try{
//       // ignore: prefer_interpolation_to_compose_strings
//       final response = await _dioHelper.putRequest(endPoint: ApiEndpoints.carts + "1", data: {
//         "userId":1,
//         "products":[
//           {
//             "id": produat.id,
//         "quantity": quantity,
//           }
//         ]
//       });
//       if(response.statusCode== 200){
//         CartModel cartModel =CartModel.fromJson(response.data);
//         return Right(cartModel);
//       }else{
//         return Left(" Error is getting cart");
//       }
//     }catch(e){
//       return Left(e.toString())
//     ;}
//   }
// }

import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:e_commerce_app/core/networking/api_endpoints.dart';
import 'package:e_commerce_app/core/networking/dio_helper.dart';
import 'package:e_commerce_app/features/cart/models/cart_model.dart';
import 'package:e_commerce_app/features/home_screen/model/Prodacts_model.dart';

class CartRepo {
  final DioHelper _dioHelper;
  CartRepo(this._dioHelper);

  Future<Either<String, CartModel>> getUserCart() async {
    try {
      final response = await _dioHelper.getRequest(
        endPoint: "${ApiEndpoints.carts}/user/2",
      );

      if (response.statusCode == 200) {
        final data = response.data;
        Map<String, dynamic> cartData;

        if (data is List) {
          if (data.isEmpty) return Left("Cart is empty");
          cartData = data[0] as Map<String, dynamic>;
        } else if (data is Map && data.containsKey('carts')) {
          List carts = data['carts'];
          if (carts.isEmpty) return Left("Cart is empty");
          cartData = carts[0] as Map<String, dynamic>;
        } else {
          cartData = data as Map<String, dynamic>;
        }

        CartModel cartModel = CartModel.fromJson(cartData);
        return Right(cartModel);
      } else {
        return Left("Error in getting cart");
      }
    } catch (e) {
      log(e.toString());
      return Left(e.toString());
    }
  }

  Future<Either<String, CartModel>> addToCart({
    required ProdactsModel product,
    required int quantity,
  }) async {
    try {
      final response = await _dioHelper.putRequest(
        endPoint: "${ApiEndpoints.carts}/1",
        data: {
          "userId": 1,
          "products": [
            {"id": product.id, "quantity": quantity},
          ],
        },
      );

      if (response.statusCode == 200) {
        CartModel cartModel = CartModel.fromJson(response.data);
        return Right(cartModel);
      } else {
        return Left("Error in updating cart");
      }
    } catch (e) {
      log(e.toString());
      return Left(e.toString());
    }
  }
}
