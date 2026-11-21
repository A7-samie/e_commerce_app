import 'package:e_commerce_app/core/networking/api_endpoints.dart';
import 'package:e_commerce_app/core/networking/dio_helper.dart';
import 'package:e_commerce_app/features/home_screen/model/Prodacts_model.dart';
import 'package:dartz/dartz.dart';
import 'package:e_commerce_app/features/home_screen/model/categories_model.dart';

class Homerepo {
  final DioHelper _dioHelper;
  Homerepo(this._dioHelper);

  Future<Either<String, List<ProdactsModel>>> getProdacts() async {
    try {
      final response = await _dioHelper.getRequest(
        endPoint: ApiEndpoints.products,
      );
      if (response.statusCode == 200) {
        List<ProdactsModel> prodacts = prodactsModelFromJson(response.data);
        return Right(prodacts);
      } else {
        return left("someThing went wrong");
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, List<ProdactsModel>>> getProdactsCategories(
    String catName,
  ) async {
    try {
      final response = await _dioHelper.getRequest(
        endPoint: "${ApiEndpoints.catProducts}$catName",
      );
      if (response.statusCode == 200) {
        List<ProdactsModel> prodacts = prodactsModelFromJson(response.data);
        return Right(prodacts);
      } else {
        return left("someThing went wrong");
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, List<String>>> getCategories() async {
    try {
      final response = await _dioHelper.getRequest(
        endPoint: ApiEndpoints.categories,
      );
      if (response.statusCode == 200) {
        List<String> categories = categoriesModelFromJson(response.data);
        categories.insert(0, "ALL");

        return Right(categories);
      } else {
        return left("someThing went wrong");
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, List<ProdactsModel>>> searchProdacts(
    String query,
  ) async {
    try {
      final response = await _dioHelper.getRequest(
        endPoint: "${ApiEndpoints.products}/search?q=$query",
      );
      if (response.statusCode == 200) {
        List<ProdactsModel> prodacts = prodactsModelFromJson(response.data);
        return Right(prodacts);
      } else {
        return left("someThing went wrong");
      }
    } catch (e) {
      return left(e.toString());
    }
  }
}
