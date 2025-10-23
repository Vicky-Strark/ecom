import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecom/Features/auth/model/auth_model.dart';
import 'package:ecom/Core/core.dart';
import 'package:ecom/Shared/shared.dart';

class AuthRepository {



  Future<AuthModel> auth(String email, String password) async {
    try {
      var response = await ApiClient().apiPostWithoutToken(
          givenUrl: AppUrl.login,
          body: {
            "username": email,
            "password": password,
          });


      if (response is Map<String, dynamic>) {
        AppUtils().deBugPrint(val: response);
        return AuthModel.fromJson(response);
      } else {

        throw ServerException(response);
      }

    } on NetworkException {

      rethrow;

    } on ServerException {

      rethrow;

    } catch (e) {

      throw ServerException(e.toString());
    }
  }
}