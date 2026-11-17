import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce_app/core/networking/api_endpoints.dart';
import 'package:e_commerce_app/core/networking/dio_helper.dart';
import 'package:e_commerce_app/core/utils/service_locator.dart';
import 'package:e_commerce_app/core/utils/storage_helper.dart';
import 'package:e_commerce_app/features/auth/model/login_respons_model.dart';

class AuthRepo {
  final DioHelper _dioHelper;
  AuthRepo(this._dioHelper);
  Future<Either<String, LoginResponsModel>> login(
      String username, String password) async {
    try {
      final response = await _dioHelper.postRequest(
        endPoint: ApiEndpoints.login,
        data: {
          "username": username,
          "password": password,
        },
      );

      // التأكد من أن الاستجابة موجودة وليست null
      if (
          (response.statusCode == 200 || response.statusCode == 201)) {
        LoginResponsModel loginResponsModel =
            LoginResponsModel.fromJson(response.data);
            if(loginResponsModel.accessToken != null){
   await sl<StorageHelper>().saveToken(loginResponsModel.accessToken!);
        return Right(loginResponsModel);
            }else{
              return left("Tokin is Null");
            }
         
      } else {
        return  Left(response.toString());
      }
    }  catch (error) {
      
      // استخراج رسالة الخطأ القادمة من السيرفر (مثل Invalid credentials)
  
      if(error is DioException){
        log('${error.response}');
        return  Left(error.response.toString());

      }
            return  Left(error.toString());

    } 
    
  }
}