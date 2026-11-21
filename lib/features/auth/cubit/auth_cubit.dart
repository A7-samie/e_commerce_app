import 'package:dartz/dartz.dart';
import 'package:e_commerce_app/core/utils/service_locator.dart';
import 'package:e_commerce_app/core/utils/storage_helper.dart';
import 'package:e_commerce_app/features/auth/cubit/auth_state.dart';
import 'package:e_commerce_app/features/auth/model/login_respons_model.dart';
import 'package:e_commerce_app/features/auth/repo/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepo) : super(AuthInitial());
  final AuthRepo _authRepo;
  void login({required String username, required String password}) async {
    emit(LodingAuthState());
    final Either<String, LoginResponsModel> res = await _authRepo.login(
      username,
      password,
    );
    res.fold(
      (error) {
        emit(ErrorAuthState(error));
      },
      (right) {
        emit(SuccessAuthState("Login Successfully"));
      },
    );
  }

  void logOutUsers() {
    sl<StorageHelper>().removeToken();
  }
}
